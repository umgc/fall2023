import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/address.dart';
import '../src/data_service.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

/// Camera manager class to handle camera functionality.
class CameraManager {
  CameraManager? cameraManager;
  List<CameraDescription> _cameras = <CameraDescription>[];
  late CameraController controller;

  static final CameraManager _instance = CameraManager._internal();

  CameraManager._internal() {}

  factory CameraManager() {
    return _instance;
  }

  Future<void> initializeCamera() async {
    print("GETTING CAMERAS");
    _cameras = await availableCameras();
    print(_cameras.length);
    controller = CameraController(_cameras.first, ResolutionPreset.high);
    controller = CameraController(_cameras[1], ResolutionPreset.high);
    await controller.initialize();
    print("Camera has been initialized");
  }

  void startAutoRecording() async {
    print("RECORDING IS TRYING TO START");
    // Delay for camera initialization
    Future.delayed(Duration(milliseconds: 5000), () {
      if (controller != null) {
        startRecordingInBackground();
      }
    });
  }

  Future<void> stopRecording() async {
    try {
      controller?.stopVideoRecording().then((XFile? file) {
        if (file != null) {
          saveMediaLocally(file); // Call the saveMediaLocally function
        }
      });
    } catch (Exc) {
      print(Exc);
    }
  }

  void startRecordingInBackground() async {
    if (controller == null || !controller.value.isInitialized) {
      print('Error: Camera is not initialized.');
      return;
    }

    print("RECORDING IS STARTING");
    // Start recording in the background
    controller.startVideoRecording();

    // Record for 5 minutes (300 seconds)
    await Future.delayed(Duration(seconds: 20));

    //TODO add ability to STOP the video early (manually)

    await stopRecording();

    print('Recording finished.');

    // Close the camera controller
    //await controller.dispose();
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

    await DataService.instance.addVideo(videoFile: localFile);

    // Check if the media file has been successfully saved
    if (localFile.existsSync()) {
      print('Media saved locally: ${localFile.path}');
      FileManager.getMostRecentVideo();
    } else {
      print('Failed to save media locally.');
    }
  }
}
