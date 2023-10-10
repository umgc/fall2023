import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:
          '/biometric_auth', // Set the initial route to biometric authentication
      home: HomeScreen(),
      // routes: {
      //   //'/biometric_auth': (context) => BiometricAuthScreen(),
      //   '/home': (context) => HomeScreen(),
      //   // Add other routes as needed
      // },
    );
  }
}
