import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/video_processor.dart';

import 'package:cogniopenapp/src/aws_video_response.dart';

class VideoResponseParser {
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
}
