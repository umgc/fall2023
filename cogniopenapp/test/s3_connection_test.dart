//import 'dart:js_util';

//import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'mocks/s3_connection_test.mocks.dart';

@GenerateNiceMocks([MockSpec<S3Bucket>()])
@GenerateNiceMocks([MockSpec<S3>()])
void main() {
  final s3Bucket = MockS3Bucket();

  test('s3 bucket created', () async {
    s3Bucket.createBucket;
    expect(s3Bucket.connection, null);
    expect(s3Bucket.toString(), "MockS3Bucket");

    when(s3Bucket.addAudioToS3('testAudio', '\some\localPath'))
        .thenAnswer((_) => Future.value(''));

    when(s3Bucket.addAudioToS3(
            'testAudio', '\assets\test_images\Sea waves.mp4'))
        .thenAnswer((_) => Future.value('testAudio'));

    verifyNever(s3Bucket.addAudioToS3('testAudio', '\some\localPath'));
  });
/*
  // Try to create the Amazon S3 Bucket if not already there
  S3Bucket? CogniOpenS3Bucket;

  // Make sure that the S3 Bucket is there.  Note, if the Bucket already existed this would give
  // a false positive response that the function worked above.
  test("Verify that S3 bucket is available", () async {
    var bucketLocation = await CogniOpenS3Bucket!.connection!.getBucketLocation(bucket: "foo");
    expect(bucketLocation, "us-east-1");
  });
  */
}
