import 'package:dart_openai/dart_openai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'ui/homescreen.dart';

void main() async {
  await loadAPIKey();
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
      home: HomeScreen(),
    );
  }
}
