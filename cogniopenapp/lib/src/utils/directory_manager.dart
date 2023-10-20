import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cogniopenapp/src/utils/constants.dart';

class DirectoryManager {
  static final DirectoryManager _instance = DirectoryManager._internal();

  late Directory _photosDirectory;
  late Directory _videosDirectory;
  late Directory _audiosDirectory;
  late Directory _transcriptsDirectory;
  late Directory _videoStillsDirectory;
  late Directory _videoResponsesDirectory;

  DirectoryManager._internal();

  static DirectoryManager get instance => _instance;

  Directory get photosDirectory => _photosDirectory;
  Directory get videosDirectory => _videosDirectory;
  Directory get audiosDirectory => _audiosDirectory;
  Directory get transcriptsDirectory => _transcriptsDirectory;
  Directory get videoStillsDirectory => _videoStillsDirectory;
  Directory get videoResponsesDirectory => _videoResponsesDirectory;

  Future<void> initializeDirectories() async {
    final rootDirectory = await getApplicationDocumentsDirectory();

    _photosDirectory =
        _createDirectoryIfDoesNotExist('${rootDirectory.path}$photosPath');
    _videosDirectory =
        _createDirectoryIfDoesNotExist('${rootDirectory.path}$videosPath');
    _audiosDirectory =
        _createDirectoryIfDoesNotExist('${rootDirectory.path}$audiosPath');
    _transcriptsDirectory = _createDirectoryIfDoesNotExist(
        '${rootDirectory.path}$audioTranscriptsPath');
    _videoStillsDirectory =
        _createDirectoryIfDoesNotExist('${rootDirectory.path}$videoStillsPath');
    _videoResponsesDirectory = _createDirectoryIfDoesNotExist(
        '${rootDirectory.path}$videoResponsesPath');
  }

  Directory _createDirectoryIfDoesNotExist(String directoryPath) {
    Directory directory = Directory(directoryPath);
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    return directory;
  }
}
