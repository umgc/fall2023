import 'package:flutter/material.dart';

class VideoResponse {
  String name;
  double confidence;
  int timestamp;
  ResponseBoundingBox? boundingBox;
  Image exampleImage = Image.network(
      "https://cdn.pixabay.com/photo/2014/06/03/19/38/road-sign-361514_1280.png");

  VideoResponse(this.name, this.confidence, this.timestamp);

  VideoResponse.overloaded(
      this.name, this.confidence, this.timestamp, this.boundingBox);
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