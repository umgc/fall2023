import 'dart:io';
import 'dart:math';

import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;

class FileManager {
  static Future<void> addFileToFilesystem(File sourceFile,
      String targetDirectoryPath, String targetFilename) async {
    try {
      final targetPath = '$targetDirectoryPath/$targetFilename';
      await sourceFile.copy(targetPath);
    } catch (e) {
      print('Error adding file: $e');
    }
  }

  static Future<void> removeFileFromFilesystem(String filePath) async {
    try {
      final File fileToDelete = File(filePath);

      if (fileToDelete.existsSync()) {
        await fileToDelete.delete();
      } else {
        print('File not found: $filePath');
      }
    } catch (e) {
      print('Error deleting file: $e');
    }
  }

  static Future<void> updateFileInFileSystem(File sourceFile,
      String targetDirectoryPath, String targetFilename) async {
    try {
      final targetPath = '$targetDirectoryPath/$targetFilename';
      await removeFileFromFilesystem(targetPath);
      await addFileToFilesystem(
          sourceFile, targetDirectoryPath, targetFilename);
    } catch (e) {
      print('Error updating file: $e');
    }
  }

  static Future<File> loadAssetFile(
      String assetPath, String targetFileName) async {
    try {
      final ByteData data = await rootBundle.load(assetPath);
      final tmpDirectory = DirectoryManager.instance.tmpDirectory;
      final file = File('${tmpDirectory.path}/$targetFileName');
      File savedFile = await file.writeAsBytes(data.buffer.asUint8List());
      return savedFile;
    } catch (e) {
      print('Error loading asset: $e');
      throw Exception('Failed to load asset file: $assetPath');
    }
  }

  static Future<void> unloadAssetFile(String targetFileName) async {
    try {
      final tmpDirectory = DirectoryManager.instance.tmpDirectory;
      final file = File('${tmpDirectory.path}/$targetFileName');

      if (file.existsSync()) {
        await file.delete();
      }
    } catch (e) {
      print('Error unloading asset file: $e');
    }
  }

  static int calculateFileSizeInBytes(File file) {
    try {
      if (file.existsSync()) {
        return file.lengthSync();
      } else {
        return 0;
      }
    } catch (e) {
      print('Error calculating file size: $e');
      return 0;
    }
  }

  String generateFileName(
      String prefix, DateTime timestamp, String fileExtension) {
    final random = Random();
    final formattedTimestamp = timestamp.millisecondsSinceEpoch;
    final randomString = String.fromCharCodes(
      List.generate(8, (_) => random.nextInt(26) + 97),
    );

    return '$prefix-$formattedTimestamp-$randomString.$fileExtension';
  }

  String getFileExtensionFromFile(File file) {
    return path.extension(file.path).replaceAll('.', '');
  }

  String getFileNameWithoutExtension(String fileNameWithExtension) {
    int lastIndex = fileNameWithExtension.lastIndexOf('.');
    if (lastIndex != -1) {
      return fileNameWithExtension.substring(0, lastIndex);
    }
    return fileNameWithExtension;
  }

  static Image? loadImage(String filePath, String fileName) {
    try {
      final File imageFile = File('$filePath/$fileName');
      if (!imageFile.existsSync()) {
        return null;
      }
      return Image.file(imageFile);
    } catch (e) {
      print('Error loading image: $e');
      return null;
    }
  }
}
