import 'package:flutter/material.dart';

class CameraAppScreen extends StatefulWidget {
  const CameraAppScreen({super.key});
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraAppScreen> {
  // Holds the position information of the rectangle
  Map<String, double> _position = {
    'x': 1,
    'y': 1,
    'w': 1,
    'h': 1,
  };

  // Whether or not the rectangle is displayed
  bool _isRectangleVisible = true;

  // Some logic to get the rectangle values
  void updateRectanglePosition() {
    setState(() {
      // assign new position
      _position = {
        'x': 1,
        'y': 1,
        'w': 1,
        'h': 1,
      };
      _isRectangleVisible = true;
    });
  }

  @override
  void initState() {
    //getCameras();
    super.initState();
  }

  @override
  void dispose() {
    //controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(image: AssetImage('assets/test_images/eyeglass-frame.jpg')),
        if (_isRectangleVisible)
          Positioned(
            left: _position['x'],
            top: _position['y'],
            child: InkWell(
              onTap: () {
                // When the user taps on the rectangle, it will disappear
                setState(() {
                  _isRectangleVisible = false;
                });
              },
              child: Container(
                width: _position['w'],
                height: _position['h'],
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.yellow,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    color: Colors.yellow,
                    child: const Text(
                      'horse -71%',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
