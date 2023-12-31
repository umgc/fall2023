import 'dart:io';

import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/utils/logger.dart';

class Audio extends Media {
  final String audioFileName;
  final String? transcriptFileName;
  final String? summary;

  Audio({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    required DateTime timestamp,
    String? physicalAddress,
    required int storageSize,
    required bool isFavorited,
    required this.audioFileName,
    this.transcriptFileName,
    this.summary,
  }) : super(
          id: id,
          mediaType: MediaType.audio,
          title: title ?? audioFileName,
          description: description,
          tags: tags,
          timestamp: timestamp,
          physicalAddress: physicalAddress,
          storageSize: storageSize,
          isFavorited: isFavorited,
        );

  @override
  Audio copy({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    DateTime? timestamp,
    String? physicalAddress,
    int? storageSize,
    bool? isFavorited,
    String? audioFileName,
    String? transcriptFileName,
    String? summary,
  }) =>
      Audio(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        timestamp: timestamp ?? this.timestamp,
        physicalAddress: physicalAddress ?? this.physicalAddress,
        storageSize: storageSize ?? this.storageSize,
        isFavorited: isFavorited ?? this.isFavorited,
        audioFileName: audioFileName ?? this.audioFileName,
        transcriptFileName: transcriptFileName ?? this.transcriptFileName,
        summary: summary ?? this.summary,
      );

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      AudioFields.audioFileName: audioFileName,
      AudioFields.transcriptFileName: transcriptFileName,
      AudioFields.summary: summary,
    };
  }

  static Audio fromJson(Map<String, Object?> json) {
    try {
      return Audio(
        id: json[MediaFields.id] as int?,
        title: json[MediaFields.title] as String?,
        description: json[MediaFields.description] as String?,
        tags: (json[MediaFields.tags] as String?)?.split(','),
        timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json[MediaFields.timestamp] as int),
          isUtc: true,
        ),
        physicalAddress: json[MediaFields.physicalAddress] as String?,
        storageSize: json[MediaFields.storageSize] as int,
        isFavorited: json[MediaFields.isFavorited] == 1,
        audioFileName: json[AudioFields.audioFileName] as String,
        transcriptFileName: json[AudioFields.transcriptFileName] as String?,
        summary: json[AudioFields.summary] as String?,
      );
    } catch (e) {
      throw FormatException('Error parsing JSON: $e');
    }
  }

  Future<File?> loadTranscriptFile() async {
    try {
      if (transcriptFileName == null) {
        appLogger.severe('transcriptFileName is null');
        return null;
      }
      return FileManager.loadFile(
        DirectoryManager.instance.transcriptsDirectory.path,
        transcriptFileName!,
      );
    } catch (e) {
      appLogger.severe('Error loading transcript file: $e');
      return null;
    }
  }
}
