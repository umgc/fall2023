import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
  final rootDirectory =
      await getApplicationDocumentsDirectory(); // Use the current working directory
  String path = rootDirectory.path;
  createDirectoryIfNotExists('${rootDirectory.path}/photos');
  createDirectoryIfNotExists('${rootDirectory.path}/videos');
}

class MyApp extends StatelessWidget {
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

void createDirectoryIfNotExists(String directoryPath) {
  Directory directory = Directory(directoryPath);

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
    print('Directory created: $directoryPath');
  } else {
    print('Directory already exists: $directoryPath');
  }
}
