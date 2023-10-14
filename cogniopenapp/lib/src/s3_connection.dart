// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class S3Bucket {
  S3? connection;

  static final S3Bucket _instance = S3Bucket._internal();

  S3Bucket._internal() {
    startService().then((value) {
      createBucket();
    });
  }

  factory S3Bucket() {
    return _instance;
  }

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables

    connection = S3(
        //this region is hard-coded because the 'us-east-2' region would not run/load.
        region: dotenv.get('region'),
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
    //TODO:debug/testing statements
    print("S3 is connected...");
  }

  void createBucket() {
    //impotent method that creates bucket if it is not already present.
    Future<CreateBucketOutput> creating =
        connection!.createBucket(bucket: dotenv.get('videoS3Bucket'));
    //TODO:debug/testing statements
    creating.then((value) {
      print("Bucket is created");
    });
  }

  //adds the Video to the S3 bucket
  //if the file already exists with that name, it is overwritten
  //method returns the name of the file being uploaded (used in queueing the object detection)
  Future<String> addVideo(String title, Uint8List content) async {
    await connection!.putObject(
      bucket: dotenv.get('videoS3Bucket'),
      key: title,
      body: content,
    );
    //TODO:debug/testing statements
    print("content added to bucket.");
    return title;
  }
}
