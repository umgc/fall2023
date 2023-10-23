import 'dart:io';

import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

class AppSeedData {
  void loadAppSeedData() async {
    await loadSeedPhoto();
    await loadSeedVideo();
  }

  Future<void> loadSeedPhoto() async {
    try {
      File? photoFile = await FileManager.loadAssetFile(
          'assets/seed_data_files/cat.png', 'cat.png');
      List<String>? tagsList = ['pet', 'cat'];
      await DataService.instance.addPhoto(
        title: 'Cat',
        description: 'A photo of my pet cat, Kit Kat.',
        tags: tagsList,
        photoFile: photoFile,
      );
      FileManager.unloadAssetFile('cat.png');
    } catch (e) {
      print('Error loading seed data photo: $e');
    }
  }

  Future<void> loadSeedVideo() async {
    try {
      File? videoFile = await FileManager.loadAssetFile(
          'assets/seed_data_files/dog.mp4', 'dog.mp4');
      File? thumbnailFile = await FileManager.loadAssetFile(
          'assets/seed_data_files/dog.png', 'dog.png');
      List<String>? tagsList = ['pet', 'dog'];
      await DataService.instance.addVideo(
        title: 'Dog',
        description: 'A photo of my pet dog, Spot.',
        tags: tagsList,
        videoFile: videoFile,
        thumbnailFile: thumbnailFile,
        duration: "00:08",
      );
      FileManager.unloadAssetFile('dog.mp4');
      FileManager.unloadAssetFile('dog.png');
    } catch (e) {
      print('Error loading seed data video: $e');
    }
  }
}