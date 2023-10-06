import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import '../src/video_processor.dart';

class VideoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //call video processor object, and start the rekognition service
    VideoProcessor vp = VideoProcessor(80);
    vp.startService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recording'),
      ),
      // Implement the Video Recording screen UI here
      //add button to grab results
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
              print(vp.jobId);
              vp.pollForCompletedRequest;
              print(vp.jobId);
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
              vp.grabResults(vp.jobId);
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
