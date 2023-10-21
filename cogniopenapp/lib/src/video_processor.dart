// ignore_for_file: avoid_print, unused_element

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart';
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
  String projectArn = '';

  static final VideoProcessor _instance = VideoProcessor._internal();

  VideoProcessor._internal() {
    startService().then((value) {});
    createProject();
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
  void createProject() {
    String projectName = "cogniopen";
    service!.createProject(projectName: projectName);
    projectArn =
        "arn:aws:rekognition:${dotenv.get('region')}:${dotenv.get('accountID')}:project/$projectName";
  }

  //needs a modelName ("my glasses"), and the title of the input file(s)
  void addNewModel(String modelName, String title) {
    List<Asset> assets = [];
    //TODO: create some sort of loop given the significant object to create a list of Assets for training data
    Asset sigObj = Asset(
        groundTruthManifest: GroundTruthManifest(
            s3Object:
                S3Object(bucket: dotenv.get('videoS3Bucket'), name: title)));
    assets.add(sigObj);

    service!.createProjectVersion(
        outputConfig: OutputConfig(
            s3Bucket: dotenv.get('videoS3Bucket'),
            s3KeyPrefix: "custom-labels"),
        projectArn: projectArn,
        testingData: TestingData(autoCreate: true),
        trainingData: TrainingData(assets: assets),
        versionName: modelName);
  }

  //check for a certain status (depending on input)
  void pollVersionDescription(String status) {
    //service.describeProjectVersions
  }

  //start the inference of custom labels
  void startCustomDetection() {
    //service.startProjectVersion
  }

  //stop the inference of custom labels
  void stopCustomDetection() {
    //service.stopProjectVersion
  }

  //run Rekognition custom label detection on a specified set of images
  void searchForSignificantObject() {
    //service.detectCustomeLabel
  }
}
