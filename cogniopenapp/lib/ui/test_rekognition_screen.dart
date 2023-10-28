//import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
//import '../src/galleryData.dart';
//import 'dart:io';

class RekognitionScreen extends StatefulWidget {
  const RekognitionScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S3 Buckets'),
      ),
    );
  }

  @override
  RekognitionScreenState createState() => RekognitionScreenState();
}

class RekognitionScreenState extends State<RekognitionScreen> {
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
  String userInput = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S3 Buckets'),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              16.0, 16.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            'Looking for an object?', // This is the header text
            style: TextStyle(
              fontSize: 24.0, // Adjust font size as needed
              fontWeight: FontWeight.bold,
              //color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          // New subheading section starts here
          padding: EdgeInsets.fromLTRB(
              16.0, 4.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            "CogniOpen assistant will search for a selected object in recent video recordings.", // This is the subheading text
            style: TextStyle(
              fontSize: 16.0, // Adjust font size as needed
              //color:
              //Colors.white70, // Slightly transparent white for subheading
            ),
            textAlign: TextAlign.center,
          ),
        ), // New subheading section ends here
        Center(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        userInput = text;
                      });
                    },
                    decoration:
                        InputDecoration(labelText: 'Enter search object.'),
                  ),
                  //SizedBox(height: 20),
                  //Text('User Input: $userInput',
                  //    style: TextStyle(fontSize: 20)),
                ],
              )),
        ),
        //SizedBox(height: 20),
        //Text('User Input: $userInput', style: TextStyle(fontSize: 20)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Perform an action when the button is pressed, e.g., display the user's input.
            /*ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('User input: $userInput'),
              ),
            );*/
            if (userInput.isNotEmpty) {
              displayFullObjectView(userInput);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please enter a valid search object'),
                ),
              );
            }
          },
          child: Text('Submit'),
        ),
      ]),
      floatingActionButton: _getFAB(s3),
    );
  }

  Widget _getFAB(S3Bucket s3) {
    //s3.startService();
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      backgroundColor: const Color(0XFFE91E63),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1

        SpeedDialChild(
            child: const Icon(Icons.interests),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              print(" PUT THE FINDING OB STUF FHERE");
              displayFullObjectView("Cup");
            },
            label: 'Search for cup',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63))
      ],
    );
  }

  void displayFullObjectView(String userQuery) async {
    VideoProcessor vp = VideoProcessor();
    VideoResponse? response = vp.getRequestedResponse(userQuery);
    if (response == null) {
      return;
    }
    String fullPath =
        "${DirectoryManager.instance.videosDirectory.path}/${response.referenceVideoFilePath}";
    print("${fullPath}");
    Image stillImage =
        await FileManager.getThumbnail(fullPath, response.timestamp);

    double imageWidth = 720;
    double imageHeight = 1280;

    if (stillImage.width != null && stillImage.height != null) {
      print("Not null");
      imageWidth = stillImage.width!;
      imageHeight = stillImage.height!;
    }

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Full Screen Response and Details'),
            ),
            body: Stack(
              children: [
                Image(image: stillImage.image),
                Positioned(
                  left: 0,
                  top: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(height: 16),
                      Text('Name: ${response.title}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Timestamp: ${response.timestamp}',
                          style: const TextStyle(fontSize: 18)),
                      Text('Confidence: ${response.timestamp}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ),
                Positioned(
                  left: imageWidth * response.left,
                  top: imageHeight * response.top,
                  child: Opacity(
                    opacity: 0.35,
                    child: Material(
                      child: InkWell(
                        child: Container(
                          width: imageWidth * response.width,
                          height: imageHeight * response.height,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              color: Colors.black,
                              child: Text(
                                '${response.title} ${((response.confidence * 100).truncateToDouble()) / 100}%',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
