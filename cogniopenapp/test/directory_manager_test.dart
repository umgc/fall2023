import 'dart:io';
import 'dart:ui';

import 'package:cogniopenapp/main.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return 'testApplicationDocumentsPath';
  }
}

void main() {
  //if (Platform.isAndroid) PathProviderAndroid.registerWith();

  //DartPluginRegistrant.ensureInitialized();
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async {
    PathProviderPlatform.instance = FakePathProviderPlatform();
  });

  //final Directory documentDirectory = getApplicationDocumentsDirectory();
  //print(documentDirectory);
  //initialize DirectoryManager
  DirectoryManager.instance.initializeDirectories();

  test('verify photo directory was created', () {
    //expect(DirectoryManager.instance.photosDirectory, isNot(null));
  });

  Future<bool> doesDirectoryExist(String directoryPath) async {
    if (await Directory(directoryPath).exists()) {
      return Future<bool>.value(true);
    } else {
      return Future<bool>.value(false);
    }
  }

  Directory getApplicationDocumentsDirectory() {
    return Directory.current;
  }
}
