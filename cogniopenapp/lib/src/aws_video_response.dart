import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class AWS_VideoResponse {
  String name;
  double confidence;
  int timestamp;
  ResponseBoundingBox boundingBox;
  String referenceVideoFilePath;
  String parents;

  Image exampleImage = Image.network(
      "https://cdn.pixabay.com/photo/2014/06/03/19/38/road-sign-361514_1280.png");

  AWS_VideoResponse.overloaded(this.name, this.confidence, this.timestamp,
      this.boundingBox, this.referenceVideoFilePath, this.parents) {
    //setImage(timestamp);
  }

  Future<Image> getImage() async {
    return await FileManager.getThumbnail(
        FileManager.mostRecentVideoPath, timestamp);
  }

  void setImage(int timeStampNew) async {
    exampleImage = await FileManager.getThumbnail(
        FileManager.mostRecentVideoPath, timeStampNew);
  }
}

class ResponseBoundingBox {
  double left;
  double top;
  double width;
  double height;

  ResponseBoundingBox(
      {required this.left,
      required this.top,
      required this.width,
      required this.height});

  @override
  String toString() {
    return 'ResponseBoundingBox{left: $left, top: $top, width: $width, height: $height}';
  }
}
