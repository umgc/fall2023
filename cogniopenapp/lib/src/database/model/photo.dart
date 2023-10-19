import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';

const String tablePhotos = 'photos';

class PhotoFields extends MediaFields {
  static final List<String> values = [
    ...MediaFields.values,
  ];
}

class Photo extends Media {
  Photo({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    required DateTime timestamp,
    required String fileName,
    required int storageSize,
    required bool isFavorited,
  }) : super(
          id: id,
          mediaType: MediaType.photo,
          title: title,
          description: description,
          tags: tags,
          timestamp: timestamp,
          fileName: fileName,
          storageSize: storageSize,
          isFavorited: isFavorited,
        );

  @override
  Photo copy({
    int? id,
    String? title,
    String? description,
    List<String>? tags,
    DateTime? timestamp,
    String? fileName,
    int? storageSize,
    bool? isFavorited,
  }) =>
      Photo(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        tags: tags ?? this.tags,
        timestamp: timestamp ?? this.timestamp,
        fileName: fileName ?? this.fileName,
        storageSize: storageSize ?? this.storageSize,
        isFavorited: isFavorited ?? this.isFavorited,
      );

  @override
  Map<String, Object?> toJson() {
    return {
      ...super.toJson(),
    };
  }

  @override
  static Photo fromJson(Map<String, Object?> json) {
    return Photo(
      id: json[MediaFields.id] as int?,
      title: json[MediaFields.title] as String?,
      description: json[MediaFields.description] as String?,
      tags: (json[MediaFields.tags] as String?)?.split(','),
      timestamp: DateTime.fromMillisecondsSinceEpoch(
          (json[MediaFields.timestamp] as int),
          isUtc: true),
      fileName: json[MediaFields.fileName] as String,
      storageSize: json[MediaFields.storageSize] as int,
      isFavorited: json[MediaFields.isFavorited] == 1,
    );
  }
}