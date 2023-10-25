import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';

class Audio extends Media {
  final String audioFileName;
  final String? summary;

  Audio({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    required DateTime timestamp,
    required int storageSize,
    required bool isFavorited,
    required this.audioFileName,
    this.summary,
  }) : super(
          id: id,
          mediaType: MediaType.audio,
          title:
              title ?? audioFileName, // TODO: Decide on default photo file name
          description: description,
          tags: tags,
          timestamp: timestamp,
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
    int? storageSize,
    bool? isFavorited,
    String? audioFileName,
    String? summary,
  }) =>
      Audio(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        timestamp: timestamp ?? this.timestamp,
        storageSize: storageSize ?? this.storageSize,
        isFavorited: isFavorited ?? this.isFavorited,
        audioFileName: audioFileName ?? this.audioFileName,
        summary: summary ?? this.summary,
      );

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      AudioFields.audioFileName: audioFileName,
      AudioFields.summary: summary,
    };
  }

  @override
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
        storageSize: json[MediaFields.storageSize] as int,
        isFavorited: json[MediaFields.isFavorited] == 1,
        audioFileName: json[AudioFields.audioFileName] as String,
        summary: json[AudioFields.summary] as String?,
      );
    } catch (e) {
      throw FormatException('Error parsing JSON: $e');
    }
  }
}
