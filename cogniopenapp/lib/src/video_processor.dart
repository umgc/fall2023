// ignore_for_file: avoid_print

import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/aws_video_response.dart';
import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/utils/format_utils.dart';
import 'dart:core';

class VideoProcessor {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  double confidence = 85;
  Rekognition? service;
  String jobId = '';
  String projectArn = 'No project found';
  String currentProjectVersionArn = 'Model not started';

  Stopwatch stopwatch = Stopwatch();

  List<String> excludedResponses = [
    "Male",
    "Adult",
    "Man",
    "Female",
    "Woman",
    "Person",
    "Baby"
  ];

  VideoProcessor() {
    FormatUtils.printBigMessage("Starting to process another video");
  }

  String getElapsedTimeInSeconds() {
    final seconds = stopwatch.elapsedMilliseconds / 1000.0;
    return 'Elapsed time: ${seconds.toStringAsFixed(2)} seconds';
  }

  VideoResponse? getRequestedResponse(String searchTitle) {
    for (int i = DataService.instance.responseList.length - 1; i >= 0; i--) {
      if (DataService.instance.responseList[i].title == searchTitle) {
        return DataService.instance.responseList[i];
      }
    }
    return null;
  }

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables

    String region = (dotenv.get('region', fallback: "none"));
    String access = (dotenv.get('accessKey', fallback: "none"));
    String secret = (dotenv.get('secretKey', fallback: "none"));

    if (region == "none" || access == "none" || secret == "none") {
      print("S3 needs to be initialized");
      return;
    }
    service = Rekognition(
        region: region,
        credentials:
            AwsClientCredentials(accessKey: access, secretKey: secret));

    createProject();
    //TODO:debug/testing statements
    print("Rekognition is up...");
  }

  Future<void> automaticallySendToRekognition() async {
    await startService();

    stopwatch.reset();
    stopwatch.start();
    await uploadVideoToS3();

    await pollForCompletedRequest();

    GetLabelDetectionResponse labelResponses = await grabResults(jobId);

    List<AWS_VideoResponse> responses =
        await createResponseList(labelResponses);

    await DataService.instance.addVideoResponses(responses);
    FormatUtils.printBigMessage("Rekognition results saved locally.");
    FormatUtils.printBigMessage(" Time elapsed ${getElapsedTimeInSeconds()}");
  }

  Future<StartLabelDetectionResponse> sendRequestToProcessVideo(
      String title) async {
    print("sending rekognition request for ${title}");
    //grab Video
    Video video = Video(
        s3Object: S3Object(bucket: dotenv.get('videoS3Bucket'), name: title));
    //start label detection service of Video
    //The label detection operation is started by a call to StartLabelDetection which returns a job identifier
    Future<StartLabelDetectionResponse> job = service!.startLabelDetection(
      video: video,
      minConfidence: confidence,
    );
    //set the jobId, but return the whole job.
    job.then((value) {
      jobId = value.jobId!;
      print("Job ID IS ${jobId}");
    });
    return job;
  }

  List<AWS_VideoResponse> createTestResponseList() {
    return [
      /* 
    AWS_VideoResponse('Water', 100, 52852, "fake file"),
    AWS_VideoResponse('Aerial View', 96.13745880126953, 53353, "fake file"),
    AWS_VideoResponse('Animal', 86.5937728881836, 53353, "fake file"),
    AWS_VideoResponse('Coast', 99.99983215332031, 53353, "fake file"), */
      AWS_VideoResponse.overloaded(
          'Fish',
          90.63278198242188,
          53353,
          ResponseBoundingBox(
              left: 0.11934830248355865,
              top: 0.7510809302330017,
              width: 0.05737469345331192,
              height: 0.055630747228860855),
          "2023-10-27_12:19:21.819024.mp4"),
      // Add more test objects for other URLs as needed
    ];
  }

  List<AWS_VideoResponse> createResponseList(
      GetLabelDetectionResponse response) {
    FormatUtils.printBigMessage("CREATING RESPONSE LIST");
    List<AWS_VideoResponse> responseList = [];

    FileManager.getMostRecentVideo();
    String responseVideo = FileManager.mostRecentVideoPath;

    Iterator<LabelDetection> iter = response.labels!.iterator;
    print("ABOUT TO START PARSING RESPONSES");
    while (iter.moveNext()) {
      for (Instance inst in iter.current.label!.instances!) {
        String? name = iter.current.label!.name;

        if (excludedResponses.contains(name)) {
          continue;
        }

        AWS_VideoResponse newResponse = AWS_VideoResponse.overloaded(
            iter.current.label!.name ?? "default value",
            iter.current.label!.confidence ?? 80,
            iter.current.timestamp ?? 0,
            ResponseBoundingBox(
                left: inst.boundingBox!.left ?? 0,
                top: inst.boundingBox!.top ?? 0,
                width: inst.boundingBox!.width ?? 0,
                height: inst.boundingBox!.height ?? 0),
            responseVideo);
        responseList.add(newResponse);
      }
    }
    FormatUtils.printBigMessage("RESPONSE LIST WAS CREATED");

    return responseList;
  }

  Future<String> pollForCompletedRequest() async {
    FormatUtils.printBigMessage("POLLING FOR COMPLETED REQUEST");
    //keep polling the getLabelDetection until either failed or succeeded.
    bool inProgress = true;
    //jobId = "43842f1617dfa32ac8fb7b21becabacd8736556c195630711b4b901ca8b9e08f";
    while (inProgress) {
      FormatUtils.printBigMessage("STILL POLLING ${getElapsedTimeInSeconds()}");
      GetLabelDetectionResponse labelsResponse =
          await service!.getLabelDetection(jobId: jobId);
      //a little sleep thrown in here to limit the number of requests.
      sleep(const Duration(milliseconds: 5000));
      if (labelsResponse.jobStatus == VideoJobStatus.succeeded) {
        //stop looping
        inProgress = false;
      } else if (labelsResponse.jobStatus == VideoJobStatus.failed) {
        //stop looping, but print error message.
        inProgress = false;
        //TODO:debug/testing statements
        print(labelsResponse.statusMessage);
      }
    }
    FormatUtils.printBigMessage("POLLING WAS COMPLETED JOB ID ${jobId}");
    return jobId;
  }

  Future<GetLabelDetectionResponse> grabResults(jobId) async {
    FormatUtils.printBigMessage("GRABBING RESULTS");

    //get a specific job in debuggin
    Future<GetLabelDetectionResponse> labelsResponse =
        service!.getLabelDetection(jobId: jobId);

    FormatUtils.printBigMessage("RESULTS GRABBED");
    return labelsResponse;
  }

  Future<void> uploadVideoToS3() async {
    FormatUtils.printBigMessage("UPLOADING VIDEO TO S3");
    S3Bucket s3 = S3Bucket();
    // Set the name for the file to be added to the bucket based on the file name
    FileManager.getMostRecentVideo();
    String title = FileManager.mostRecentVideoName;
    //TODO:debug/testing statements
    print("Video to S3: $title");
    print("Video path to S3: ${FileManager.mostRecentVideoPath}");

    String uploadedVideo =
        await s3.addVideoToS3(title, FileManager.mostRecentVideoPath);

    await sendRequestToProcessVideo(uploadedVideo);

    FormatUtils.printBigMessage("VIDEO WAS UPLOADED");
  }

  //create a new Amazon Rekognition Custom Labels project
  //checks if one exists, and if so, sets that projectARN as the current projectArn
  //if one does not exists, creates one and set that projectARN as the current projectArn for later polling.
  void createProject() {
    String projectName = "cogni-open";
    bool projectDoesNotExists = true;
    Future<DescribeProjectsResponse> checkForProject =
        service!.describeProjects();

    checkForProject.then((value) {
      Iterator<ProjectDescription> iter = value.projectDescriptions!.iterator;
      while (iter.moveNext()) {
        //print(iter.current.projectArn);
        if (iter.current.projectArn!.contains(projectName)) {
          //print("Project found");
          projectDoesNotExists = false;
          projectArn = iter.current.projectArn!;
        }
      }

      if (projectDoesNotExists) {
        Future<CreateProjectResponse> projectResponse =
            service!.createProject(projectName: projectName);
        projectResponse.then((value) {
          projectArn = value.projectArn!;
          //print(projectArn);
        });
      }
    });

    //print(projectArn);
  }

  //needs a modelName ("my glasses"), and the title of the input manifest file in S3 bucket
  void addNewModel(String modelName, String title) {
    List<Asset> assets = [];
    //TODO: create some sort of loop given the significant object to create the manifest for training data
    //Asset is a manifest file (that has the s3 images and bounding box information)
    Asset sigObj = Asset(
        groundTruthManifest: GroundTruthManifest(
            s3Object:
                S3Object(bucket: dotenv.get('videoS3Bucket'), name: title)));
    assets.add(sigObj);

    service!.createProjectVersion(
        outputConfig: OutputConfig(
            s3Bucket: dotenv.get('videoS3Bucket'),
            //dumps files from the model process(es) into a new folder
            s3KeyPrefix: "custom-labels"),
        projectArn: projectArn,
        testingData: TestingData(autoCreate: true),
        trainingData: TrainingData(assets: assets),
        versionName: modelName);
  }

  //check for a certain status (depending on input)
  void pollVersionDescription() {
    //String status) {
    Future<DescribeProjectVersionsResponse> projectVersions =
        service!.describeProjectVersions(projectArn: projectArn);
    projectVersions.then((value) {
      Iterator<ProjectVersionDescription> iter =
          value.projectVersionDescriptions!.iterator;
      while (iter.moveNext()) {
        print("${iter.current.projectVersionArn} is ${iter.current.status}");
        //deletes a model if it failed training
        if (iter.current.status == ProjectVersionStatus.trainingFailed) {
          service!.deleteProjectVersion(
            projectVersionArn: iter.current.projectVersionArn!,
          );
        }
      }
    });
  }

  //start the inference of custom labels
  //can return a null if no such label is found (or if it failed training)
  String? startCustomDetection(String labelName) {
    //given an object label, check that the version is ready (i.e., trained)
    String? modelArn;
    //get all models in the project
    Future<DescribeProjectVersionsResponse> projectVersions =
        service!.describeProjectVersions(projectArn: projectArn);
    projectVersions.then((value) async {
      Iterator<ProjectVersionDescription> iter =
          value.projectVersionDescriptions!.iterator;
      while (iter.moveNext()) {
        //find model like the label name
        if (iter.current.projectVersionArn!.contains(labelName)) {
          //check that the model is either trained or stopped
          if (iter.current.status == ProjectVersionStatus.trainingCompleted ||
              iter.current.status == ProjectVersionStatus.stopped) {
            //start the model
            StartProjectVersionResponse response = await service!
                .startProjectVersion(
                    minInferenceUnits: 1,
                    projectVersionArn: iter.current.projectVersionArn!);
            print(response.status);
            //returns the modelArn of the projectVersion being started
            //still need to poll the that the model has started
            return iter.current.projectVersionArn;
          }
        }
      }
    });
    return modelArn;
  }

  //stop the inference of custom labels
  String? stopCustomDetection(String labelName) {
    String? modelArn;
    //given an object label, check that the version is ready (i.e., trained)
    //get all models in the project
    Future<DescribeProjectVersionsResponse> projectVersions =
        service!.describeProjectVersions(projectArn: projectArn);
    projectVersions.then((value) async {
      Iterator<ProjectVersionDescription> iter =
          value.projectVersionDescriptions!.iterator;
      while (iter.moveNext()) {
        //find model like the label name
        if (iter.current.projectVersionArn!.contains(labelName)) {
          //check that the model is running
          if (iter.current.status == ProjectVersionStatus.running) {
            //stop the model
            StopProjectVersionResponse response = await service!
                .stopProjectVersion(
                    projectVersionArn: iter.current.projectVersionArn!);
            print(response.status);
            //returns the modelArn of the projectVersion being stopped
            //still need to poll the that the model has finished stopping
            return iter.current.projectVersionArn;
          }
        }
      }
    });
    return modelArn;
  }

  // When I wrote this, only God and I understood what I was doing
  // Now only God knows.
  // run Rekognition custom label detection on a specified set of images
  Future<DetectCustomLabelsResponse?> findMatchingModel(
      String labelName) async {
    //look for a similar project version (model to match the label from the user)
    DescribeProjectVersionsResponse projectVersions =
        await service!.describeProjectVersions(projectArn: projectArn);
    bool search = true;
    //get together list of images to check against
    //projectVersions.then((value) {
    Iterator<ProjectVersionDescription> iter =
        projectVersions.projectVersionDescriptions!.iterator;
    while (iter.moveNext() & search) {
      //find model like the label name
      if (iter.current.projectVersionArn!.contains(labelName)) {
        //run the search for custom labels
        currentProjectVersionArn = iter.current.projectVersionArn!;
        search = false;
        return service!.detectCustomLabels(
            image: Image(
                s3Object: S3Object(
                    bucket: dotenv.get('videoS3Bucket'),
                    name: "eyeglass-green.jpg")),
            projectVersionArn: currentProjectVersionArn);
      }
    }
    if (search) {
      return null;
    }
  }
}
