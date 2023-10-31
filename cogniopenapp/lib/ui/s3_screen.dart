import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import 'package:cogniopenapp/ui/customResponseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TestScreen extends StatefulWidget {
  final VideoResponse response;
  const TestScreen(this.response, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S3 Buckets'),
      ),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  TestScreenState createState() => TestScreenState(response);
}

class TestScreenState extends State<TestScreen> {
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
  VideoResponse response;

  String userDefinedModelName = '';

  TestScreenState(this.response);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remember an object'),
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
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Padding(
          // New subheading section starts here
          padding: EdgeInsets.fromLTRB(
              16.0, 4.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            "What do you want to call this object?", // This is the subheading text
            style: TextStyle(
              fontSize: 16.0, // Adjust font size as needed
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    onChanged: (text) {
                      setState(() {
                        userDefinedModelName = text;
                      });
                    },
                    decoration: const InputDecoration(
                        labelText: 'Enter search object.'),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            if (userDefinedModelName.isNotEmpty) {
              //TODO:save the passed through response Image data, boundingbox info, and the custom label name as a Significant Object.

              //TODO:load (related) Significant Object data

              //TODO:generate a manifest
              //TODO:upload new image to S3

              //TODO:add the newModel
              //vp.addNewModel("green-glasses", "eyeglasses-manifest.json");

              //TODO:create some polling method that checks if trained, then starts if trained; pass it the new model name.
              //TODO:inside that polling method, vp.startCustomDetection("green-glasses");
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid model name'),
                ),
              );
            }
          },
          child: const Text('Submit'),
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
              //creates a bucket; not needed since we are doing this on app load
              //s3.createBucket();
              vp.pollVersionDescription();
            },
            label: 'Check service',
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
              vp.addNewModel("green-glasses", "eyeglasses-manifest.json");
            },
            label: 'Add model',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63)),
        // FAB 3
        SpeedDialChild(
            child: const Icon(Icons.interests),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              vp.startCustomDetection("green-glasses");
              //vp.startCustomDetection("my-glasses");
            },
            label: 'Start model',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63)),
        // FAB 4
        SpeedDialChild(
            child: const Icon(Icons.interests),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () async {
              DetectCustomLabelsResponse? response =
                  await vp.findMatchingModel("green-glasses");
              //await vp.findMatchingModel("my-glasses");

              // ignore: use_build_context_synchronously
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CustomResponseScreen(response!)));
            },
            label: 'Detect \'My green glasses\'',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63)),
        // FAB 5
        SpeedDialChild(
            child: const Icon(Icons.interests),
            backgroundColor: const Color(0XFFE91E63),
            onTap: () {
              vp.stopCustomDetection("green-glasses");
              //vp.stopCustomDetection("my-glasses");
            },
            label: 'Stop model',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0XFFE91E63)),
      ],
    );
  }
}
