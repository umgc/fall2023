// ignore_for_file: avoid_print, unused_element

import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class VideoProcessor {
  //confidence setting for AWS Rekognition label detection service
  //(default is 50; the higher the more confident - and thus better and fewer results)
  double confidence;
  Rekognition? service;
  String jobId = "";

  VideoProcessor(this.confidence);

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables
    service = Rekognition(
        //TODO?: put region var in environment file?
        region: 'us-east-2',
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
  }

  Future<StartLabelDetectionResponse> sendRequestToProcessVideo() async {
    //grab Video
    //TODO: allow parameters for bucket and video name
    Video video = Video(
        s3Object: S3Object(
            bucket: "cogniopen-videos",
            name:
                "Sea waves & beach drone video _ Free HD Video - no copyright.mp4"));

    //start label detection service of Video
    //The label detection operation is started by a call to StartLabelDetection which returns a job identifier
    Future<StartLabelDetectionResponse> job =
        service!.startLabelDetection(video: video, minConfidence: confidence);

    return job;
  }

  void pollForCompletedRequest() {
    //TODO: default value until we get tied into the Notifications
    String jobId =
        "c6066a5db28405887230197d6b668fb7523097cf057c5efaccfdd7c3af7432fe";

    //poll for completed job
    //NotificationChannel

    //When the label detection operation finishes,
    //Amazon Rekognition publishes a completion status to the
    //Amazon Simple Notification Service topic registered in the initial call to StartlabelDetection
    this.jobId = jobId;
  }

  Future<GetLabelDetectionResponse> grabResults(jobId) {
    //get a specific job in debuggin
    Future<GetLabelDetectionResponse> labelsResponse =
        service!.getLabelDetection(jobId: jobId);

    //print the processed video results
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
    return labelsResponse;
  }
}
