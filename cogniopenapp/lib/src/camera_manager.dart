import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/address.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import '../src/data_service.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Camera manager class to handle camera functionality.
class CameraManager {
  CameraManager? cameraManager;
  List<CameraDescription> _cameras = <CameraDescription>[];
  late CameraController controller;

  static final CameraManager _instance = CameraManager._internal();

  VideoProcessor vp = VideoProcessor();

  bool isAutoRecording = false;
  bool uploadToRekognition = false;
  int autoRecordingInterval = 60;

  late Image recentThumbnail;
  CameraManager._internal() {}

  factory CameraManager() {
    return _instance;
  }

  Future<void> initializeCamera() async {
    print("GETTING CAMERAS");
    _cameras = await availableCameras();
    print(_cameras.length);
    controller = CameraController(
        _cameras[(_cameras.length - 1)], ResolutionPreset.high);
    //controller = CameraController(_cameras[1], ResolutionPreset.high);
    await controller.initialize();
    print("Camera has been initialized");
    parseEnviromentSettings();
  }

  void parseEnviromentSettings() async {
    await dotenv.load(fileName: ".env");
    autoRecordingInterval =
        int.parse(dotenv.get('autoRecordInterval', fallback: "60"));
    isAutoRecording =
        dotenv.get('autoRecordEnabled', fallback: "false") == "true";
    uploadToRekognition =
        dotenv.get('autoUploadToRekognitionEnabled', fallback: "false") ==
            "true";
    String cameraUsed = (_cameras.length > 1) ? "front" : "rear";

    if (isAutoRecording) {
      print(
          "|-----------------------------------------------------------------------------------------|");
      print(
          "|------------------------------------- AUTO VIDEO RECORDING IS ENABLED -------------------------------------|");
      print(
          "|-----------------------------------------------------------------------------------------|");
    } else {
      print(
          "|-----------------------------------------------------------------------------------------|");
      print(
          "|------------------------------------- AUTO VIDEO RECORDING IS DISABLED -------------------------------------|");
      print(
          "|-----------------------------------------------------------------------------------------|");
    }

    print("The camera that is being automatically used is the ${cameraUsed}");
  }

  void startAutoRecording() async {
    // Delay for camera initialization
    Future.delayed(Duration(milliseconds: 3000), () {
      if (controller != null) {
        print(
            "|-----------------------------------------------------------------------------------------|");
        print(
            "|------------------------------------- AUTO VIDEO RECORDING HAS STARTED -------------------------------------|");
        print(
            "|-----------------------------------------------------------------------------------------|");
        startRecordingInBackground();
      }
    });
  }

  Future<void> stopRecording() async {
    try {
      controller?.stopVideoRecording().then((XFile? file) {
        if (file != null) {
          saveMediaLocally(file); // Call the saveMediaLocally function
          if (uploadToRekognition) {
            vp.automaticallySendToRekognition();
          }
        }
      });
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
    if (controller == null || !controller.value.isInitialized) {
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

    // Obtain the current physical address
    var physicalAddress = "";
    await Address.whereIAm().then((String address) {
      physicalAddress = address;
    });
    print('The street address is: $physicalAddress');

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
