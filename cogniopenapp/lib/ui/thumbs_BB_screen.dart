import 'package:flutter/material.dart';

class CameraAppScreen extends StatefulWidget {
  const CameraAppScreen({super.key});
  @override
  CameraAppState createState() => CameraAppState();
}

class CameraAppState extends State<CameraAppScreen> {
  // Holds the position information of the rectangle
  final Map<String, double> _position = {
    'x': 50,
    'y': 115,
    'w': 300,
    'h': 110,
  };

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
        //if (_isRectangleVisible)
        Positioned(
          left: _position['x'],
          top: _position['y'],
          child: Opacity(
            opacity: 0.35,
            child: Material(
              child: InkWell(
                child: Container(
                  width: _position['w'],
                  height: _position['h'],
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: Colors.black,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      color: Colors.black,
                      child: const Text(
                        'glasses -71%',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
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
