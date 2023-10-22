import 'dart:io';

import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class AudioController {
  AudioController._();

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
}
