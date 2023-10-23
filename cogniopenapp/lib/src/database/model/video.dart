import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';

class Video extends Media {
  final String? duration;
  final String? thumbnail;

  Video({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    required DateTime timestamp,
    required String fileName,
    required int storageSize,
    required bool isFavorited,
    this.duration,
    this.thumbnail,
  }) : super(
          id: id,
          mediaType: MediaType.video,
          title: title ?? fileName, // TODO: Decide on default file name
          description: description,
          tags: tags,
          timestamp: timestamp,
          fileName: fileName,
          storageSize: storageSize,
          isFavorited: isFavorited,
        );

  @override
  Video copy({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    DateTime? timestamp,
    String? fileName,
    int? storageSize,
    bool? isFavorited,
    String? duration,
    String? thumbnail,
  }) =>
      Video(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        timestamp: timestamp ?? this.timestamp,
        fileName: fileName ?? this.fileName,
        storageSize: storageSize ?? this.storageSize,
        isFavorited: isFavorited ?? this.isFavorited,
        duration: duration ?? this.duration,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
      VideoFields.duration: duration,
      VideoFields.thumbnail: thumbnail,
    };
  }

  @override
  static Video fromJson(Map<String, Object?> json) {
    return Video(
      id: json[MediaFields.id] as int?,
      title: json[MediaFields.title] as String?,
      description: json[MediaFields.description] as String?,
      tags: (json[MediaFields.tags] as String?)?.split(','),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
        json[MediaFields.timestamp] as int,
      ),
      fileName: json[MediaFields.fileName] as String,
      storageSize: json[MediaFields.storageSize] as int,
      isFavorited: json[MediaFields.isFavorited] == 1,
      duration: json[VideoFields.duration] as String?,
      thumbnail: json[VideoFields.thumbnail] as String?,
    );
  }
}
