import 'dart:io';

import 'package:cogniopenapp/src/database/controller/audio_controller.dart';
import 'package:cogniopenapp/src/aws_video_response.dart';
import 'package:cogniopenapp/src/database/controller/photo_controller.dart';
import 'package:cogniopenapp/src/database/controller/video_controller.dart';
import 'package:cogniopenapp/src/database/controller/video_response_controller.dart';
import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';
import 'package:cogniopenapp/src/database/repository/video_response_repository.dart';

class DataService {
  DataService._internal();

  static final DataService _instance = DataService._internal();
  static DataService get instance => _instance;

  late List<Media> mediaList;
  late List<VideoResponse> responseList;

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

  Future<void> loadResponses() async {
    responseList = await VideoResponseRepository.instance.readAll();
  }

  Future<void> unloadResponses() async {
    responseList.clear();
  }

  Future<void> refreshResponses() async {
    await unloadResponses();
    await loadResponses();
  }

  // |-----------------------------------------------------------------------------------------|
  // |------------------------------------- VIDEO RESPONSE OPERATIONS -------------------------------------|
  // |-----------------------------------------------------------------------------------------|
  Future<void> addVideoResponses(List<AWS_VideoResponse> rekogResponses) async {
    try {
      for (AWS_VideoResponse rekResponse in rekogResponses) {
        final response = await VideoResponseController.addVideoResponse(
            title: rekResponse.name,
            referenceVideoFilePath: rekResponse.referenceVideoFilePath,
            confidence: rekResponse.confidence,
            left: rekResponse.boundingBox.left,
            top: rekResponse.boundingBox.top,
            width: rekResponse.boundingBox.width,
            height: rekResponse.boundingBox.height);
        if (response != null) {
          print(
              "ADDED RESPONSE: title ${response.title} timestamp ${response.timestamp}");
        }
      }

      await refreshResponses();

      //return response;
    } catch (e) {
      print('Data Service -- Error adding video response: $e');
      //return null;
    }
  }

  // |-----------------------------------------------------------------------------------------|
  // |------------------------------------- AUDIO OPERATIONS -------------------------------------|
  // |-----------------------------------------------------------------------------------------|

  // TODO, refactor seed data to just use addAudio();
  Future<Audio?> addSeedAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File audioFile,
    String? summary,
  }) async {
    try {
      final audio = await AudioController.addSeedAudio(
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

  Future<Audio?> addAudio({
    String? title,
    String? description,
    List<String>? tags,
    required File audioFile,
    String? summary,
  }) async {
    try {
      final audio = await AudioController.addSeedAudio(
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
    bool? isFavorited,
    String? summary,
  }) async {
    try {
      final audio = await AudioController.updateAudio(
        id: id,
        title: title,
        description: description,
        isFavorited: isFavorited,
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

  // |-----------------------------------------------------------------------------------------|
  // |-------------------------------------- PHOTO OPERATIONS --------------------------------------|
  // |-----------------------------------------------------------------------------------------|

// TODO, refactor seed data to just use addPhoto();
  Future<Photo?> addSeedPhoto({
    String? title,
    String? description,
    List<String>? tags,
    required File photoFile,
  }) async {
    try {
      final photo = await PhotoController.addSeedPhoto(
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

  Future<Photo?> addPhoto({
    String? title,
    String? description,
    List<String>? tags,
    required File photoFile,
  }) async {
    try {
      final photo = await PhotoController.addPhoto(
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
    bool? isFavorited,
    List<String>? tags,
  }) async {
    try {
      final photo = await PhotoController.updatePhoto(
        id: id,
        title: title,
        description: description,
        isFavorited: isFavorited,
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

  // |-----------------------------------------------------------------------------------------|
  // |------------------------------------- VIDEO OPERATIONS -------------------------------------|
  // |-----------------------------------------------------------------------------------------|

  // TODO, refactor seed data to just use addVideo();
  Future<Video?> addSeedVideo({
    String? title,
    String? description,
    List<String>? tags,
    required File videoFile,
    File? thumbnailFile,
    required String duration,
  }) async {
    try {
      final video = await VideoController.addSeedVideo(
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

  Future<Video?> addVideo({
    String? title,
    String? description,
    List<String>? tags,
    required File videoFile,
    File? thumbnailFile,
    String? duration,
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
    bool? isFavorited,
    List<String>? tags,
  }) async {
    try {
      final video = await VideoController.updateVideo(
        id: id,
        title: title,
        description: description,
        isFavorited: isFavorited,
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

// |--------------------------------------------------------------------------|
// |---------------------------- OTHER OPERATIONS ----------------------------|
// |--------------------------------------------------------------------------|

  Future<Media?> updateMediaIsFavorited(Media media, bool isFavorited) async {
    try {
      Media? updatedMedia;
      if (media is Audio) {
        updatedMedia = await updateAudio(
          id: media.id!,
          isFavorited: isFavorited,
        );
      } else if (media is Photo) {
        updatedMedia = await updatePhoto(
          id: media.id!,
          isFavorited: isFavorited,
        );
      } else if (media is Video) {
        updatedMedia = await updateVideo(
          id: media.id!,
          isFavorited: isFavorited,
        );
      }
      return updatedMedia;
    } catch (e) {
      print('Data Service -- Error updating media isFavorited: $e');
      return null;
    }
  }

  Future<Media?> updateMediaTags(Media media, List<String>? tags) async {
    try {
      Media? updatedMedia;
      if (media is Audio) {
        updatedMedia = await updateAudio(
          id: media.id!,
          tags: tags,
        );
      } else if (media is Photo) {
        updatedMedia = await updatePhoto(
          id: media.id!,
          tags: tags,
        );
      } else if (media is Video) {
        updatedMedia = await updateVideo(
          id: media.id!,
          tags: tags,
        );
      }
      return updatedMedia;
    } catch (e) {
      print('Data Service -- Error updating media tags: $e');
      return null;
    }
  }
}
