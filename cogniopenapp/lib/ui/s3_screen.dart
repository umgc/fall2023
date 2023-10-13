import 'dart:io';
import 'dart:typed_data';

import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'package:path/path.dart' as p;

class TestScreen extends StatefulWidget {
  //TestScreen({super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S3 Buckets'),
      ),
    );
  }

  @override
  TestScreenState createState() => TestScreenState();
}

class TestScreenState extends State<TestScreen> {
  S3Bucket s3 = S3Bucket();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S3 Buckets'),
      ),
      body: const Column(children: [
        Padding(
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
          padding: EdgeInsets.fromLTRB(
              16.0, 4.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            "Click the buttons to do the thing.", // This is the subheading text
            style: TextStyle(
              fontSize: 16.0, // Adjust font size as needed
              //color:
              //Colors.white70, // Slightly transparent white for subheading
            ),
            textAlign: TextAlign.center,
          ),
        ), // New subheading section ends here
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
            child: const Icon(Icons.search),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              s3.createBucket();
            },
            label: 'Create bucket',
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
              //List<int> list = 'example data changed'.codeUnits;
              //Uint8List bytes = Uint8List.fromList(list);
              String title = "1MinuteSampleVideo.mp4";
              Future<ByteData> file =
                  rootBundle.load('assets/test_images/$title');
              file.then((value) {
                Uint8List bytes = value.buffer.asUint8List();
                s3.addVideo(title, bytes);
              });

              //print(Directory.current.path);
              //print(p.dirname(path));
              //File file = File("/1MinuteSampleVideo.mp4");
              //var data = file.readAsBytesSync();
              //VideoPlayerController controller = VideoPlayerController.file(
              //    "/assets/test_images/1 Minute Sample Video.mp4" as File);
              //controller.dataSourceType;
            },
            label: 'Add video',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63))
      ],
    );
  }
}
