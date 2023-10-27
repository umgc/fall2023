import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:flutter/widgets.dart';

class VideoResponse {
  final int? id;
  final String title;
  final String referenceVideoFilePath;
  final int timestamp;
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
    required this.referenceVideoFilePath,
  });

  VideoResponse copy({
    int? id,
    String? title,
    int? timestamp,
    double? confidence,
    double? left,
    double? top,
    double? width,
    double? height,
    String? referenceVideoFilePath,
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
        referenceVideoFilePath:
            referenceVideoFilePath ?? this.referenceVideoFilePath,
      );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'title': title,
      'timestamp': timestamp,
      'confidence': confidence,
      'left': left,
      'top': top,
      'width': width,
      'height': height,
      'referenceVideoFilePath': referenceVideoFilePath,
    };
  }

  static VideoResponse fromJson(Map<String, Object?> json) {
    try {
      return VideoResponse(
        id: json['id'] as int?,
        title: json['title'] as String,
        timestamp: json['timestamp'] as int,
        confidence: json['confidence'] as double,
        left: json['left'] as double,
        top: json['top'] as double,
        width: json['width'] as double,
        height: json['height'] as double,
        referenceVideoFilePath: json['referenceVideoFilePath'] as String,
      );
    } catch (e) {
      throw FormatException('Error parsing JSON for VideoResponse: $e');
    }
  }
}
