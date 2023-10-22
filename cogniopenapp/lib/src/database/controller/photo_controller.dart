import 'dart:io';

import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class PhotoController {
  PhotoController._();

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
}
