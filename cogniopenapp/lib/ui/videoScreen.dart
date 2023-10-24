import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cogniopenapp/src/address.dart';
import '../src/data_service.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';

import 'homeScreen.dart';

/// Camera home widget.
class VideoScreen extends StatefulWidget {
  /// Default Constructor
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() {
    return _CameraHomeState();
  }
}

/// Returns a suitable camera icon for [direction].
IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  // This enum is from a different package, so a new value could be added at
  // any time. The example should keep working if that happens.
  // ignore: dead_code
  return Icons.camera;
}

void _logError(String code, String? message) {
  // ignore: avoid_print
  print('Error: $code${message == null ? '' : '\nError Message: $message'}');
}

// Fetch the available cameras before initializing the app.
Future<void> _initializeCamera() async {
  _cameras = await availableCameras();

  try {
    WidgetsFlutterBinding.ensureInitialized();
    _cameras = await availableCameras();
  } on CameraException catch (e) {
    _logError(e.code, e.description);
  }
}

class _CameraHomeState extends State<VideoScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  CameraController? controller;
  XFile? imageFile;
  XFile? videoFile;
  VideoPlayerController? videoController;
  VoidCallback? videoPlayerListener;
  bool enableAudio = true;
  bool isRecording = false;
  int recordedSeconds = 0;
  Timer? recordTimer;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  // Counting pointers (number of user fingers on screen)
  int _pointers = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addObserver(this);

    // Get a list of available cameras.
    availableCameras().then((cameras) {
      _cameras = cameras;

      // Check if any cameras are available.
      if (_cameras.isNotEmpty) {
        // Set the initial camera description to the first camera (usually rear camera).
        onNewCameraSelected(_cameras.first);
      } else {
        showInSnackBar('No camera found.');
      }
    }).catchError((e) {
      _showCameraException(e);
    });

    // Delay for camera initialization
    Future.delayed(Duration(milliseconds: 1000), () {
      if (controller != null) {
        showInSnackBar('Recording Started');
        onVideoRecordButtonPressed();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // #docregion AppLifecycle
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCameraController(cameraController.description);
    }
  }
  // #enddocregion AppLifecycle

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB3E5FC), // Set appbar background color
        elevation: 0.0,
        centerTitle: true,
        title: const Text('Camera', style: TextStyle(color: Colors.black54)),
        leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color:
                      controller != null && controller!.value.isRecordingVideo
                          ? Colors.redAccent
                          : Colors.grey,
                  width: 3.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Recorded Time: ${recordedSeconds ~/ 60}:${(recordedSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18),
            ),
          ),
          _captureControlRowWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                _cameraTogglesRowWidget(),
                _thumbnailWidget(),

                // Adding a sub menu by tapping on the thumbnail. It works, but theres widget errors.
                /*GestureDetector(
                  onTap: () async {
                    if (imageFile != null || videoFile != null) {
                      openOptionsBottomSheet(
                          context); // Open the options bottom sheet
                    }
                  },
                  child: _thumbnailWidget(),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return Container();
    } else {
      return Listener(
        onPointerDown: (_) => _pointers++,
        onPointerUp: (_) => _pointers--,
        child: CameraPreview(
          controller!,
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onScaleStart: _handleScaleStart,
              onScaleUpdate: _handleScaleUpdate,
              onTapDown: (TapDownDetails details) =>
                  onViewFinderTap(details, constraints),
            );
          }),
        ),
      );
    }
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    // When there are not exactly two fingers on screen don't scale
    if (controller == null || _pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(_minAvailableZoom, _maxAvailableZoom);

    await controller!.setZoomLevel(_currentScale);
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final VideoPlayerController? localVideoController = videoController;

    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (localVideoController == null && imageFile == null)
              Container()
            else
              SizedBox(
                width: 64.0,
                height: 64.0,
                child: (localVideoController == null)
                    ? (
                        // The captured image on the web contains a network-accessible URL
                        // pointing to a location within the browser. It may be displayed
                        // either with Image.network or Image.memory after loading the image
                        // bytes to memory.
                        kIsWeb
                            ? Image.network(imageFile!.path)
                            : Image.file(File(imageFile!.path)))
                    : Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.pink)),
                        child: Center(
                          child: AspectRatio(
                              aspectRatio:
                                  localVideoController.value.aspectRatio,
                              child: VideoPlayer(localVideoController)),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }

  // Adding a sub menu by tapping on the thumbnail. It works, but theres widget errors.
  /*void openOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text('Review'),
                onTap: () {
                  // Implement logic to open a viewer for the picture or video.
                  // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen()));

                  Navigator.pop(context); // Close the BottomSheet.
                },
              ),
              ListTile(
                leading: const Icon(Icons.save),
                title: const Text('Save'),
                onTap: () {
                  // Implement logic to save the picture or video.
                  // Example: saveMediaToStorage();
                  Navigator.pop(context); // Close the BottomSheet.
                },
              ),
              ListTile(
                leading: const Icon(Icons.refresh),
                title: const Text('Retake'),
                onTap: () {
                  // Implement logic to retake the picture or video.
                  // Example: retakeMedia();
                  Navigator.pop(context); // Close the BottomSheet.
                },
              ),
            ],
          ),
        );
      },
    );
  }*/

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    final CameraController? cameraController = controller;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.camera_alt),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo
              ? onTakePictureButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.videocam),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  !cameraController.value.isRecordingVideo
              ? onVideoRecordButtonPressed
              : null,
        ),
        IconButton(
          icon: cameraController != null &&
                  cameraController.value.isRecordingPaused
              ? const Icon(Icons.play_arrow)
              : const Icon(Icons.pause),
          color: Colors.blue,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? (cameraController.value.isRecordingPaused)
                  ? onResumeButtonPressed
                  : onPauseButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.stop),
          color: Colors.red,
          onPressed: cameraController != null &&
                  cameraController.value.isInitialized &&
                  cameraController.value.isRecordingVideo
              ? onStopButtonPressed
              : null,
        ),
        IconButton(
          icon: const Icon(Icons.pause_presentation),
          color:
              cameraController != null && cameraController.value.isPreviewPaused
                  ? Colors.red
                  : Colors.blue,
          onPressed:
              cameraController == null ? null : onPausePreviewButtonPressed,
        ),
      ],
    );
  }

  /// Display a row of toggle to select the camera (or a message if no camera is available).
  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    void onChanged(CameraDescription? description) {
      if (description == null) {
        return;
      }

      onNewCameraSelected(description);
    }

    for (final CameraDescription cameraDescription in _cameras) {
      toggles.add(
        SizedBox(
          width: 90.0,
          child: RadioListTile<CameraDescription>(
            title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
            groupValue: controller?.description ?? _cameras.first,
            value: cameraDescription,
            onChanged: onChanged,
          ),
        ),
      );
    }

    return Row(children: toggles);
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void showInSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }

    final CameraController cameraController = controller!;

    final Offset offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    cameraController.setExposurePoint(offset);
    cameraController.setFocusPoint(offset);
  }

  Future<void> onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller!.dispose();
    }

    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    // Initialize the controller
    await controller!.initialize();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initializeCameraController(
      CameraDescription cameraDescription) async {
    final CameraController cameraController = CameraController(
      cameraDescription,
      kIsWeb ? ResolutionPreset.max : ResolutionPreset.medium,
      enableAudio: enableAudio,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    controller = cameraController;

    // If the controller is updated then update the UI.
    cameraController.addListener(() {
      if (mounted) {
        setState(() {});
      }
      if (cameraController.value.hasError) {
        showInSnackBar(
            'Camera error ${cameraController.value.errorDescription}');
      }
    });

    try {
      await cameraController.initialize();
      await Future.wait(<Future<Object?>>[
        cameraController
            .getMaxZoomLevel()
            .then((double value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((double value) => _minAvailableZoom = value),
      ]);
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          showInSnackBar('You have denied camera access.');
          break;
        case 'AudioAccessDenied':
          showInSnackBar('You have denied audio access.');
          break;
        default:
          _showCameraException(e);
          break;
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  void onTakePictureButtonPressed() {
    takePicture().then((XFile? file) {
      if (mounted) {
        setState(() {
          imageFile = file;
          videoController?.dispose();
          videoController = null;
        });
        if (file != null) {
          showInSnackBar('Picture saved to ${file.path}');

          // Save the captured image locally
          isVideo = false;
          saveMediaLocally(file); // Call the saveMediaLocally function
        }
      }
    });
  }

  void onAudioModeButtonPressed() {
    enableAudio = !enableAudio;
    if (controller != null) {
      onNewCameraSelected(controller!.description);
    }
  }

  Future<void> onCaptureOrientationLockButtonPressed() async {
    try {
      if (controller != null) {
        final CameraController cameraController = controller!;
        if (cameraController.value.isCaptureOrientationLocked) {
          await cameraController.unlockCaptureOrientation();
          showInSnackBar('Capture orientation unlocked');
        } else {
          await cameraController.lockCaptureOrientation();
          showInSnackBar(
              'Capture orientation locked to ${cameraController.value.lockedCaptureOrientation.toString().split('.').last}');
        }
      }
    } on CameraException catch (e) {
      _showCameraException(e);
    }
  }

  void onVideoRecordButtonPressed() {
    if (isRecording) {
      // Stop video recording
      stopVideoRecording().then((XFile? file) {
        if (mounted) {
          setState(() {
            isRecording = false;
          });
        }
        if (file != null) {
          showInSnackBar('Video recorded to ${file.path}');
          videoFile = file;
          _startVideoPlayer();

          // Save the recorded video locally
          isVideo = true;
          saveMediaLocally(file); // Call the saveMediaLocally function
        }
        // Stop the timer when recording is finished
        resetTimer();
        //stopRecordTimer();
      });
    } else {
      // Start video recording
      startVideoRecording().then((_) {
        if (mounted) {
          setState(() {
            isRecording = true;
          });
        }
        // Start the timer when recording starts
        startTimer();
        //startRecordTimer();
      });
    }
  }
  /*void startRecordTimer() {
  recordTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
    if (mounted) {
      setState(() {
        recordedSeconds++;
      });
    }
  });
}*/

/*void stopRecordTimer() {
  recordTimer?.cancel();
}*/

  /*void onStopButtonPressed() {
    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {});
      }
      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        _startVideoPlayer();

        // Save the recorded video locally
        isVideo = true;
        saveMediaLocally(file); // Call the saveMediaLocally function
      }
    });
  }*/
  void onStopButtonPressed() {
    if (isRecording) {
      resetTimer(); // Stop the timer
    }

    stopVideoRecording().then((XFile? file) {
      if (mounted) {
        setState(() {
          isRecording = false; // Set the recording state to false
        });
      }

      if (file != null) {
        showInSnackBar('Video recorded to ${file.path}');
        videoFile = file;
        _startVideoPlayer();

        // Save the recorded video locally
        isVideo = true;
        saveMediaLocally(file); // Call the saveMediaLocally function
      }
    });
  }

  void onPauseButtonPressed() {
    if (isRecording) {
      stopTimer(); // Pause the timer
      setState(() {
        isRecording = false;
      });
      pauseVideoRecording().then((_) {
        if (mounted) {
          setState(() {});
        }
        showInSnackBar('Video recording paused');
      });
    }
  }

  void onResumeButtonPressed() {
    if (!isRecording) {
      recordTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
        if (isRecording) {
          setState(() {
            recordedSeconds++;
          });
        }
      }); // Resume the timer
      setState(() {
        isRecording = true;
      });
      resumeVideoRecording().then((_) {
        if (mounted) {
          setState(() {});
        }
        showInSnackBar('Video recording resumed');
      });
    }
  }

  Future<void> startVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isRecordingVideo) {
      // A recording is already started, do nothing.
      return;
    }

    try {
      await cameraController.startVideoRecording();
      startTimer(); // Start the timer when recording begins
      setState(() {
        isRecording = true; // Set the recording state to true
      });
    } on CameraException catch (e) {
      _showCameraException(e);
      return;
    }
  }

  void startTimer() {
    recordTimer = null;
    recordedSeconds = 0;
    recordTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (isRecording) {
        setState(() {
          recordedSeconds++;
        });
      }
    });
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      isRecording = false;
    });
  }

  void stopTimer() {
    recordTimer?.cancel();
  }

  Future<XFile?> stopVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return null;
    }

    stopTimer(); // Stop the timer when recording ends

    try {
      return cameraController.stopVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  Future<void> pauseVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.pauseVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> resumeVideoRecording() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isRecordingVideo) {
      return;
    }

    try {
      await cameraController.resumeVideoRecording();
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  Future<void> _startVideoPlayer() async {
    if (videoFile == null) {
      return;
    }

    final VideoPlayerController vController = kIsWeb
        // TODO(gabrielokura): remove the ignore once the following line can migrate to
        // use VideoPlayerController.networkUrl after the issue is resolved.
        // https://github.com/flutter/flutter/issues/121927
        // ignore: deprecated_member_use
        ? VideoPlayerController.network(videoFile!.path)
        : VideoPlayerController.file(File(videoFile!.path));

    vController.setVolume(0); // Mute the video displaying the thumbnail

    videoPlayerListener = () {
      if (videoController != null) {
        // Refreshing the state to update video player with the correct ratio.
        if (mounted) {
          setState(() {});
        }
        videoController!.removeListener(videoPlayerListener!);
      }
    };
    vController.addListener(videoPlayerListener!);
    await vController.setLooping(true);
    await vController.initialize();
    await videoController?.dispose();
    if (mounted) {
      setState(() {
        imageFile = null;
        videoController = vController;
      });
    }
    await vController.play();
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = controller;
    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      final XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      _showCameraException(e);
      return null;
    }
  }

  bool isVideo = false; // By default, assume it's a photo

  Future<void> saveMediaLocally(XFile mediaFile) async {
    // Get the local directory

    // Define a file name for the saved media, you can use a timestamp or any unique name
    final String fileExtension = isVideo
        ? 'mp4'
        : 'jpg'; // Determine the file extension based on media type
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
    final File localFile = isVideo
        ? File('${DirectoryManager.instance.videosDirectory.path}/$fileName')
        : File('${DirectoryManager.instance.photosDirectory.path}/$fileName');

    // Copy the media to the local directory
    await localFile.writeAsBytes(await mediaFile.readAsBytes());

    if (!isVideo) {
      await DataService.instance.addPhoto(photoFile: localFile);
    } else {
      await DataService.instance.addVideo(videoFile: localFile);
    }

    // Check if the media file has been successfully saved
    if (localFile.existsSync()) {
      print('Media saved locally: ${localFile.path}');
      FileManager.getMostRecentVideo();
    } else {
      print('Failed to save media locally.');
    }
  }

  void _showCameraException(CameraException e) {
    _logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  Future<void> onPausePreviewButtonPressed() async {
    final CameraController? cameraController = controller;

    if (cameraController == null || !cameraController.value.isInitialized) {
      showInSnackBar('Error: select a camera first.');
      return;
    }

    if (cameraController.value.isPreviewPaused) {
      await cameraController.resumePreview();
    } else {
      await cameraController.pausePreview();
    }

    if (mounted) {
      setState(() {});
    }
  }
}

List<CameraDescription> _cameras = <CameraDescription>[];
