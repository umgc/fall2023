import 'dart:io';

import 'package:cogniopenapp/src/database/model/significant_object.dart';
import 'package:cogniopenapp/src/database/repository/significant_object_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

const String significantObjectType = 'significant_object';

class SignificantObjectController {
  SignificantObjectController._();

  static Future<SignificantObject?> addSignificantObject({
    required String label,
    required File imageFile,
  }) async {
    try {
      String imageFileExtension =
          FileManager().getFileExtensionFromFile(imageFile);
      String imageFileName = FileManager().generateFileName(
        significantObjectType,
        DateTime.now(),
        imageFileExtension,
      );
      SignificantObject newObject = SignificantObject(
        label: label,
        imageFileName: imageFileName,
      );
      SignificantObject createdObject =
          await SignificantObjectRepository.instance.create(newObject);
      await FileManager.addFileToFilesystem(
        imageFile,
        DirectoryManager.instance.videoStillsDirectory.path,
        imageFileName,
      );
      return createdObject;
    } catch (e) {
      print('SignificantObject Controller -- Error adding object: $e');
      return null;
    }
  }

  static Future<SignificantObject?> updateSignificantObject({
    required int id,
    String? label,
    String? imageFileName,
  }) async {
    try {
      final existingObject =
          await SignificantObjectRepository.instance.read(id);
      final updatedObject = existingObject.copy(
        label: label ?? existingObject.label,
        imageFileName: imageFileName ?? existingObject.imageFileName,
      );
      await SignificantObjectRepository.instance.update(updatedObject);
      return updatedObject;
    } catch (e) {
      print('SignificantObject Controller -- Error updating object: $e');
      return null;
    }
  }

  static Future<SignificantObject?> removeSignificantObject(int id) async {
    try {
      final existingObject =
          await SignificantObjectRepository.instance.read(id);
      await SignificantObjectRepository.instance.delete(id);
      final imageFilePath =
          '${DirectoryManager.instance.videoStillsDirectory.path}/${existingObject.imageFileName}';
      await FileManager.removeFileFromFilesystem(imageFilePath);
      return existingObject;
    } catch (e) {
      print('SignificantObject Controller -- Error removing object: $e');
      return null;
    }
  }
}
