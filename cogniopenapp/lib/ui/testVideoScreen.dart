import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../src/video_processor.dart';
import 'videoResponseScreen.dart';

class TestVideoScreen extends StatefulWidget {
  TestVideoScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording'),
      ),
    );
  }

  @override
  TestVideoScreenState createState() => TestVideoScreenState();
}

class TestVideoScreenState extends State<TestVideoScreen> {
  String text = 'Open bottom-left menu, and select "Grab Job".';

  //call video processor object, and start the rekognition service
  VideoProcessor vp = VideoProcessor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording'),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              16.0, 16.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            'Welcome!', // This is the header text
            style: TextStyle(
              fontSize: 24.0, // Adjust font size as needed
              fontWeight: FontWeight.bold,
              //color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          // New subheading section starts here
          padding: const EdgeInsets.fromLTRB(
              16.0, 4.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            text, // This is the subheading text
            style: const TextStyle(
              fontSize: 16.0, // Adjust font size as needed
              //color:
              //Colors.white70, // Slightly transparent white for subheading
            ),
            textAlign: TextAlign.center,
          ),
        ), // New subheading section ends here
      ]),
      floatingActionButton: _getFAB(vp),
    );
  }

  Widget _getFAB(VideoProcessor vp) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: const IconThemeData(size: 22),
      backgroundColor: const Color(0XFFE91E63),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        // FAB 1
        SpeedDialChild(
            child: const Icon(Icons.search),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              vp.pollForCompletedRequest();
              setState(() {
                text =
                    "Job ID: ${vp.jobId}\n\n Open bottom-left menu, and select \"Show Results\".";
              });
            },
            label: 'Grab Job',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63)),
        // FAB 2
        SpeedDialChild(
            child: const Icon(Icons.interests),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              Future<GetLabelDetectionResponse> responses =
                  vp.grabResults(vp.jobId);
              responses.then((value) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VideoResponseScreen(value)));
              });
            },
            label: 'Show Results',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63))
      ],
    );
  }
}
