// ignore_for_file: avoid_print, unused_element

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:aws_sns_api/sns-2010-03-31.dart';

class VideoProcessor {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  double confidence = 80;
  Rekognition? service;
  SNS? sns;
  String jobId = '';

  NotificationChannel? notes;
  String clientRequestToken = "donacdum";
  String jobTag = "devandtest";

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
    sns = SNS(
        region: dotenv.get('region'),
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
    //impotent method to create notification topic if not already created
    sns!.createTopic(name: dotenv.get('snsTopicName'));
    notes = NotificationChannel(
        roleArn: "arn:aws:iam::${dotenv.get('accountID')}:role/sns-role",
        sNSTopicArn:
            "arn:aws:sns:${dotenv.get('region')}:${dotenv.get('accountID')}:${dotenv.get('snsTopicName')}");

    print("Rekognition is up...");
  }

  Future<StartLabelDetectionResponse> sendRequestToProcessVideo(
      String title) async {
    //grab Video
    //TODO: allow parameters for bucket and video name
    Video video = Video(
        s3Object: S3Object(bucket: dotenv.get('videoS3Bucket'), name: title));
    //print(video.s3Object!.bucket.toString());
    //print(video.s3Object!.name.toString());
    //start label detection service of Video
    //The label detection operation is started by a call to StartLabelDetection which returns a job identifier
    Future<StartLabelDetectionResponse> job = service!.startLabelDetection(
      video: video,
      //clientRequestToken: clientRequestToken,
      //jobTag: jobTag,
      minConfidence: confidence,
    );
    //notificationChannel: notes);
    //jobId = job.jobId;
    job.then((value) {
      jobId = value.jobId!;
    });
    return job;
  }

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

  void pollForCompletedRequest() {
    Future<GetLabelDetectionResponse> labelsResponse =
        service!.getLabelDetection(jobId: jobId);

    //print the processed video results
    //helpful in debugging, as needed.
    //bool inProgress = true;
    //while (inProgress) {
    labelsResponse.then((value) {
      if (value.jobStatus == VideoJobStatus.inProgress) {
        //keep looping
      } else if (value.jobStatus == VideoJobStatus.succeeded) {
        //stop looping
        //inProgress = false;
        print(value.statusMessage);
      } else if (value.jobStatus == VideoJobStatus.failed) {
        //stop looping, but print message.
        //inProgress = false;
        print(value.statusMessage);
      }
      print(value.jobStatus);
    });
    //}

    print(jobId);
    //TODO: default value until we get tied into the Notifications
    //jobId = "c6066a5db28405887230197d6b668fb7523097cf057c5efaccfdd7c3af7432fe";
    //jobId = "e647f111e80cefa919298c86b518b0f5ee4d805b722493ca4492f26770840993";
    //jobId = "8728b1791baec4ca41f218f4713f651dca97c3971a7bd6bb8f6fb515093ac185";
  }

  Future<GetLabelDetectionResponse> grabResults(jobId) {
    //get a specific job in debuggin
    Future<GetLabelDetectionResponse> labelsResponse =
        service!.getLabelDetection(jobId: jobId);

    //print the processed video results
    //helpful in debugging, as needed.
    /*labelsResponse.then((value) {
      print(value.videoMetadata);
    });
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
}
