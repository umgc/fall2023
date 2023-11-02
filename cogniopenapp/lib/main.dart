import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import 'package:cogniopenapp/src/camera_manager.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:cogniopenapp/ui/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  await DirectoryManager.instance.initializeDirectories();
  await DataService.instance.initializeData();
  initializeData();
  runApp(MyApp());
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
      initialRoute: '/loginScreen', // the initial screen when the app starts
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
  // Request location permissions
  if (await Permission.location.request().isGranted) {
    Geolocator.getPositionStream().listen((Position position) {
      print("New position: ${position.latitude}, ${position.longitude}");
      // You can handle/store this position as per your needs
    });
  }

  //initialize backend services
  S3Bucket s3 = S3Bucket();
  CameraManager cm = CameraManager();
  await cm.initializeCamera();
}
