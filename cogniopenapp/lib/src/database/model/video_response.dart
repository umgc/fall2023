import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:flutter/widgets.dart';

class VideoResponse {
  final int? id;
  final String title;
  final String imageFileName;
  final DateTime timestamp;
  final double confidence;
  final double left;
  final double top;
  final double width;
  final double height;

  late Image? image;

  VideoResponse({
    this.id,
    required this.title,
    required this.timestamp,
    required this.confidence,
    required this.left,
    required this.top,
    required this.width,
    required this.height,
    required this.imageFileName,
  }) {
    _loadImage();
  }

  VideoResponse copy({
    int? id,
    String? title,
    DateTime? timestamp,
    double? confidence,
    double? left,
    double? top,
    double? width,
    double? height,
    String? imageFileName,
  }) =>
      VideoResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        timestamp: timestamp ?? this.timestamp,
        confidence: confidence ?? this.confidence,
        left: left ?? this.left,
        top: top ?? this.top,
        width: width ?? this.width,
        height: height ?? this.height,
        imageFileName: imageFileName ?? this.imageFileName,
      );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp.toUtc().millisecondsSinceEpoch,
      'confidence': confidence,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'imageFileName': imageFileName,
    };
  }

  static VideoResponse fromJson(Map<String, Object?> json) {
    try {
      return VideoResponse(
        id: json['id'] as int?,
        title: json['title'] as String,
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          json['timestamp'] as int,
          isUtc: true,
        ),
        confidence: json['confidence'] as double,
        left: json['left'] as double,
        top: json['top'] as double,
        width: json['width'] as double,
        height: json['height'] as double,
        imageFileName: json['imageFileName'] as String,
      );
    } catch (e) {
      throw FormatException('Error parsing JSON for VideoResponse: $e');
    }
  }

  Future<void> _loadImage() async {
    image = FileManager.loadImage(
      DirectoryManager.instance.videoResponsesDirectory.path,
      imageFileName,
    );
  }
}
