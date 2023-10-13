import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../src/media.dart';
import '../src/video.dart';
import '../src/photo.dart';
import '../src/conversation.dart';
import '../main.dart';
import 'dart:io';

class GalleryData {
  static final GalleryData _instance = GalleryData._internal();
  static Directory? photoDirectory;
  static Directory? videoDirectory;

  GalleryData._internal() {
    print("Internal gallery data created");
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
    List<Media> allPhotos = [];
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory photos = Directory('${rootDirectory.path}/photos');
    photoDirectory = photos;
    //printDirectoriesAndContents(photos);

    if (photos.existsSync()) {
      List<FileSystemEntity> files = photos.listSync();

      for (var file in files) {
        if (file is File) {
          Photo photo = Photo(
            Image.file(file),
            Media(
              title: '<placeholder title>',
              description: '<placeholder title>',
              tags: ['<placeholder tag>', 'purple', 'pink'],
              timeStamp: DateTime.parse(getFileTimestamp(file.path)),
              storageSize: file.lengthSync(),
              isFavorited: false,
            ),
          );
          allMedia.add(photo);
        }
      }
    }
  }

  void getAllVideos() async {
    List<Media> allPhotos = [];
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory videos = Directory('${rootDirectory.path}/videos');
    videoDirectory = videos;
    //printDirectoriesAndContents(videos);

    //TO DO POPULATE WITH THE VIDEO STUFF
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

  String getFileTimestamp(String filePath) {
    // Get the file name from the full file path
    String fileName = path.basename(filePath);

    // Find the last dot (.) in the file name to separate the extension
    int dotIndex = fileName.lastIndexOf('.');

    String newName = fileName.replaceFirst("_", " ");

    if (dotIndex != -1) {
      // Return the file name without the extension
      return newName.substring(0, dotIndex);
    } else {
      // If there's no dot in the file name, return the entire name
      return newName;
    }
  }
}
