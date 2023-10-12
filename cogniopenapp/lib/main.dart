import 'package:flutter/material.dart';
import 'ui/homeScreen.dart';
import 'ui/loginScreen.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
