// ignore_for_file: avoid_print, unused_element

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
//import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:cogniopenapp/src/galleryData.dart';
import 'package:cogniopenapp/src/s3_connection.dart';

class VideoProcessor {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  double confidence = 85;
  Rekognition? service;
  String jobId = '';
  String projectArn = 'No project found';

  static final VideoProcessor _instance = VideoProcessor._internal();

  VideoProcessor._internal() {
    startService().then((value) {
      createProject();
    });
  }

  factory VideoProcessor() {
    return _instance;
  }

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables
    service = Rekognition(
        region: dotenv.get('region'),
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
    //TODO:debug/testing statements
    print("Rekognition is up...");
  }

  Future<StartLabelDetectionResponse> sendRequestToProcessVideo(
      String title) async {
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
    });
    return job;
  }
  /* Deprecated but kept as failsafe
  Future<StartLabelDetectionResponse> sendRequestToProcessVideoOld() async {
    //grab Video
    //TODO: allow parameters for bucket and video name
    Video video = Video(
        s3Object: S3Object(
            bucket: dotenv.get('videoS3Bucket'),
            name:
                "Sea waves & beach drone video _ Free HD Video - no copyright.mp4"));

    //start label detection service of Video
    //The label detection operation is started by a call to StartLabelDetection which returns a job identifier
    Future<StartLabelDetectionResponse> job =
        service!.startLabelDetection(video: video, minConfidence: confidence);

    return job;
  }
  */

  Future<String> pollForCompletedRequest() async {
    //keep polling the getLabelDetection until either failed or succeeded.
    bool inProgress = true;
    while (inProgress) {
      //print("start loop");
      GetLabelDetectionResponse labelsResponse =
          await service!.getLabelDetection(jobId: jobId);
      //a little sleep thrown in here to limit the number of requests.
      sleep(const Duration(milliseconds: 250));
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
    return jobId;
  }

  Future<GetLabelDetectionResponse> grabResults(jobId) {
    //get a specific job in debuggin
    Future<GetLabelDetectionResponse> labelsResponse =
        service!.getLabelDetection(jobId: jobId);
    return labelsResponse;
  }

  void uploadVideoToS3() {
    S3Bucket s3 = S3Bucket();
    // Set the name for the file to be added to the bucket based on the file name
    String title = GalleryData.mostRecentVideoName;
    //TODO:debug/testing statements
    print("Video to S3: ${title}");

    Future<String> uploadedVideo =
        s3.addVideoToS3(title, GalleryData.mostRecentVideoPath);
    uploadedVideo.then((value) async {
      await sendRequestToProcessVideo(value);
    });
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

  //run Rekognition custom label detection on a specified set of images
  void searchForSignificantObject() {
    //service.detectCustomeLabel
  }
}
