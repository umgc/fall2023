import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class CustomLabelResponse {
  String name;
  double confidence;
  ResponseBoundingBox? boundingBox;
  //Image exampleImage = Image.network("https://cdn.pixabay.com/photo/2014/06/03/19/38/road-sign-361514_1280.png");
  Image exampleImage =
      const Image(image: AssetImage("assets/test_images/eyeglass-green.jpg"));

  CustomLabelResponse(this.name, this.confidence);

  CustomLabelResponse.overloaded(this.name, this.confidence, this.boundingBox) {
    //setImage(timestamp);
  }

  /*Future<Image> getImage() async {
    return await FileManager.getThumbnail(
        FileManager.mostRecentVideoPath, timestamp);
  }*/

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