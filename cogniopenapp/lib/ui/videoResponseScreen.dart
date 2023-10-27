import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;
import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/data_service.dart';

import 'package:cogniopenapp/src/aws_video_response.dart';

List<AWS_VideoResponse> createTestResponseList() {
  return [
    /* 
    AWS_VideoResponse('Water', 100, 52852, "fake file"),
    AWS_VideoResponse('Aerial View', 96.13745880126953, 53353, "fake file"),
    AWS_VideoResponse('Animal', 86.5937728881836, 53353, "fake file"),
    AWS_VideoResponse('Coast', 99.99983215332031, 53353, "fake file"), */
    AWS_VideoResponse.overloaded(
        'Fish',
        90.63278198242188,
        53353,
        ResponseBoundingBox(
            left: 0.11934830248355865,
            top: 0.7510809302330017,
            width: 0.05737469345331192,
            height: 0.055630747228860855),
        "fake file"),
    // Add more test objects for other URLs as needed
  ];
}

List<AWS_VideoResponse> createResponseList(
    rek.GetLabelDetectionResponse response) {
  List<AWS_VideoResponse> responseList = [];
  List<String?> recognizedItems = [];

  Iterator<rek.LabelDetection> iter = response.labels!.iterator;
  while (iter.moveNext()) {
    for (rek.Instance inst in iter.current.label!.instances!) {
      String? name = iter.current.label!.name;
      if (recognizedItems.contains(name)) {
        continue;
      } else {
        recognizedItems.add(name);
      }
      AWS_VideoResponse newResponse = AWS_VideoResponse.overloaded(
          iter.current.label!.name ?? "default value",
          iter.current.label!.confidence ?? 80,
          iter.current.timestamp ?? 0,
          ResponseBoundingBox(
              left: inst.boundingBox!.left ?? 0,
              top: inst.boundingBox!.top ?? 0,
              width: inst.boundingBox!.width ?? 0,
              height: inst.boundingBox!.height ?? 0),
          "fake file");
      responseList.add(newResponse);
    }
  }
  return responseList;
}

class AWS_VideoResponseScreen extends StatefulWidget {
  final rek.GetLabelDetectionResponse awsResponses;
  const AWS_VideoResponseScreen(this.awsResponses, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Responses',
            style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  @override
  AWS_VideoResponseScreenState createState() =>
      // ignore: no_logic_in_create_state
      AWS_VideoResponseScreenState(awsResponses);
}

class AWS_VideoResponseScreenState extends State<AWS_VideoResponseScreen> {
  rek.GetLabelDetectionResponse awsResponses;
  AWS_VideoResponseScreenState(this.awsResponses);

  @override
  Widget build(BuildContext context) {
    //List<AWS_VideoResponse> realResponse = createTestResponseList();
    List<AWS_VideoResponse> realResponse = createResponseList(awsResponses);
    DataService.instance.addVideoResponses(realResponse);
    double imageWidth = 320;
    double imageHeight = 240;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Responses',
            style: TextStyle(color: Colors.black54)),
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
              AWS_VideoResponse response = realResponse[index];
              response.setImage(response.timestamp);
              return GestureDetector(
                onTap: () async {
                  //response.setImage(response.timestamp);
                  // imageWidth = realResponse[0].exampleImage.width!;
                  //imageHeight = realResponse[0].exampleImage.height!;
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
                                Stack(
                                  children: [
                                    Image(image: response.exampleImage.image),
                                    //if (_isRectangleVisible)
                                    Positioned(
                                      //TODO: hardcoded video frame width and height; these need replaced with whatever actually comes in as the image
                                      left: imageWidth *
                                          response.boundingBox!.left,
                                      top: imageHeight *
                                          response.boundingBox!.top,
                                      child: Opacity(
                                        opacity: 0.35,
                                        child: Material(
                                          child: InkWell(
                                            child: Container(
                                              width: imageWidth *
                                                  response.boundingBox!.width,
                                              height: imageHeight *
                                                  response.boundingBox!.height,
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
                                                    '${response.name} ${((response.confidence * 100).truncateToDouble()) / 100}%',
                                                    style: const TextStyle(
                                                        color: Colors.white),
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
                                const SizedBox(height: 16),
                                Text('Timestamp: ${response.timestamp}',
                                    style: const TextStyle(fontSize: 18)),
                                Text('Name: ${response.name}',
                                    style: const TextStyle(fontSize: 18)),
                                //Text('Confidence: ${response.confidence}'),
                                //Text('Timestamp: ${response.timestamp}'),
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
                        //Image(image: response.exampleImage.image),
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
