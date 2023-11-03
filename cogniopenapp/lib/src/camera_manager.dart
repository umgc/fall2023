import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/permission_manager.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import '../src/data_service.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:cogniopenapp/src/utils/format_utils.dart';

/// Camera manager class to handle camera functionality.
class CameraManager {
  CameraManager? cameraManager;
  List<CameraDescription> _cameras = <CameraDescription>[];
  late CameraController controller;

  static final CameraManager _instance = CameraManager._internal();

  bool isAutoRecording = false;
  bool uploadToRekognition = false;
  bool isInitialized = false;

  int autoRecordingInterval = 60;
  int cameraToUse = 1;

  late Image recentThumbnail;
  CameraManager._internal();

  factory CameraManager() {
    return _instance;
  }

  Future<void> initializeCamera() async {
    parseEnviromentSettings();

    // If permission is not granted then don't initialize
    if (!await PermissionManager.cameraPermissionGranted()) {
      isAutoRecording = false;
      return;
    }

    // Now, proceed with camera initialization
    _cameras = await availableCameras();

    // Make sure that there are available cameras if trying to use the front
    // 0 equals rear, 1 = front
    if (_cameras.length == 1) cameraToUse = 0;
    controller = CameraController(_cameras[cameraToUse], ResolutionPreset.high);

    await controller.initialize();

    if (controller.value.isInitialized) {
      isInitialized = true;
      FormatUtils.printBigMessage("CAMERA HAS BEEN INITIALIZED");
    }
  }

  void parseEnviromentSettings() async {
    await dotenv.load(fileName: ".env");
    cameraToUse = int.parse(dotenv.get('cameraToUse', fallback: "1"));
    autoRecordingInterval =
        int.parse(dotenv.get('autoRecordInterval', fallback: "60"));
    isAutoRecording =
        dotenv.get('autoRecordEnabled', fallback: "false") == "true";
    uploadToRekognition =
        dotenv.get('autoUploadToRekognitionEnabled', fallback: "false") ==
            "true";
    String cameraUsed = (_cameras.length > 1) ? "front" : "rear";

    if (isAutoRecording) {
      FormatUtils.printBigMessage("AUTO VIDEO RECORDING IS ENABLED");
    } else {
      FormatUtils.printBigMessage("AUTO VIDEO RECORDING IS DISABLED");
    }

    if (uploadToRekognition) {
      FormatUtils.printBigMessage("AUTO REKOGNITION UPLOAD IS ENABLED");
    } else {
      FormatUtils.printBigMessage("AUTO REKOGNITION UPLOAD IS DISABLED");
    }

    print("The camera that is being automatically used is the ${cameraUsed}");
  }

  void startAutoRecording() async {
    if (isAutoRecording) {
      // Delay for camera initialization
      Future.delayed(Duration(milliseconds: 1500), () {
        FormatUtils.printBigMessage("AUTO VIDEO RECORDING HAS STARTED");

        startRecordingInBackground();
      });
    }
  }

  Future<void> stopRecording() async {
    try {
      XFile? file = await controller.stopVideoRecording();

      await saveMediaLocally(file);
      if (uploadToRekognition) {
        VideoProcessor vp = VideoProcessor();
        vp.automaticallySendToRekognition();
      }
    } catch (Exc) {
      print(Exc);
    }
  }

  Future<void> manuallyStopRecording() async {
    isAutoRecording = false;
    stopRecording();
  }

  Future<void> manuallyStartRecording() async {
    isAutoRecording = true;
    startRecordingInBackground();
  }

  void startRecordingInBackground() async {
    if (!controller.value.isInitialized) {
      print('Error: Camera is not initialized.');
      print('Auto recording has been canceeled.');
      return;
    }

    // Start recording in the background

    if (!isAutoRecording) {
      return;
    }

    controller.startVideoRecording();

    // Record for 5 minutes (300 seconds)
    await Future.delayed(Duration(seconds: autoRecordingInterval));

    //TODO add ability to STOP the video early (manually)

    if (!isAutoRecording) {
      return;
    }

    await stopRecording();

    await Future.delayed(Duration(seconds: 2));
    // Start the next loop of the recording
    startRecordingInBackground();
  }

  Future<void> saveMediaLocally(XFile mediaFile) async {
    // Get the local directory

    // Define a file name for the saved media, you can use a timestamp or any unique name
    final String fileExtension = 'mp4';

    final String timestamp = DateTime.now().toString();
    final String sanitizedTimestamp = timestamp.replaceAll(' ', '_');
    final String fileName =
        '$sanitizedTimestamp.$fileExtension'; // Use the determined file extension

    // Create a new file by copying the media file to the local directory
    final File localFile =
        File('${DirectoryManager.instance.videosDirectory.path}/$fileName');

    // Copy the media to the local directory
    await localFile.writeAsBytes(await mediaFile.readAsBytes());

    Video? vid = await DataService.instance.addVideo(videoFile: localFile);
    if (vid != null) {
      recentThumbnail = Image(image: vid.thumbnail!.image);
    }

    // Check if the media file has been successfully saved
    if (localFile.existsSync()) {
      print('Media saved locally: ${localFile.path}');
      FileManager.getMostRecentVideo();
    } else {
      print('Failed to save media locally.');
    }
  }
}
