import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/response_parser.dart';

import 'package:flutter/material.dart';

class ResponseScreen extends StatefulWidget {
  List<VideoResponse> responses = ResponseParser.getListOfResponses();

  ResponseScreen();

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the Scaffold's background transparent
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Make the AppBar's background transparent
        elevation: 0.0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black54),
        title: const Text('Response Screen',
            style: TextStyle(color: Colors.black54)),
      ),
      body: Container(
        height:
            screenHeight, // Set the height of the Container to the screen height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    for (var response in widget.responses)
                      GestureDetector(
                        onTap: () {
                          // Navigate to the VideoResponseGridScreen when a returnTextBox is tapped.
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoResponseGridScreen(
                                  ResponseParser.getRequestedResponseList(
                                      response.title)),
                            ),
                          );
                        },
                        child: returnTextBox(
                            response.title, response.referenceVideoFilePath),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container returnTextBox(String title, String contents) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            contents,
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  SizedBox addSpacingSizedBox() {
    return SizedBox(
      height: 8,
    );
  }
}

class VideoResponseGridScreen extends StatelessWidget {
  final List<VideoResponse> videoResponses;

  VideoResponseGridScreen(this.videoResponses);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the Scaffold's background transparent
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Make the AppBar's background transparent
        elevation: 0.0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black54),
        title: const Text('Response Screen',
            style: TextStyle(color: Colors.black54)),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display two columns per row.
        ),
        itemBuilder: (context, index) {
          final videoResponse = videoResponses[index];
          return GridTile(
            child: FutureBuilder<Image>(
              future: ResponseParser.getThumbnail(videoResponse),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Container(
                        child: snapshot.data, // Wrap Image in a Container
                      ),
                      Text('Timestamp: ${videoResponse.timestamp}'),
                    ],
                  );
                } else {
                  // While loading the image, you can display a loading indicator or placeholder.
                  return CircularProgressIndicator();
                }
              },
            ),
          );
        },
        itemCount: videoResponses.length,
      ),
    );
  }
}
