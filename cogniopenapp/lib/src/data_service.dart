import 'dart:io';

import 'package:cogniopenapp/src/database/controller/photo_controller.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';

class DataService {
  DataService._internal();

  static final DataService _instance = DataService._internal();
  static DataService get instance => _instance;

  late List<Media> mediaList;

  Future<void> initializeData() async {
    await loadMedia();
  }

  Future<void> loadMedia() async {
    final audios = await AudioRepository.instance.readAll();
    final photos = await PhotoRepository.instance.readAll();
    final videos = await VideoRepository.instance.readAll();

    mediaList = [...audios, ...photos, ...videos];
  }

  Future<void> unloadMedia() async {
    mediaList.clear();
  }

  Future<void> refreshMedia() async {
    await unloadMedia();
    await loadMedia();
  }

  // Audio Operations:

  // Photo Operations:

  Future<Photo?> addPhoto({
    String? title,
    String? description,
    List<String>? tags,
    required File file,
  }) async {
    try {
      final photo = await PhotoController.addPhoto(
        title: title,
        description: description,
        tags: tags,
        file: file,
      );
      if (photo != null) {
        await refreshMedia();
      }
      return photo;
    } catch (e) {
      print('Data Service -- Error adding photo: $e');
      return null;
    }
  }

  Future<Photo?> updatePhoto({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
  }) async {
    try {
      final photo = await PhotoController.updatePhoto(
        id: id,
        title: title,
        description: description,
        tags: tags,
      );
      if (photo != null) {
        await refreshMedia();
      }
      return photo;
    } catch (e) {
      print('Data Service -- Error updating photo: $e');
      return null;
    }
  }

  Future<Photo?> removePhoto(int id) async {
    try {
      final photo = await PhotoController.removePhoto(id);
      if (photo != null) {
        await refreshMedia();
      }
      return photo;
    } catch (e) {
      print('Data Service -- Error removing photo: $e');
      return null;
    }
  }

// Video Operations:
}
