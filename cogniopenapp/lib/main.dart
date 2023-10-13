import 'package:cogniopenapp/src/video_processor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:cogniopenapp/src/s3_connection.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    //initialize backend services
    S3Bucket s3 = S3Bucket();
    VideoProcessor vp = VideoProcessor();
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
