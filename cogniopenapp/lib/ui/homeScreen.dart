import 'dart:ui';

import 'package:flutter/material.dart';
//import 'package:cogniopen/chatbotscreen.dart';

import 'assistantScreen.dart';
import 'audioScreen.dart';
import 'customizableScreen.dart';
import 'galleryScreen.dart';
import 'helpScreen.dart';
import 'profileScreen.dart';
import 'recentScreen.dart';
import 'searchScreen.dart';
import 'videoScreen.dart';
import 'settingsScreen.dart';
import 'tourScreen.dart';
import 'conversationHistoryScreen.dart';
import 'myTimelineScreen.dart';
import 'recordMenuScreen.dart';
import 'significantObjectsScreen.dart';
import 'licenseScreen.dart';



class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
        backgroundColor: const Color(0x440000),
      elevation: 0,
          automaticallyImplyLeading: false,
        ),
          body: Container(
              decoration: const BoxDecoration(
              image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
                ),
              ),
             child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(
                            16.0, 85.0, 16.0, 0.0), // Adjust padding as needed
                        child: Align(
                              alignment: Alignment.center,
                          child: Text(
                            'CogniOpen', // This is the header text
                            style: TextStyle(
                              fontSize: 34.0, // Adjust font size as needed
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            0.0, 80.0, 0.0, 0.0), // Adjust padding as needed
                        child: Image.asset('assets/icons/cogniopen.png', scale: 5.0,),
                      ),
                    ],
                  ),
                 Expanded(
                   child: GridView.count(
                     physics: NeverScrollableScrollPhysics(),
                     crossAxisCount: 3, // Two columns
                     crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 15.0, // Spacing between rows
                     childAspectRatio: 0.80,
                       padding: const EdgeInsets.all(14.0),
                      children: [
                        ElevatedButton(
                  onPressed: () {
                    // Navigate to Chat bot/Virtual Assistant screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecordMenuScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/record.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height: 8.0, // Add some spacing between the image and text
                      ),
                      const Text('Record'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Gallery screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConversationHistoryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(

                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/message.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Conversation History', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Video Screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignificantObjectsScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/significant_object.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Significant Objects', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),

                /*     ON THE BACKLOG
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Audio Recording screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyTimelineScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/timeline.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'My Timeline', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),*/
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Search screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AssistantScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/ask_question.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Virtual Assistant', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Recent Questions/Requests screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TourScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor:
                    const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/tour.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Tour Guide', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Recent Questions/Requests screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor:
                      const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/gallery-v2.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'My Gallery', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                     Container(
                  //Empty container makes space in middle column
                ),
                      ElevatedButton(

                      onPressed: () {
                    // Navigate to Recent Questions/Requests screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                          },
                           style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                             elevation: 0.0,
                             shadowColor: Colors.transparent,
                            backgroundColor:
                            const Color(0xFFFFFFFF).withOpacity(0.30), // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0), // Square border
                            ),
                          ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/settings.png',
                        width: 45.0, // You can adjust the width and height
                        height: 45.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                        8.0, // Add some spacing between the image and text
                      ),
                      const Text(
                        'Settings', // This is the subheading text
                        style: TextStyle(
                          fontSize: 13.0, // Adjust font size as needed
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
          ),
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
              // Stay on the Home Interface Screen
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