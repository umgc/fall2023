import 'package:cogniopenapp/src/database/model/media.dart';
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
}
