// Imported libraries and packages
import 'package:cogniopenapp/ui/s3_screen.dart';
import 'package:cogniopenapp/ui/significantObjectsScreen.dart';
import 'package:cogniopenapp/ui/response_screen.dart';
import 'package:cogniopenapp/ui/helpScreen.dart';
import 'package:cogniopenapp/ui/assistantScreen.dart';
import 'package:cogniopenapp/ui/audioScreen.dart';
import 'package:cogniopenapp/ui/galleryScreen.dart';
import 'package:cogniopenapp/ui/profileScreen.dart';
import 'package:cogniopenapp/ui/loginScreen.dart';
import 'package:cogniopenapp/ui/tourScreen.dart';
import 'package:cogniopenapp/ui/settingsScreen.dart';

import 'package:cogniopenapp/src/camera_manager.dart';
import 'package:cogniopenapp/src/utils/ui_utils.dart';
import 'package:flutter/material.dart';

// Main HomeScreen widget which is a stateless widget.
class HomeScreen extends StatelessWidget {
  bool hasBeenInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!hasBeenInitialized) {
      CameraManager cm = CameraManager();
      cm.startAutoRecording();
      hasBeenInitialized = true;
    }

    return Scaffold(
        // Set the background color for the entire screen
        extendBodyBehindAppBar: true,
        extendBody: true,
        // Setting up the app bar at the top of the screen
        appBar: AppBar(
          backgroundColor: const Color(0x440000), // Set appbar background color
          elevation: 0.0,
          centerTitle: true, // This centers the title
          automaticallyImplyLeading: false,

          title: Row(
            mainAxisSize: MainAxisSize
                .min, // This ensures the Row takes the least amount of space
            children: [
              Image.asset(
                'assets/icons/app_icon.png', // Replace this with your icon's path
                fit: BoxFit.contain,
                height: 32, // Adjust the size as needed
              ),
              const SizedBox(width: 10), // Spacing between the icon and title
              const Text('CogniOpen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
            ],
          ),

          // Widgets on the right side of the AppBar
          actions: [
            // Vertical popup menu on the right side of the AppBar
            PopupMenuButton<String>(
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black54,
              ),
              onSelected: (String result) {
                switch (result) {
                  case 'Profile':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                    break;
                  case 'Help Center':
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => TestScreen()));
                    break;
                  case 'Settings':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                    break;
                  case 'Logout':
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                    break;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'Profile',
                  child: Text('Profile'),
                ),
                const PopupMenuItem<String>(
                  value: 'Help Center',
                  child: Text('Help Center'),
                ),
                const PopupMenuItem<String>(
                  value: 'Settings',
                  child: Text('Settings'),
                ),
                const PopupMenuItem<String>(
                  value: 'Logout',
                  child: Text('Logout'),
                ),
              ],
            ),

            // First page icon to navigate back
            IconButton(
              icon: const Icon(
                Icons.first_page,
                color: Colors.black54,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        // Main content of the screen
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(16.0, 140, 16.0, 25),
                child: Text(
                  'Helping you remember the important things.\n Choose a feature to get started!',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Grid view to display multiple options/buttons
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.0,
                  mainAxisSpacing: 12.0,
                  childAspectRatio: 1.30,
                  padding: const EdgeInsets.all(26.0),
                  children: [
                    // Using the helper function to build each button in the grid
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/ask_question.png',
                      text: 'Virtual Assistant',
                      screen: AssistantScreen(),
                      keyName: "VirtualAssistantButtonKey",
                    ),
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/gallery-v2.png',
                      text: 'Gallery',
                      screen: GalleryScreen(),
                      keyName: "GalleryButtonKey",
                    ),
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/search-v2.png',
                      text: 'Object Search',
                      screen: ResponseScreen(),
                      keyName: "VideoRecordingButtonKey",
                    ),
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/mic_on.png',
                      text: 'Record Audio',
                      screen: AudioScreen(),
                      keyName: "AudioRecordingButtonKey",
                    ),
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/significant_object.png',
                      text: 'Significant Objects',
                      screen: SignificantObjectScreen(),
                      keyName: "SignificantObjectButtonKey",
                    ),
                    _buildElevatedButton(
                      context: context,
                      iconPath: 'assets/icons/tour.png',
                      text: 'Tour Guide',
                      screen: TourScreen(),
                      keyName: "TourGuideButtonKey",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Bottom navigation bar with multiple options for quick navigation
        bottomNavigationBar: UiUtils.createBottomNavigationBar(context));
  }

  // Helper function to create each button for the GridView
  Widget _buildElevatedButton({
    required BuildContext context,
    required String iconPath,
    required String text,
    required Widget screen,
    required String keyName,
  }) {
    return ElevatedButton(
      key: Key(keyName),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.black,
        backgroundColor:
            const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
        padding: const EdgeInsets.all(16.0),
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            iconPath,
            fit: BoxFit.contain,
            height: 30,
          ),
          const SizedBox(height: 22.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Color(0XFF000000),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
