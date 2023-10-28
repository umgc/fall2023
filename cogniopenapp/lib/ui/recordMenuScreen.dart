import 'package:flutter/material.dart';

import 'audioScreen.dart';
import 'searchScreen.dart';
import 'galleryScreen.dart';
import 'assistantScreen.dart';
import 'videoScreen.dart';
import 'homeScreen.dart';

class RecordMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0x00440000),
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Gallery screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AudioScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: const Color(0xFFFFFFFF)
                          .withOpacity(0.30), // Button text color
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10.0), // Square border
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/mic_on.png',
                          width: 45.0, // You can adjust the width and height
                          height: 45.0, // as per your requirement
                        ),
                        const SizedBox(
                          height:
                              8.0, // Add some spacing between the image and text
                        ),
                        const Text(
                          'Start Audio Recording', // This is the subheading text
                          style: TextStyle(
                            fontSize: 13.0, // Adjust font size as needed
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Gallery screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VideoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor: const Color(0xFFFFFFFF)
                        .withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/camera_on.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Start Video Recording', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ) /* add child content here */,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0x00ffffff),
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
            label: 'Chatbot',
          ),
        ],
        onTap: (int index) {
          // Handle navigation bar item taps
          if (index == 0) {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen()));
          } else if (index == 1) {
            // Navigate to Search screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          } else if (index == 2) {
            // Navigate to Gallery screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GalleryScreen()));
          } else if (index == 3) {
            // Navigate to Chatbot screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AssistantScreen()));
          }
        },
      ),
    );
  }
}
