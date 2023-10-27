import 'dart:io';

import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/database/repository/video_response_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

import 'package:path/path.dart' as path;

const String videoResponseType = 'video_response';

class VideoResponseController {
  VideoResponseController._();

  static Future<VideoResponse?> addVideoResponse({
    required String title,
    required String referenceVideoFilePath,
    required double confidence,
    required double left,
    required double top,
    required double width,
    required double height,
  }) async {
    try {
      print(
          "THIS IS THE FILE BEING ADDED TO THE TIMESTAMP ${referenceVideoFilePath}");
      DateTime timestamp =
          DateTime.parse(FileManager.getFileTimestamp(referenceVideoFilePath));
      String referenceVideo =
          FileManager.getFileName(path.basename(referenceVideoFilePath));
      print("TTHIS IS TIMESTAM PARSED ${timestamp}");
      VideoResponse newResponse = VideoResponse(
        title: title,
        referenceVideoFilePath: referenceVideo,
        timestamp: timestamp,
        confidence: confidence,
        left: left,
        top: top,
        width: width,
        height: height,
      );
      VideoResponse createdResponse =
          await VideoResponseRepository.instance.create(newResponse);

      return createdResponse;
    } catch (e) {
      print('VideoResponse Controller -- Error adding response: $e');
      return null;
    }
  }

  static Future<VideoResponse?> updateVideoResponse({
    required int id,
    String? title,
    double? confidence,
    double? left,
    double? top,
    double? width,
    double? height,
  }) async {
    try {
      final existingResponse = await VideoResponseRepository.instance.read(id);
      final updatedResponse = existingResponse.copy(
        title: title ?? existingResponse.title,
        confidence: confidence ?? existingResponse.confidence,
        left: left ?? existingResponse.left,
        top: top ?? existingResponse.top,
        width: width ?? existingResponse.width,
        height: height ?? existingResponse.height,
      );
      await VideoResponseRepository.instance.update(updatedResponse);
      return updatedResponse;
    } catch (e) {
      print('VideoResponse Controller -- Error updating response: $e');
      return null;
    }
  }

  static Future<VideoResponse?> removeVideoResponse(int id) async {
    try {
      final existingResponse = await VideoResponseRepository.instance.read(id);
      await VideoResponseRepository.instance.delete(id);
      final imageFilePath =
          '${DirectoryManager.instance.videoStillsDirectory.path}/${existingResponse.referenceVideoFilePath}';
      await FileManager.removeFileFromFilesystem(imageFilePath);
      return existingResponse;
    } catch (e) {
      print('VideoResponse Controller -- Error removing response: $e');
      return null;
    }
  }
}
