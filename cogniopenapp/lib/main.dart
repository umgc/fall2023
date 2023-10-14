import 'package:cogniopenapp/src/video_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'src/galleryData.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  initializeData();
  runApp(MyApp());
  final rootDirectory =
      await getApplicationDocumentsDirectory(); // Use the current working directory
  String path = rootDirectory.path;
  createDirectoryIfNotExists('${rootDirectory.path}/photos');
  createDirectoryIfNotExists('${rootDirectory.path}/videos');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
//    This is stubbed code, it will be un-commented when the biometric auth is enabled
//      initialRoute:
//          '/biometric_auth', // Set the initial route to biometric authentication
      home: HomeScreen(),
      // routes: {
      //   //'/biometric_auth': (context) => BiometricAuthScreen(),
      //   '/home': (context) => HomeScreen(),
      //   // Add other routes as needed
      // },
    );
  }
}

void initializeData() {
  // Create the singleton object to grab all local files
  GalleryData data = GalleryData();
  //initialize backend services
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
  //GalleryData.addTestPhoto();
}

void createDirectoryIfNotExists(String directoryPath) {
  Directory directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('Directory created: $directoryPath');
  } /* else {
    print('Directory already exists: $directoryPath');
  } */
}
