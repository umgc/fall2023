// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:typed_data';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

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

    String region = (dotenv.get('region', fallback: "none"));
    String access = (dotenv.get('accessKey', fallback: "none"));
    String secret = (dotenv.get('secretKey', fallback: "none"));

    if (region == "none" || access == "none" || secret == "none") {
      print("S3 needs to be initialized");
      return;
    }

    connection = S3(
        //this region is hard-coded because the 'us-east-2' region would not run/load.
        region: region,
        credentials:
            AwsClientCredentials(accessKey: access, secretKey: secret));
    //TODO:debug/testing statements
    print("S3 is connected...");
  }

  void createBucket() {
    String bucket = (dotenv.get('videoS3Bucket', fallback: "none"));

    if (bucket == "none") {
      print("S3 needs to be initialized");
      return;
    }
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

  Future<String> addImageToS3(String title, String filepath) async {
    // TODO Specify folder structure
    Uint8List bytes = File(filepath).readAsBytesSync();
    return _addToS3("/images/$title", bytes);
  }

  Future<String> addFileToS3(String title, String manifest) async {
    // TODO Specify folder structure
    List<int> list = utf8.encode(manifest);
    Uint8List bytes = Uint8List.fromList(list);
    //use utf8.decode(bytes) to bring back into String.
    return _addToS3(title, bytes);
  }

  // Adds the file to the S3 bucket
  Future<String> addVideoToS3(String title, String localPath) {
    // TODO Specify folder structure
    print("ADDING THIS TO S3 ${title}");
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
    print("content added to bucket: ${formattedTitle}");
    return title;
  }

  // Delete file from S3
  Future<bool> deleteFileFromS3(String key) async {
    try {
      await connection!
          .deleteObject(bucket: dotenv.get('videoS3Bucket'), key: key);
      return true;
    } catch (e) {
      print('Failed to delete the file from S3: $e');
      return false;
    }
  }
}
