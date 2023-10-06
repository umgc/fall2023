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

  String getStorageSizeString() {
    if (storageSize < 1024) {
      return '$storageSize Bytes';
    } else if (storageSize < 1024 * 1024) {
      double sizeInKB = storageSize / 1024;
      return '${sizeInKB.toStringAsFixed(2)} KB';
    } else if (storageSize < 1024 * 1024 * 1024) {
      double sizeInMB = storageSize / (1024 * 1024);
      return '${sizeInMB.toStringAsFixed(2)} MB';
    } else {
      double sizeInGB = storageSize / (1024 * 1024 * 1024);
      return '${sizeInGB.toStringAsFixed(2)} GB';
    }
  }

  String getDateTimeString() {
    // Format the DateTime object as a readable string
    if (timeStamp != null) {
      String formattedDate =
          "${timeStamp?.year}-${timeStamp?.month.toString().padLeft(2, '0')}-${timeStamp?.day.toString().padLeft(2, '0')}";
      String formattedTime =
          "${timeStamp?.hour.toString().padLeft(2, '0')}:${timeStamp?.minute.toString().padLeft(2, '0')}:${timeStamp?.second.toString().padLeft(2, '0')}";
      return "$formattedDate $formattedTime";
    }
    return "Date unknown";
  }

  String formatDateTime(DateTime? timeStamp) {
    if (timeStamp == null) {
      return 'N/A'; // Or any other suitable message for null DateTime
    }

    final List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];

    final int day = timeStamp.day;
    final String month = months[timeStamp.month - 1];
    final int year = timeStamp.year;

    String daySuffix = 'th';
    if (day >= 11 && day <= 13) {
      daySuffix = 'th';
    } else {
      switch (day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    return '$month ${day.toString()}$daySuffix, $year';
  }
}

class Video extends Media {
  String duration;
  late bool autoDelete; // This is a comment
  late List<IdentifiedItem> identifiedItems;
  late Image thumbnail;

  // Constructor using initializing formals: https://dart.dev/tools/linter-rules/prefer_initializing_formals
  Video(this.duration, this.autoDelete, this.identifiedItems, this.thumbnail,
      Media media)
      : super.copy(media) {
    iconType = Icon(
      Icons.video_camera_back,
      color: Colors.grey,
    );
  }
}

class Photo extends Media {
  Image associatedImage;

  Photo(this.associatedImage, Media media) : super.copy(media) {
    iconType = Icon(
      Icons.photo,
      color: Colors.grey,
    );
  }
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