import 'dart:io';

import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class AudioController {
  AudioController._();

  static Future<Audio?> addSeedAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File audioFile,
    String? summary,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String audioFileExtension =
          FileManager().getFileExtensionFromFile(audioFile);
      String audioFileName = FileManager().generateFileName(
        MediaType.audio.name,
        timestamp,
        audioFileExtension,
      );
      int audioFileSize = FileManager.calculateFileSizeInBytes(audioFile);
      Audio newAudio = Audio(
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        audioFileName: audioFileName,
        storageSize: audioFileSize,
        isFavorited: false,
        summary: summary,
      );
      Audio createdAudio = await AudioRepository.instance.create(newAudio);
      await FileManager.addFileToFilesystem(
        audioFile,
        DirectoryManager.instance.audiosDirectory.path,
        audioFileName,
      );
      return createdAudio;
    } catch (e) {
      print('Audio Controller -- Error adding audio: $e');
      return null;
    }
  }

  static Future<Audio?> addAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File audioFile,
    String? summary,
  }) async {
    try {
      DateTime timestamp = DateTime.now();
      String audioFileExtension =
          FileManager().getFileExtensionFromFile(audioFile);
      String audioFileName = FileManager().generateFileName(
        MediaType.audio.name,
        timestamp,
        audioFileExtension,
      );
      int audioFileSize = FileManager.calculateFileSizeInBytes(audioFile);
      Audio newAudio = Audio(
        title: title,
        description: description,
        tags: tags,
        timestamp: timestamp,
        audioFileName: audioFileName,
        storageSize: audioFileSize,
        isFavorited: false,
        summary: summary,
      );
      Audio createdAudio = await AudioRepository.instance.create(newAudio);
      await FileManager.addFileToFilesystem(
        audioFile,
        DirectoryManager.instance.audiosDirectory.path,
        audioFileName,
      );
      return createdAudio;
    } catch (e) {
      print('Audio Controller -- Error adding audio: $e');
      return null;
    }
  }

  static Future<Audio?> updateAudio({
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
      return updatedAudio;
    } catch (e) {
      print('Audio Controller -- Error updating audio: $e');
      return null;
    }
  }

  static Future<Audio?> removeAudio(int id) async {
    try {
      final existingAudio = await AudioRepository.instance.read(id);
      await AudioRepository.instance.delete(id);
      final audioFilePath =
          '${DirectoryManager.instance.audiosDirectory.path}/${existingAudio.audioFileName}';
      await FileManager.removeFileFromFilesystem(audioFilePath);
      return existingAudio;
    } catch (e) {
      print('Audio Controller -- Error removing audio: $e');
      return null;
    }
  }
}
