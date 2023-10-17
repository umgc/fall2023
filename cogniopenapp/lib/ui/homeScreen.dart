// Imported libraries and packages
import 'package:cogniopenapp/ui/thumbs_BB_screen.dart';
import 'package:flutter/material.dart';
//import 'package:cogniopen/virtualAssistantScreen.dart';
import 'package:local_auth/local_auth.dart';
import 'assistantScreen.dart';
import 'audioScreen.dart';
import 'galleryScreen.dart';
import 'profileScreen.dart';
import 'recentScreen.dart';
import 'searchScreen.dart';
import 'videoScreen.dart';
import 'registrationScreen.dart';
import 'loginScreen.dart';
import 's3_screen.dart';

// Main HomeScreen widget which is a stateless widget.
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color for the entire screen
      backgroundColor: const Color(0XFF880E4F),

      // Setting up the app bar at the top of the screen
      appBar: AppBar(
        backgroundColor: const Color(0XFFE91E63), // Set appbar background color
        centerTitle: true, // This centers the title
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
            const Text('CogniOpen', textAlign: TextAlign.center),
          ],
        ),

        // Widgets on the right side of the AppBar
        actions: [
          // Vertical popup menu on the right side of the AppBar
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (String result) {
              switch (result) {
                case 'Profile':
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
                  break;
                case 'Help Center':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CameraAppScreen()));
                  break;
                case 'Customizable Application':
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TestScreen()));
                  break;
                case 'Logout':
                  Navigator.popUntil(context, ModalRoute.withName('/'));
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
                value: 'Customizable Application',
                child: Text('Customizable Application'),
              ),
              const PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),

          // First page icon to navigate back
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      // Main content of the screen
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 4.0),
            child: Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
            child: Text(
              'Helping you remember the important thing\n Choose a feature from here to get started!',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Grid view to display multiple options/buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              padding: const EdgeInsets.all(16.0),
              children: [
                // Using the helper function to build each button in the grid
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/chatbot.png',
                  text: 'Virtual Assistant',
                  screen: AssistantScreen(),
                  keyName: "VirtualAssistantButtonKey",
                ),
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/gallery.png',
                  text: 'Gallery',
                  screen: GalleryScreen(),
                  keyName: "GalleryButtonKey",
                ),
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/video.png',
                  text: 'Video Recording',
                  screen: const VideoScreen(),
                  keyName: "VideoRecordingButtonKey",
                ),
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/audio.png',
                  text: 'Audio Recording',
                  screen: AudioScreen(),
                  keyName: "AudioRecordingButtonKey",
                ),
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/search.png',
                  text: 'Search',
                  screen: SearchScreen(),
                  keyName: "SearchButtonKey",
                ),
                _buildElevatedButton(
                  context: context,
                  iconPath: 'assets/icons/recentrequest.png',
                  text: 'Recent Requests',
                  screen: RecentScreen(),
                  keyName: "RecentRequestsButtonKey",
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom navigation bar with multiple options for quick navigation
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0XFFE91E63),
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0XFFE91E63),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Virtual Assistant',
          ),
        ],
        onTap: (int index) {
          // Handling taps on the bottom navigation bar items
          if (index == 0) {
            // For Home, do nothing (or reload current screen if needed)
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GalleryScreen()));
          } else if (index == 3) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AssistantScreen()));
          }
        },
      ),
    );
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
        backgroundColor: const Color(0XFFC6FF00), // Button text color
        padding: const EdgeInsets.all(16.0),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
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
            height: 64,
          ),
          const SizedBox(height: 16.0),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16.0,
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
