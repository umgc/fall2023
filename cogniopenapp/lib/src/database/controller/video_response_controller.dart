import 'dart:io';

import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/database/repository/video_response_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

const String videoResponseType = 'video_response';

class VideoResponseController {
  VideoResponseController._();

  static Future<VideoResponse?> addVideoResponse({
    required String title,
    required File imageFile,
    required double confidence,
    required double left,
    required double top,
    required double width,
    required double height,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String imageFileExtension =
          FileManager().getFileExtensionFromFile(imageFile);
      String imageFileName = FileManager().generateFileName(
        videoResponseType,
        timestamp,
        imageFileExtension,
      );
      VideoResponse newResponse = VideoResponse(
        title: title,
        imageFileName: imageFileName,
        timestamp: timestamp,
        confidence: confidence,
        left: left,
        top: top,
        width: width,
        height: height,
      );
      VideoResponse createdResponse =
          await VideoResponseRepository.instance.create(newResponse);
      await FileManager.addFileToFilesystem(
        imageFile,
        DirectoryManager.instance.videoStillsDirectory.path,
        imageFileName,
      );
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
          '${DirectoryManager.instance.videoStillsDirectory.path}/${existingResponse.imageFileName}';
      await FileManager.removeFileFromFilesystem(imageFilePath);
      return existingResponse;
    } catch (e) {
      print('VideoResponse Controller -- Error removing response: $e');
      return null;
    }
  }
}
