import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;
import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/response_parser.dart';
import 'package:cogniopenapp/src/s3_connection.dart';
import 'package:cogniopenapp/src/significantObject.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/file_manager.dart';
import 'package:cogniopenapp/src/video_processor.dart';
import 'package:cogniopenapp/ui/customResponseScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'dart:io';

class ModelScreen extends StatefulWidget {
  final VideoResponse response;
  const ModelScreen(this.response, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn from User\'s choice'),
      ),
    );
  }

  @override
  // ignore: no_logic_in_create_state
  ModelScreenState createState() => ModelScreenState(response);
}

class ModelScreenState extends State<ModelScreen> {
  S3Bucket s3 = S3Bucket();
  VideoProcessor vp = VideoProcessor();
  VideoResponse response;

  String userDefinedModelName = '';

  ModelScreenState(this.response);

  @override
  Widget build(BuildContext context) {
    vp.startService();
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
                        labelText:
                            'Enter significant object custom label name.'),
                  ),
                ],
              )),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            if (userDefinedModelName.isNotEmpty) {
              //TODO:save the passed through response Image data, boundingbox info, and the custom label name as a Significant Object.
              Future<SignificantObject> sigObj = addResponseAsSignificantObject(
                  userDefinedModelName, response);

              sigObj.then((value) async {
                s3.addFileToS3("$userDefinedModelName.json",
                    value.generateRekognitionManifest());

                vp.addNewModel(
                    userDefinedModelName, "$userDefinedModelName.json");

                //TODO:create some polling method that checks if trained, then starts if trained; pass it the new model name.
                /*
                rek.ProjectVersionStatus? status;
                do {
                  status = await vp.pollForTrainedModel(userDefinedModelName);
                  sleep(const Duration(milliseconds: 5000));
                  print(status);
                } while (status == rek.ProjectVersionStatus.trainingInProgress);
                */

                //returns the modelArn of the projectVersion being started, but we really don't need it if we have the model name
                //(see vp.activeModels)
                vp.startCustomDetection(userDefinedModelName);
                //TODO?: add a polling method to see when the model is started?
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please enter a valid object name'),
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
              rek.DetectCustomLabelsResponse? response = await vp
                  .findMatchingModel("green-glasses", "glasses-test.jpg");
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

  Future<SignificantObject> addResponseAsSignificantObject(
      String userDefinedModelName, VideoResponse response) async {
    //following method keeps throwing this error
    Image stillImage = await ResponseParser.getThumbnail(response);
    String filepath = FileManager.getThumbnailFileName(
        response.referenceVideoFilePath, response.timestamp);
    String path =
        "${DirectoryManager.instance.videoStillsDirectory.path}/${filepath}";

    int i = 0;
    String name = response.title;
    ResponseBoundingBox boundingBox = ResponseBoundingBox(
        left: response.left,
        top: response.top,
        width: response.width,
        height: response.height);
    //TODO:upload new image to S3
    s3.addImageToS3("$userDefinedModelName-$i.jpg", path);
    s3.addImageToS3("$userDefinedModelName-$i-test.jpg", path);

    //if user already has a matching significant object, add this to that list.
    //TODO: Get list of significant objects
    //TODO: filter down to object that matches our user's model (userDefinedModelName)
    //TODO: add to user significant object
    //sigObj.updateSignificantObject(stillImage, name, boundingBox);

    //if not, make one.
    List<Image> images = [];
    images.add(stillImage);
    List<String> alternateNames = [];
    alternateNames.add(name);
    List<ResponseBoundingBox> boundingBoxes = [];
    boundingBoxes.add(boundingBox);
    SignificantObject sigObj = SignificantObject.overloaded(
        userDefinedModelName, images, alternateNames, boundingBoxes);

    return sigObj;
  }
}
