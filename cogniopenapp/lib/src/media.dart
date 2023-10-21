import 'package:flutter/material.dart';

import 'conversation.dart';
import 'video.dart';
import 'photo.dart';

// Optional parameter stuff https://stackoverflow.com/questions/52449508/constructor-optional-params
// Avoid getters and setters (if both are included, just having getters or setters is fine): https://dart.dev/tools/linter-rules/unnecessary_getters_setters
class Media {
  String title;
  String description;
  List<String>? tags;
  DateTime? timeStamp;
  int storageSize;
  bool isFavorited;
  late Icon iconType;

  Media({
    this.title = "",
    this.description = "",
    this.tags,
    this.timeStamp,
    this.storageSize = 0,
    this.isFavorited = false,
  });

  Media.overloaded(this.title, this.description, this.tags, this.timeStamp,
      this.storageSize, this.isFavorited);

  Media.copy(Media other)
      : title = other.title,
        description = other.description,
        tags = other.tags != null ? List.from(other.tags!) : null,
        timeStamp = other.timeStamp,
        storageSize = other.storageSize,
        isFavorited = other.isFavorited;

  addTag(String tag) {
    tags?.add(tag);
  }

  deleteTag(String tag) {
    tags?.remove(tag);
  }
}
