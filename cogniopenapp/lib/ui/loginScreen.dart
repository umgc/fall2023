/*
Author: Eyerusalme (Jerry)
*/
import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'registrationScreen.dart';
import 'homeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<void> _authenticateWithAllMethods() async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access your account',
      );

      if (didAuthenticate) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authentication failed!')),
        );
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/icons/app_icon.png',
                      height: 150, width: 150),
                  SizedBox(height: 20),
                  Text(
                    "CogniOpen",
                    style: TextStyle(
                      color: Colors.blueGrey[900],
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      color: Colors.blueGrey[700],
                      fontSize: 28.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: _authenticateWithAllMethods,
                    child: Column(
                      children: [
                        Icon(Icons.vpn_key,
                            color: Colors.blueGrey[800], size: 80.0),
                        Text('Login',
                            style: TextStyle(color: Colors.blueGrey[800])),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "First time Here? Welcome! Join us as we focus on nurturing memory wellness for cognitive impairment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.blueGrey[600],
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegistrationScreen()),
                      );
                    },
                    child: Text('Create Account'),
                    style:
                        ElevatedButton.styleFrom(primary: Colors.blueGrey[600]),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                    child: Text('HomeScreen(Test)'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors
                            .red), // This is for testing purpose
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
