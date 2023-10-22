//import 'package:aws_kinesis_api/kinesis-2013-12-02.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../src/video_stream.dart';

class checkVideoStreamScreen extends StatefulWidget {
  checkVideoStreamScreen({super.key});
  //call video processor object, and start the rekognition service
  //VideoProcessor vp = VideoProcessor(80, "");

  Widget build(BuildContext context) {
    //vp.startService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording', style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  @override
  checkVideoStreamScreenState createState() => checkVideoStreamScreenState();
}

class checkVideoStreamScreenState extends State<checkVideoStreamScreen> {
  String text = 'Check that a stream exists';
  bool jobNotDone = false;
  //call video processor object, and start the rekognition service
  VideoStreamer vs = VideoStreamer();

  @override
  Widget build(BuildContext context) {
    vs.startService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Streaming', style: TextStyle(color: Colors.black54)),
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
      floatingActionButton: _getFAB(vs),
    );
  }

  Widget _getFAB(VideoStreamer vs) {
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
              vs.listStreamsByName();
              setState(() {
                text = "Check logs for open streams.";
              });
            },
            label: 'List Streams',
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
              vs.createStream();
            },
            label: 'Create Stream',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63))
      ],
    );
  }
}
