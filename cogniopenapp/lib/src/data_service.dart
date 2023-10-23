import 'dart:io';

import 'package:cogniopenapp/src/database/controller/audio_controller.dart';
import 'package:cogniopenapp/src/database/controller/photo_controller.dart';
import 'package:cogniopenapp/src/database/controller/video_controller.dart';
import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
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

  Future<Audio?> addAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File audioFile,
    String? summary,
  }) async {
    try {
      final audio = await AudioController.addAudio(
        title: title,
        description: description,
        tags: tags,
        audioFile: audioFile,
        summary: summary,
      );
      if (audio != null) {
        await refreshMedia();
      }
      return audio;
    } catch (e) {
      print('Data Service -- Error adding audio: $e');
      return null;
    }
  }

  Future<Audio?> updateAudio({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
    String? summary,
  }) async {
    try {
      final audio = await AudioController.updateAudio(
        id: id,
        title: title,
        description: description,
        tags: tags,
        summary: summary,
      );
      if (audio != null) {
        await refreshMedia();
      }
      return audio;
    } catch (e) {
      print('Data Service -- Error updating audio: $e');
      return null;
    }
  }

  Future<Audio?> removeAudio(int id) async {
    try {
      final audio = await AudioController.removeAudio(id);
      if (audio != null) {
        await refreshMedia();
      }
      return audio;
    } catch (e) {
      print('Data Service -- Error removing audio: $e');
      return null;
    }
  }

  // Photo Operations:

  Future<Photo?> addPhoto({
    String? title,
    String? description,
    List<String>? tags,
    required File photoFile,
  }) async {
    try {
      final photo = await PhotoController.addPhotoFromLocalPath(
        title: title,
        description: description,
        tags: tags,
        photoFile: photoFile,
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

  Future<Video?> addVideo({
    String? title,
    String? description,
    List<String>? tags,
    required File videoFile,
    File? thumbnailFile,
    required String duration,
  }) async {
    try {
      final video = await VideoController.addVideo(
        title: title,
        description: description,
        tags: tags,
        videoFile: videoFile,
        thumbnailFile: thumbnailFile,
        duration: duration,
      );
      if (video != null) {
        await refreshMedia();
      }
      return video;
    } catch (e) {
      print('Data Service -- Error adding video: $e');
      return null;
    }
  }

  Future<Video?> updateVideo({
    required int id,
    String? title,
    String? description,
    List<String>? tags,
  }) async {
    try {
      final video = await VideoController.updateVideo(
        id: id,
        title: title,
        description: description,
        tags: tags,
      );
      if (video != null) {
        await refreshMedia();
      }
      return video;
    } catch (e) {
      print('Data Service -- Error updating video: $e');
      return null;
    }
  }

  Future<Video?> removeVideo(int id) async {
    try {
      final video = await VideoController.removeVideo(id);
      if (video != null) {
        await refreshMedia();
      }
      return video;
    } catch (e) {
      print('Data Service -- Error removing video: $e');
      return null;
    }
  }
}
