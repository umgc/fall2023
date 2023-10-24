// ignore_for_file: avoid_print

import 'dart:typed_data';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

import 'package:cogniopenapp/src/utils/file_manager.dart';

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

  Future<String> addAudioToS3(String title, String localPath) {
    // TODO Specify folder structure
    Uint8List bytes = File(localPath).readAsBytesSync();
    return _addToS3(title, bytes);
  }

  // Adds the file to the S3 bucket
  Future<String> addVideoToS3(String title, String localPath) {
    // TODO Specify folder structure
    Uint8List bytes = File(localPath).readAsBytesSync();
    return _addToS3(title, bytes);
  }

  //adds the Video to the S3 bucket
  //if the file already exists with that name, it is overwritten
  //method returns the name of the file being uploaded (used in queueing the object detection)
  Future<String> _addToS3(String title, Uint8List content) async {
    // TODO: Add logic to detect file type and create a folder
    // .mp3 files go to bucket/audio, .mp4 files go to bucket/audio
    String formattedTitle = FileManager.getFileNameForAWS(title);
    await connection!.putObject(
      bucket: dotenv.get('videoS3Bucket'),
      key: formattedTitle,
      body: content,
    );
    //TODO:debug/testing statements
    print("content added to bucket.");
    return title;
  }
}
