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
    required File videoFile,
    File? thumbnailFile, // TODO: Update to auto get the thumbnail
    required String duration, // TODO: Update to auto get the duration
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String videoFileExtension =
          FileManager().getFileExtensionFromFile(videoFile);
      String videoFileName = FileManager().generateFileName(
        MediaType.video.name,
        timestamp,
        videoFileExtension,
      );
      String? thumbnailFileExtension;
      String? thumbnailFileName;
      if (thumbnailFile != null) {
        thumbnailFileExtension =
            FileManager().getFileExtensionFromFile(videoFile);
        thumbnailFileName = videoFileName + thumbnailFileExtension;
      }
      int videoFileSize = FileManager.calculateFileSizeInBytes(videoFile);
      Video newVideo = Video(
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        storageSize: videoFileSize,
        isFavorited: false,
        videoFileName: videoFileName,
        thumbnailFileName: thumbnailFileName,
        duration: duration,
      );
      Video createdVideo = await VideoRepository.instance.create(newVideo);
      await FileManager.addFileToFilesystem(
        videoFile,
        DirectoryManager.instance.videosDirectory.path,
        videoFileName,
      );
      if (videoFile != null) {
        await FileManager.addFileToFilesystem(
          thumbnailFile!,
          DirectoryManager.instance.videoThumbnailsDirectory.path,
          thumbnailFileName!,
        );
      }
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
  }) async {
    try {
      final existingVideo = await VideoRepository.instance.read(id);
      final updatedVideo = existingVideo.copy(
        title: title ?? existingVideo.title,
        description: description ?? existingVideo.description,
        tags: tags ?? existingVideo.tags,
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
          '${DirectoryManager.instance.videosDirectory.path}/${existingVideo.videoFileName}';
      await FileManager.removeFileFromFilesystem(videoFilePath);
      String? thumbnailFileName = existingVideo.thumbnailFileName;
      if (thumbnailFileName != null && thumbnailFileName.isNotEmpty) {
        final thumbnailFilePath =
            '${DirectoryManager.instance.videoThumbnailsDirectory.path}/${existingVideo.thumbnailFileName}';
        await FileManager.removeFileFromFilesystem(thumbnailFilePath);
      }
      return existingVideo;
    } catch (e) {
      print('Video Controller -- Error removing video: $e');
      return null;
    }
  }
}
