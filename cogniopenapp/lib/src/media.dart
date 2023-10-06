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

// Images taken from: https://www.yttags.com/blog/image-url-for-testing/
List<Media> createTestMediaList() {
  return [
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam.png'),
      Media(
        title: 'Spunky Sam',
        description: 'Avatar of Spunky Sam',
        tags: ['avatar', 'spunky'],
        timeStamp: DateTime.now(),
        storageSize: 1024,
        isFavorited: false,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png'),
      Media(
        title: 'Spunky Sam (Green)',
        description: 'Green version of Spunky Sam avatar',
        tags: ['avatar', 'spunky', 'green'],
        timeStamp: DateTime.now(),
        storageSize: 2048,
        isFavorited: true,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi.png'),
      Media(
        title: 'Purple Pi',
        description: 'Avatar of Purple Pi',
        tags: ['avatar', 'purple', 'pi'],
        timeStamp: DateTime.now(),
        storageSize: 512,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'),
      Media(
        title: 'Purple Pi (Teal)',
        description: 'Teal version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'teal'],
        timeStamp: DateTime.now(),
        storageSize: 1536,
        isFavorited: true,
      ),
    ),
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'),
      Media(
        title: 'Purple Pi (Pink)',
        description: 'Pink version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'pink'],
        timeStamp: DateTime.now(),
        storageSize: 768,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
    Video(
      '2:30', // Duration
      true, // Auto-delete
      [
        IdentifiedItem(
          'Item 1',
          DateTime.now(), // Time spotted
          Image.network(
            'https://www.example.com/item1.jpg', // Item image URL
          ),
        ),
        IdentifiedItem(
          'Item 2',
          DateTime.now()
              .subtract(Duration(days: 1)), // Time spotted (1 day ago)
          Image.network(
            'https://www.example.com/item2.jpg', // Item image URL
          ),
        ),
      ],
      Image.network(
          'https://cdn.fstoppers.com/styles/article_med/s3/media/2020/05/18/exploration_is_key_to_making_unique_landscape_photos_01.jpg'),
      Media(
        title: 'Test Video',
        description: 'This is a test video',
        tags: ['video', 'test'],
        timeStamp: DateTime.now(),
        storageSize: 4096,
        isFavorited: false,
      ), // Associated media (in this case, a photo)
    ),
    Conversation(
        "A test conversation",
        Media(
          title: "Conversation",
          description: "This is a sample conversation",
          tags: ["sample", "conversation"],
          timeStamp: DateTime(2023, 10, 5),
          storageSize: 2048, // 2 KB
          isFavorited: true,
        )),
  ];
}
