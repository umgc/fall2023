import 'package:flutter/material.dart';

import '../src/media.dart';
import '../src/video.dart';
import '../src/photo.dart';
import '../src/conversation.dart';
import '../main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GalleryData {
  static final GalleryData _instance = GalleryData._internal();
  static Directory? photoDirectory;
  static Directory? videoDirectory;

  GalleryData._internal() {
    print("internal created");
    getAllPhotos();
    getAllVideos();
  }

  factory GalleryData() {
    return _instance;
  }

  static List<Media> allMedia = [];

  static List<Media> getAllMedia() {
    return allMedia;
  }

  static Directory? getPhotoDirectory() {
    return photoDirectory;
  }

  static Directory? getVideoDirectory() {
    return videoDirectory;
  }

  void getAllPhotos() async {
    print("----------------- GRABBING ALL PHOTOS -----------------");
    List<Media> allPhotos = [];
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory photos = Directory('${rootDirectory.path}/photos');
    photoDirectory = photos;
    printDirectoriesAndContents(photos);

    if (photos.existsSync()) {
      List<FileSystemEntity> files = photos.listSync();

      for (var file in files) {
        if (file is File) {
          print("FILE");
          print(file.path);
          Photo photo = Photo(
            Image.file(file),
            Media(
              title: 'A very ugly man',
              description: 'He is not cool',
              tags: ['avatar', 'purple', 'pink'],
              timeStamp: DateTime.now(),
              storageSize: 768,
              isFavorited: false,
            ),
          );
          allMedia.add(photo);
        }
      }
    }
    print("----------------- ALL PHOTOS GRABBED -----------------");
  }

  void getAllVideos() async {
    print("----------------- GRABBING ALL VIDEOS -----------------");
    List<Media> allPhotos = [];
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory videos = Directory('${rootDirectory.path}/videos');
    videoDirectory = videos;
    printDirectoriesAndContents(videos);

    //TO DO POPULATE WITH THE VIDEO STUFF
    print("----------------- ALL VIDEOS GRABBED -----------------");
  }
}

void printDirectoriesAndContents(Directory directory, {int depth = 0}) {
  final prefix = '  ' * depth;
  print('$prefix${directory.path}/'); // Print the current directory

  try {
    final entities = directory.listSync(); // List the directory's contents

    for (final entity in entities) {
      if (entity is File) {
        print('$prefix  - ${entity.uri.pathSegments.last}'); // Print file
      } else if (entity is Directory) {
        printDirectoriesAndContents(entity,
            depth: depth + 1); // Recursively print subdirectory
      }
    }
  } catch (e) {
    print('$prefix  Error: $e');
  }
}
