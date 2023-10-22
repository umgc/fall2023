import 'dart:io';

import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class VideoController {
  VideoController._();

  static Future<Video?> addVideo({
    String? title,
    String? description,
    List<String>? tags,
    required File file,
    String duration = "",
    String? thumbnail,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String fileExtension = FileManager().getFileExtensionFromFile(file);
      String fileName = FileManager().generateFileName(
        MediaType.video.name,
        timestamp,
        fileExtension,
      );
      int fileSize = FileManager.calculateFileSizeInBytes(file);
      Video newVideo = Video(
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        fileName: fileName,
        storageSize: fileSize,
        isFavorited: false,
        duration: duration,
        thumbnail: thumbnail,
      );
      Video createdVideo = await VideoRepository.instance.create(newVideo);
      await FileManager.addFileToFilesystem(
        file,
        DirectoryManager.instance.videosDirectory.path,
        fileName,
      );
      return createdVideo;
    } catch (e) {
      print('Video Controller -- Error adding video: $e');
      return null;
    }
  }

  static Future<Video?> updateVideo({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
    String? duration,
    String? thumbnail,
  }) async {
    try {
      final existingVideo = await VideoRepository.instance.read(id);
      final updatedVideo = existingVideo.copy(
        title: title ?? existingVideo.title,
        description: description ?? existingVideo.description,
        tags: tags ?? existingVideo.tags,
        duration: duration ?? existingVideo.duration,
        thumbnail: thumbnail ?? existingVideo.thumbnail,
      );
      await VideoRepository.instance.update(updatedVideo);
      return updatedVideo;
    } catch (e) {
      print('Video Controller -- Error updating video: $e');
      return null;
    }
  }

  static Future<Video?> removeVideo(int id) async {
    try {
      final existingVideo = await VideoRepository.instance.read(id);
      await VideoRepository.instance.delete(id);
      final videoFilePath =
          '${DirectoryManager.instance.videosDirectory.path}/${existingVideo.fileName}';
      await FileManager.removeFileFromFilesystem(videoFilePath);
      return existingVideo;
    } catch (e) {
      print('Video Controller -- Error removing video: $e');
      return null;
    }
  }
}
