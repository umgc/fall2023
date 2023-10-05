import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';

void main() async {
  await loadAPIKey();
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

Future<void> loadAPIKey() async {
  await dotenv.load(fileName: ".env");
  OpenAI.apiKey = dotenv.env[
      'OPEN_AI_API_KEY']!; //TODO: add setup step to add API key if it isn't fount in .env
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
