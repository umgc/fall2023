import 'dart:io';

import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class MediaController {
  MediaController._();

  // Audio Operations:

  static Future<int> addAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File file,
    String? summary,
  }) async {
    DateTime timestamp = DateTime.now();
    String fileExtension = FileManager().getFileExtensionFromFile(file);
    String fileName = FileManager().generateFileName(
      MediaType.audio.name,
      timestamp,
      fileExtension,
    );
    int fileSize = FileManager.calculateFileSizeInBytes(file);

    Audio newAudio = Audio(
      title: title,
      description: description,
      tags: tags,
      timestamp: timestamp,
      fileName: fileName,
      storageSize: fileSize,
      isFavorited: false,
      summary: summary,
    );

    Audio createdAudio = await AudioRepository.instance.create(newAudio);

    await FileManager.addFileToFilesystem(
      file,
      DirectoryManager.instance.audiosDirectory.path,
      fileName,
    );

    return createdAudio.id!;
  }

  static Future<void> updateAudio({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
    String? summary,
  }) async {
    try {
      final existingAudio = await AudioRepository.instance.read(id);

      final updatedAudio = existingAudio.copy(
        title: title ?? existingAudio.title,
        description: description ?? existingAudio.description,
        tags: tags ?? existingAudio.tags,
        summary: summary ?? existingAudio.summary,
      );

      await AudioRepository.instance.update(updatedAudio);
    } catch (e) {
      print('Error updating audio: $e');
    }
  }

  static Future<void> removeAudio(int id) async {
    try {
      final existingAudio = await AudioRepository.instance.read(id);

      await AudioRepository.instance.delete(id);

      final audioFilePath =
          '${DirectoryManager.instance.audiosDirectory.path}/${existingAudio.fileName}';

      await FileManager.removeFileFromFilesystem(audioFilePath);
    } catch (e) {
      print('Error removing audio: $e');
    }
  }

  // Photo Operations:

  static Future<int> addPhoto({
    String? title,
    String? description,
    List<String>? tags,
    required File file,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String fileExtension = FileManager().getFileExtensionFromFile(file);
      String fileName = FileManager().generateFileName(
        MediaType.photo.name,
        timestamp,
        fileExtension,
      );
      int fileSize = FileManager.calculateFileSizeInBytes(file);

      Photo newPhoto = Photo(
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        fileName: fileName,
        storageSize: fileSize,
        isFavorited: false,
      );

      Photo createdPhoto = await PhotoRepository.instance.create(newPhoto);

      await FileManager.addFileToFilesystem(
        file,
        DirectoryManager.instance.photosDirectory.path,
        fileName,
      );

      return createdPhoto.id!;
    } catch (e) {
      print('Error adding photo: $e');
      return -1;
    }
  }

  static Future<void> updatePhoto({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
  }) async {
    try {
      final existingPhoto = await PhotoRepository.instance.read(id);

      final updatedPhoto = existingPhoto.copy(
        title: title ?? existingPhoto.title,
        description: description ?? existingPhoto.description,
        tags: tags ?? existingPhoto.tags,
      );

      await PhotoRepository.instance.update(updatedPhoto);
    } catch (e) {
      print('Error updating photo: $e');
    }
  }

  static Future<void> removePhoto(int id) async {
    try {
      final existingPhoto = await PhotoRepository.instance.read(id);

      await PhotoRepository.instance.delete(id);

      final photoFilePath =
          '${DirectoryManager.instance.photosDirectory.path}/${existingPhoto.fileName}';

      await FileManager.removeFileFromFilesystem(photoFilePath);
    } catch (e) {
      print('Error removing photo: $e');
    }
  }

  // Video Operations:

  static Future<int> addVideo({
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

      return createdVideo.id!;
    } catch (e) {
      print('Error adding video: $e');
      return -1;
    }
  }

  static Future<void> updateVideo({
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
    } catch (e) {
      print('Error updating video: $e');
    }
  }

  static Future<void> removeVideo(int id) async {
    try {
      final existingVideo = await VideoRepository.instance.read(id);

      await VideoRepository.instance.delete(id);

      final videoFilePath =
          '${DirectoryManager.instance.videosDirectory.path}/${existingVideo.fileName}';

      await FileManager.removeFileFromFilesystem(videoFilePath);
    } catch (e) {
      print('Error removing video: $e');
    }
  }
}
