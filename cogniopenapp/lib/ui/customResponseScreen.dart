import 'package:aws_rekognition_api/rekognition-2016-06-27.dart' as rek;
import 'package:cogniopenapp/src/custom_label_response.dart';
import 'package:flutter/material.dart';

/*List<VideoResponse> createTestResponseList() {
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
*/

List<CustomLabelResponse> createResponseList(
    rek.DetectCustomLabelsResponse response) {
  List<CustomLabelResponse> responseList = [];
  List<String?> recognizedItems = [];

  Iterator<rek.CustomLabel> iter = response.customLabels!.iterator;
  while (iter.moveNext()) {
    //for (rek.Instance inst in iter.current.customLabels!.instances!) {
    String? name = iter.current.name;
    if (recognizedItems.contains(name)) {
      continue;
    } else {
      recognizedItems.add(name);
    }
    CustomLabelResponse newResponse = CustomLabelResponse.overloaded(
      iter.current.name ?? "default value",
      iter.current.confidence ?? 80,
      //iter.current.timestamp ?? 0,
      ResponseBoundingBox(
          left: iter.current.geometry!.boundingBox!.left ?? 0,
          top: iter.current.geometry!.boundingBox!.top ?? 0,
          width: iter.current.geometry!.boundingBox!.width ?? 0,
          height: iter.current.geometry!.boundingBox!.height ?? 0),
    );
    responseList.add(newResponse);
    //}
  }
  return responseList;
}

class CustomResponseScreen extends StatefulWidget {
  final rek.DetectCustomLabelsResponse awsResponses;
  const CustomResponseScreen(this.awsResponses, {super.key});

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Query Responses',
            style: TextStyle(color: Colors.black54)),
      ),
    );
  }

  @override
  CustomResponseScreenState createState() =>
      // ignore: no_logic_in_create_state
      CustomResponseScreenState(awsResponses);
}

class CustomResponseScreenState extends State<CustomResponseScreen> {
  rek.DetectCustomLabelsResponse awsResponses;
  CustomResponseScreenState(this.awsResponses);

  @override
  Widget build(BuildContext context) {
    //List<VideoResponse> realResponse = createTestResponseList();
    List<CustomLabelResponse> realResponse = createResponseList(awsResponses);
    double imageWidth = 225;
    double imageHeight = 225;
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
              CustomLabelResponse response = realResponse[index];
              //response.setImage(response.timestamp);
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
                                //Text('Timestamp: ${response.timestamp}',
                                //style: const TextStyle(fontSize: 18)),
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
