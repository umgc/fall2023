import 'package:cogniopenapp/src/video_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/loginScreen.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'src/galleryData.dart';

void main() async {
  initializeData();
  runApp(MyApp());
  initializeDirectories();
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CogniOpen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/loginScreen',  // the initial screen when the app starts
      routes: {
        '/loginScreen': (context) => LoginScreen(),
        '/homeScreen': (context) => HomeScreen(),
        // You can add other routes as needed
      },
    );
  }
}

// These are all singleton objects and should be initialized at the beginning
void initializeData() async {
  // Create the singleton object to grab all local files
  GalleryData data = GalleryData();
  //initialize backend services
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
}

void initializeDirectories() async {
  final rootDirectory =
      await getApplicationDocumentsDirectory(); // Use the current working directory
  String path = rootDirectory.path;
  createDirectoryIfNotExists('${rootDirectory.path}/photos');
  createDirectoryIfNotExists('${rootDirectory.path}/videos');
  createDirectoryIfNotExists('${rootDirectory.path}/videos/stills');
  createDirectoryIfNotExists('${rootDirectory.path}/videos/responses');
  createDirectoryIfNotExists('${rootDirectory.path}/audio');
  createDirectoryIfNotExists('${rootDirectory.path}/audio/transcripts');
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
