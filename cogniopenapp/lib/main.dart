import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'src/galleryData.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  initializeData();
  runApp(MyApp());
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
}
