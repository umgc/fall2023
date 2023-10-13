import 'package:aws_rekognition_api/rekognition-2016-06-27.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_speed_dial/flutter_speed_dial.dart';

//import '../src/video_processor.dart';
import '../src/video_response.dart';

List<VideoResponse> createTestResponseList() {
  return [
    VideoResponse(
      'Water',
      100,
      52852,
    ),
    VideoResponse(
      'Aerial View',
      96.13745880126953,
      53353,
    ),
    VideoResponse(
      'Animal',
      86.5937728881836,
      53353,
    ),
    VideoResponse(
      'Coast',
      99.99983215332031,
      53353,
    ),
    VideoResponse.overloaded(
      'Fish',
      90.63278198242188,
      53353,
      ResponseBoundingBox(
          left: 0.11934830248355865,
          top: 0.7510809302330017,
          width: 0.05737469345331192,
          height: 0.055630747228860855),
    ),
    // Add more test objects for other URLs as needed
  ];
}

List<VideoResponse> createResponseList(GetLabelDetectionResponse response) {
  List<VideoResponse> responseList = [];
  List<String?> recognizedItems = [];

  Iterator<LabelDetection> iter = response.labels!.iterator;
  while (iter.moveNext()) {
    for (Instance inst in iter.current.label!.instances!) {
      String? name = iter.current.label!.name;
      if (recognizedItems.contains(name)) {
        continue;
      } else {
        recognizedItems.add(name);
      }
      VideoResponse newResponse = VideoResponse.overloaded(
        iter.current.label!.name ?? "default value",
        iter.current.label!.confidence ?? 80,
        iter.current.timestamp ?? 0,
        ResponseBoundingBox(
            left: inst.boundingBox!.left ?? 0,
            top: inst.boundingBox!.top ?? 0,
            width: inst.boundingBox!.width ?? 0,
            height: inst.boundingBox!.height ?? 0),
      );
      responseList.add(newResponse);
    }
  }
  return responseList;
}

class VideoResponseScreen extends StatefulWidget {
  final GetLabelDetectionResponse awsResponses;
  const VideoResponseScreen(this.awsResponses, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Responses'),
      ),
    );
  }

  @override
  VideoResponseScreenState createState() =>
      // ignore: no_logic_in_create_state
      VideoResponseScreenState(awsResponses);
}

class VideoResponseScreenState extends State<VideoResponseScreen> {
  GetLabelDetectionResponse awsResponses;
  VideoResponseScreenState(this.awsResponses);

  @override
  Widget build(BuildContext context) {
    //List<VideoResponse> realResponse = createTestResponseList();
    List<VideoResponse> realResponse = createResponseList(awsResponses);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Responses'),
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(
              16.0, 16.0, 16.0, 4.0), // Adjust padding as needed
          child: Text(
            'Recent query responses', // This is the header text
            style: TextStyle(
              fontSize: 24.0, // Adjust font size as needed
              fontWeight: FontWeight.bold,
              //color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: realResponse.length,
            itemBuilder: (BuildContext context, int index) {
              VideoResponse response = realResponse[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(
                            title:
                                const Text('Full Screen Response and Details'),
                          ),
                          body: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                //Image(image: response.associatedImage.image),
                                const SizedBox(height: 16),
                                Text('Name: ${response.name}',
                                    style: const TextStyle(fontSize: 18)),
                                Text('Confidence: ${response.confidence}'),
                                Text('Timestamp: ${response.timestamp}'),
                                Text(
                                    'BoundingBox: ${response.boundingBox?.toString() ?? "N/A"}'),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Image(image: response.associatedImage.image),
                        const SizedBox(height: 8),
                        Text(
                          response.name,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // Implement the Video Recording screen UI here
          //add button to grab results
        )
      ]),
    );
  }
}
