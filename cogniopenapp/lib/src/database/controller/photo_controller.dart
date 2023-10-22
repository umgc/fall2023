import 'dart:io';

import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class PhotoController {
  PhotoController._();

  static Future<Photo?> addPhoto({
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
      return createdPhoto;
    } catch (e) {
      print('Photo Controller -- Error adding photo: $e');
      return null;
    }
  }

  static Future<Photo?> updatePhoto({
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
      return updatedPhoto;
    } catch (e) {
      print('Photo Controller -- Error updating photo: $e');
      return null;
    }
  }

  static Future<Photo?> removePhoto(int id) async {
    try {
      final existingPhoto = await PhotoRepository.instance.read(id);
      await PhotoRepository.instance.delete(id);
      final photoFilePath =
          '${DirectoryManager.instance.photosDirectory.path}/${existingPhoto.fileName}';
      await FileManager.removeFileFromFilesystem(photoFilePath);
      return existingPhoto;
    } catch (e) {
      print('Photo Controller -- Error removing photo: $e');
      return null;
    }
  }
}
