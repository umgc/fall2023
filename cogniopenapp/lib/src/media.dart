import 'package:flutter/material.dart';

// Optional parameter stuff https://stackoverflow.com/questions/52449508/constructor-optional-params
// Avoid getters and setters (if both are included, just having getters or setters is fine): https://dart.dev/tools/linter-rules/unnecessary_getters_setters
class Media {
  String title;
  String description;
  List<String>? tags;
  DateTime? timeStamp;
  int storageSize;
  bool isFavorited;

  Media(
      {this.title = "",
      this.description = "",
      this.tags,
      this.timeStamp,
      this.storageSize = 0,
      this.isFavorited = false});

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

class Video extends Media {
  String duration;
  late bool autoDelete; // This is a comment
  late List<IdentifiedItem> identifiedItems;

  // Constructor using initializing formals: https://dart.dev/tools/linter-rules/prefer_initializing_formals
  Video(this.duration, this.autoDelete, this.identifiedItems);
}

class Photo extends Media {
  Image associatedImage;

  Photo(this.associatedImage, Media media) : super.copy(media);
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

class Settings {
  late bool locationEnabled = false;
}

class Notification {
  String _notificationID;
  String _name;
  // Is public as per dart's suggest guidelines to eliminate redundant setters/getters
  bool isDisplayed;

  Notification(this._notificationID, this._name, this.isDisplayed);

  // Getter for _notificationID
  String get notificationID => _notificationID;

  // Getter for _name
  String get name => _name;

  @override
  String toString() {
    return 'Notification{_notificationID: $_notificationID, _name: $_name, isDisplayed: $isDisplayed}';
  }
}

class SignificantObject {
  String identifier;
  List<Image> referencePhotos;
  List<String> alternateNames;

  SignificantObject(this.identifier, this.referencePhotos, this.alternateNames);

  deleteImage() {}

  deleteAlternateName(String nameToRemove) {
    alternateNames.remove(nameToRemove);
  }

  addAlternateName(String newName) {
    alternateNames.add(newName);
  }
}


/*
class Trip {

}
*/

/* // Calendar future functionality? https://github.com/builttoroam/device_calendar/tree/master
class Event {

}
*/