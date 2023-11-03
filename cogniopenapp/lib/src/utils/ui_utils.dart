import 'package:cogniopenapp/src/camera_manager.dart';
import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:cogniopenapp/ui/assistantScreen.dart';
import 'package:cogniopenapp/ui/videoScreen.dart';
import 'package:cogniopenapp/ui/settingsScreen.dart';

import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class UiUtils {
  static IconData getMediaIconData(MediaType mediaType) {
    switch (mediaType) {
      case MediaType.audio:
        return Icons.chat;
      case MediaType.photo:
        return Icons.photo;
      case MediaType.video:
        return Icons.video_camera_back;
      default:
        throw Exception('Unsupported media type: $mediaType');
    }
  }

  static BottomNavigationBar createBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
        elevation: 0.0,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0x00ffffff),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handshake_outlined),
            label: 'Virtual Assistant',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_camera_back),
            label: 'Video',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (int index) {
          // Handle navigation bar item taps
          if (index == 0) {
            // Navigate to Gallery screen
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            // Navigate to Search screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AssistantScreen()));
          } else if (index == 2) {
            attemptToShowVideoScreen(context);
          } else if (index == 3) {
            // Navigate to Gallery screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SettingsScreen()));
          }
        });
  }

  static void attemptToShowVideoScreen(BuildContext context) {
    CameraManager controller = CameraManager();

    if (controller.isInitialized) {
      // Navigate to Search screen
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => VideoScreen()));
    } else {
      // Show a pop-up dialog for camera permission request
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Camera Permission Required'),
          content:
              Text('Please enable camera permissions to access this feature.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }
}
