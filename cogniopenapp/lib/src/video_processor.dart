// ignore_for_file: avoid_print, unused_element

import 'dart:typed_data';

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
//import 'package:aws_sns_api/sns-2010-03-31.dart';
import 'dart:io';

import 'galleryData.dart';
import 's3_connection.dart';

class VideoProcessor {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  double confidence = 85;
  Rekognition? service;
  String jobId = '';

  String clientRequestToken = "donacdum";
  String jobTag = "chainsHoxton4ever";

  static final VideoProcessor _instance = VideoProcessor._internal();

  VideoProcessor._internal() {
    startService().then((value) {});
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

    //print the processed video results
    //helpful in debugging, as needed.
    /*
    labelsResponse.then((value) {
      Iterator<LabelDetection> iter = value.labels!.iterator;
      while (iter.moveNext()) {
        print("Timestamp: ${iter.current.timestamp}");
        print("Name: ${iter.current.label?.name}");
        for (Instance inst in iter.current.label!.instances!) {
          //bounding Box information is given in decimal form
          //left=0.2 means the initial x-coordinate is 20% from left of frame
          // a frame of width 1000 would mean left=200 px from left
          print("Bounding Box: Left: ${inst.boundingBox!.left}"
              " Top: ${inst.boundingBox!.top}"
              " Width: ${inst.boundingBox!.width}"
              " Height: ${inst.boundingBox!.height}");
          print("Instance Confidence: ${inst.confidence}");
        }
        print("Confidence: ${iter.current.label?.confidence}");
        //ignoring the parents
        //parents may be used later if object can't be found (where are my clothes? vs where are my jeans?)
        /*
        print("Parents: ");
        for (Parent rent in iter.current.label!.parents!) {
          print("Parent: ${rent.name}");
        }
        */
      }
    });
    */
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
}
