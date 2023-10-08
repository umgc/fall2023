import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  void _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    setState(() {
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.medium,
      );
    });

    await _controller.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller.value.isInitialized) {
      return Container(); // Replace this with a loading indicator
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Video Recording'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: CameraPreview(_controller),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement your video recording logic here
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}