import 'package:flutter/material.dart';
import 'database/model/media_type.dart';
import 'media.dart';

class Video extends Media {
  String duration;
  late bool autoDelete; // This is a comment
  late List<IdentifiedItem> identifiedItems;
  late Image thumbnail;
  MediaType mediaType = MediaType.video;

  // Constructor using initializing formals: https://dart.dev/tools/linter-rules/prefer_initializing_formals
  Video(this.duration, this.autoDelete, this.identifiedItems, this.thumbnail,
      Media media)
      : super.copy(media);
}

// Removed the photo class, and changed the int time spotted to date time (can just go off of recent dates)
class IdentifiedItem {
  final String _itemName;
  final DateTime _timeSpotted;
  final Image _itemImage;

  IdentifiedItem(this._itemName, this._timeSpotted, this._itemImage);

  // Getter for itemName
  String get itemName => _itemName;

  // Getter for timeSpotted
  DateTime get timeSpotted => _timeSpotted;

  // Getter for itemImage
  Image get itemImage => _itemImage;
}
