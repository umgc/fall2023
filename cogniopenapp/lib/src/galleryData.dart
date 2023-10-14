import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';

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
  static String mostRecentVideoPath = "";
  static String mostRecentVideoName = "";

  GalleryData._internal() {
    print("Internal gallery data created");
    getAllPhotos();
    getAllVideos();
    _setMostRecentVideo();
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

  static void addTestPhoto() async {
    Image image = await VideoFrameExporter.getThumbnail(
        "/data/user/0/comcogniopen.cogniopenapp/app_flutter/videos/2023-10-13_17:27:03.158963.mp4",
        1000);

    print("GRABBING CUSTOM IMAGE HOPEFULLY");
    Photo photo = Photo(
      image,
      Media(
        title: 'PLEASE THUMBNAIL',
        description: '<placeholder title>',
        tags: ['<placeholder tag>', 'purple', 'pink'],
        timeStamp: DateTime.now(),
        storageSize: 12345,
        isFavorited: false,
      ),
    );
    allMedia.add(photo);
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

  static void _setMostRecentVideo() async {
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory videos = Directory('${rootDirectory.path}/videos');
    //printDirectoriesAndContents(photos);

    if (videos.existsSync()) {
      List<FileSystemEntity> files = videos.listSync();
      print("Most recently recorded video:");
      print(files.last.path);
      mostRecentVideoName = getFileNameForAWS(files.last.path);
      mostRecentVideoPath = files.last.path;
    }
  }

  void getAllVideos() async {
    List<Media> allPhotos = [];
    final rootDirectory = await getApplicationDocumentsDirectory();
    Directory videos = Directory('${rootDirectory.path}/videos');
    videoDirectory = videos;

    if (videos.existsSync()) {
      List<FileSystemEntity> files = videos.listSync();

      for (var file in files) {
        if (file is File) {
          print("VIDEO PATH PLEASE");
          print(file.path);
          /* Photo photo = Photo(
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
          allMedia.add(photo); */
        }
      }
    }
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

  static String getFileTimestamp(String filePath) {
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

  static getFileNameForAWS(String filePath) {
    // Get the file name from the full file path
    String fileName = path.basename(filePath);

    String partOne = fileName.replaceAll(":", "_");

    return partOne.replaceFirst(".", "_");
  }
}

class VideoFrameExporter {
  static Future<Image> getThumbnail(String vidPath, int timesStamp) async {
    try {
      String? thumbnailPath = await VideoThumbnail.thumbnailFile(
        video: vidPath,
        imageFormat:
            ImageFormat.PNG, // You can use other formats like JPEG, etc.
        timeMs: timesStamp,
      );

      thumbnailPath = thumbnailPath;

      if (thumbnailPath != null) {
        // You can now load the image from the thumbnailPath and display it in your Flutter app.
        // For example, using the Image widget:
        print("WE GOT THE FILE PATH THUMBNAIL. IT IS ${thumbnailPath}");
        return Image.file(File(thumbnailPath));
      }
    } catch (e) {
      print("Error generating thumbnail: $e");
    }
    return Image.network(
        "https://media.istockphoto.com/id/1349592578/de/vektor/leeres-warnschild-und-vorfahrtsschild-an-einem-mast-vektorillustration.webp?s=2048x2048&w=is&k=20&c=zmhLi9Ot96KXUe1OLd3dGNYJk0KMZZBQl39iQf6lcMk=");
  }
}