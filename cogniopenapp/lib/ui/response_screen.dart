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
  List<VideoResponse> displayedResponses = ResponseParser.getListOfResponses();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterResponses);
  }

  void filterResponses() {
    final searchTerm = searchController.text.toLowerCase();
    setState(() {
      displayedResponses = widget.responses.where((response) {
        return response.title.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black54),
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search by Title',
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
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
                    SizedBox(
                      height: 80,
                    ),
                    for (var response in displayedResponses)
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
                        child: returnResponseBox(response),
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

  Container returnResponseBox(VideoResponse response) {
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
            "${response.title}: ${ResponseParser.getTimeStampFromResponse(response)} (${ResponseParser.getHoursFromResponse(response)})",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          getFutureThumbnail(response),
          //getBoundingBox(response),
        ],
      ),
    );
  }

  SizedBox addSpacingSizedBox() {
    return SizedBox(
      height: 8,
    );
  }

  Positioned getBoundingBox(
    VideoResponse response,
    /* Image stillImage*/
  ) {
    double imageWidth = 412;
    double imageHeight = 892;

    /*
    if (stillImage.width != null && stillImage.height != null) {
      print("Not null");
      imageWidth = stillImage.width!;
      imageHeight = stillImage.height!;
    }
    */
    return Positioned(
      left: imageWidth * response.left,
      top: imageHeight * response.top,
      child: Opacity(
        opacity: 0.35,
        child: Material(
          child: InkWell(
            child: Container(
              width: imageWidth * response.width,
              height: imageHeight * response.height,
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
                    '${response.title} ${((response.confidence * 100).truncateToDouble()) / 100}%',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class VideoResponseGridScreen extends StatelessWidget {
  final List<VideoResponse> videoResponses;

  VideoResponseGridScreen(this.videoResponses);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Responses Grid Screen'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Display two columns per row.
        ),
        itemBuilder: (context, index) {
          final videoResponse = videoResponses[index];
          return GridTile(
            child: Stack(
              children: [
                getFutureThumbnail(videoResponse),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    color: Colors.black.withOpacity(0.7),
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      "Timestamp: ${ResponseParser.getTimeStampFromResponse(videoResponse)} (${ResponseParser.getHoursFromResponse(videoResponse)})",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        itemCount: videoResponses.length,
      ),
    );
  }
}

FutureBuilder<Image> getFutureThumbnail(VideoResponse videoResponse) {
  return FutureBuilder<Image>(
    future: ResponseParser.getThumbnail(videoResponse),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        return Column(
          children: [
            Container(
              child: snapshot.data, // Wrap Image in a Container
            ),
          ],
        );
      } else {
        // While loading the image, you can display a loading indicator or placeholder.
        return CircularProgressIndicator();
      }
    },
  );
}
