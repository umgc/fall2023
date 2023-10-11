class VideoResponse {
  String name;
  double confidence;
  int timestamp;
  ResponseBoundingBox? boundingBox;

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
