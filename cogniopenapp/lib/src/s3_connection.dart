import 'dart:typed_data';

import 'package:aws_s3_api/s3-2006-03-01.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class S3Bucket {
  S3? connection;

  static final S3Bucket _instance = S3Bucket._internal();

  S3Bucket._internal() {
    startService();
  }

  factory S3Bucket() {
    return _instance;
  }

  Future<void> startService() async {
    await dotenv.load(fileName: ".env"); //load .env file variables

    connection = S3(
        region: 'us-east-1',
        credentials: AwsClientCredentials(
            accessKey: dotenv.get('accessKey'),
            secretKey: dotenv.get('secretKey')));
  }

  void createBucket() {
    Future<CreateBucketOutput> creating =
        connection!.createBucket(bucket: dotenv.get('videoS3Bucket'));

    creating.then((value) {
      print("Bucket is created");
    });
  }

  void addVideo(Uint8List content) {
    Future<PutObjectOutput> putting = connection!.putObject(
      bucket: dotenv.get('videoS3Bucket'),
      key: "test.txt",
      body: content,
    );

    putting.then((value) {
      print("content added to bucket.");
    });
  }
}
