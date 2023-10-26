import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';

/// Camera manager class to handle camera functionality.
class CameraManager {
  static CameraManager? _instance;
  late CameraController _controller;
  CameraDescription? selectedCamera;
  bool isRecordingVideo = false;
  bool isRecordingPaused = false;

  CameraController get controller => _controller;

  CameraManager._();

  /*factory CameraManager() {
    _instance ??= CameraManager._();
    return _instance!;
  }*/
  CameraManager() {
    initializeCamera();
  }

  void dispose() {
    _controller.dispose();
  }

  bool get isRecording => isRecordingVideo; // Getter for isRecording

  Future<void> initializeCamera() async {
    final cameras = await availableCameras(); // Access availableCameras from the camera package
    var selectedCamera = cameras.first; // Set a default camera
    _controller = CameraController(selectedCamera, ResolutionPreset.medium); // Use the selectedCamera
    await _controller.initialize();
    selectedCamera = selectedCamera;
  }

  Future<void> switchCamera(CameraDescription? description) async {
    if (description == null) {
      return;
    }

    await _controller.dispose();
    _controller = CameraController(description, ResolutionPreset.medium);
    await _controller.initialize();
    selectedCamera = description; // Update the selected camera
  }

  Future<XFile?> takePicture() async {
    if (!_controller.value.isInitialized) {
      return null;
    }

    final file = await _controller.takePicture();
    return file;
  }

  Future<void> startVideoRecording() async {
    if (!_controller.value.isInitialized || _controller.value.isRecordingVideo) {
      return;
    }

    await _controller.startVideoRecording();
    isRecordingVideo = true;
    isRecordingPaused = false;
  }

  Future<XFile?> stopVideoRecording() async {
    if (!_controller.value.isInitialized || !_controller.value.isRecordingVideo) {
      return null;
    }

    XFile? file;
    try {
      file = await _controller.stopVideoRecording();
    } catch (e) {
      // Handle any errors that might occur during video recording.
      print('Error stopping video recording: $e');
    }

    isRecordingVideo = false;
    isRecordingPaused = false;

    return file;
  }

  Future<void> pauseVideoRecording() async {
    if (!_controller.value.isInitialized || !_controller.value.isRecordingVideo) {
      return;
    }

    await _controller.pauseVideoRecording();
    isRecordingPaused = true;
  }

  Future<void> resumeVideoRecording() async {
    if (!_controller.value.isInitialized || !_controller.value.isRecordingVideo) {
      return;
    }

    await _controller.resumeVideoRecording();
    isRecordingPaused = false;
  }
}