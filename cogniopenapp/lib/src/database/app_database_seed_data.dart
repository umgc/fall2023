import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/repository/audio_repository.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/repository/photo_repository.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import 'package:cogniopenapp/src/database/repository/video_repository.dart';

class AppDatabaseSeedData {
  void insertAppDatabaseSeedData() async {
    await AudioRepository.instance.create(audio1);
    await AudioRepository.instance.create(audio2);
    await AudioRepository.instance.create(audio3);

    await PhotoRepository.instance.create(photo1);
    await PhotoRepository.instance.create(photo2);
    await PhotoRepository.instance.create(photo3);

    await VideoRepository.instance.create(video1);
    await VideoRepository.instance.create(video2);
    await VideoRepository.instance.create(video3);
  }

  /* App Database Seed Data */

  // Audios:

  static final audio1 = Audio(
    title: 'Audio 1',
    description: 'Audio 1 description.',
    tags: ['tag 1', 'tag 2', 'tag 5'],
    timestamp: DateTime(2023, 10, 15, 11, 14),
    fileName: 'audio1.mp4',
    storageSize: 150000,
    isFavorited: false,
    summary: 'Summary 1.',
  );

  static final audio2 = Audio(
    title: 'Audio 2',
    description: 'Audio 2 description.',
    tags: ['tag3', 'tag7'],
    timestamp: DateTime(2023, 10, 14, 9, 19),
    fileName: 'audio2.mp4',
    storageSize: 250000,
    isFavorited: true,
    summary: 'Summary 2.',
  );

  static final audio3 = Audio(
    title: 'Audio 3',
    description: 'Audio 3 description.',
    tags: [],
    timestamp: DateTime(2023, 10, 13, 21, 09),
    fileName: 'audio3.mp4',
    storageSize: 50000,
    isFavorited: false,
    summary: 'Summary 3.',
  );

  // Photos:

  static final photo1 = Photo(
    title: 'Photo 1',
    description: 'Photo 1 description.',
    tags: ['tag 1', 'tag 3', 'tag 5'],
    timestamp: DateTime(2023, 10, 15, 11, 15),
    fileName: 'photo1.png',
    storageSize: 15000,
    isFavorited: false,
  );

  static final photo2 = Photo(
    title: 'Photo 2',
    description: 'Photo 2 description.',
    tags: ['tag3', 'tag6'],
    timestamp: DateTime(2023, 10, 14, 9, 20),
    fileName: 'photo2.png',
    storageSize: 25000,
    isFavorited: true,
  );

  static final photo3 = Photo(
    title: 'Photo 3',
    description: 'Photo 3 description.',
    tags: [],
    timestamp: DateTime(2023, 10, 13, 21, 10),
    fileName: 'photo3.png',
    storageSize: 5000,
    isFavorited: false,
  );

  // Videos:

  static final video1 = Video(
      title: 'Video 1',
      description: 'Video 1 description.',
      tags: ['tag 1', 'tag 2', 'tag 3'],
      timestamp: DateTime(2023, 10, 15, 12, 30),
      fileName: 'video1.mp4',
      storageSize: 1500000,
      isFavorited: false,
      duration: "3:05",
      thumbnail: "Thumbnail_1");

  static final video2 = Video(
      title: 'Video 2',
      description: 'Video 2 description.',
      tags: ['tag2', 'tag4'],
      timestamp: DateTime(2023, 10, 14, 9, 05),
      fileName: 'video2.mp4',
      storageSize: 2500000,
      isFavorited: false,
      duration: "4:05",
      thumbnail: "Thumbnail_2");

  static final video3 = Video(
      title: 'Video 3',
      description: 'Video 3 description.',
      tags: [],
      timestamp: DateTime(2023, 10, 13, 20, 45),
      fileName: 'video3.mp4',
      storageSize: 500000,
      isFavorited: true,
      duration: "5:05",
      thumbnail: "Thumbnail_3");
}
