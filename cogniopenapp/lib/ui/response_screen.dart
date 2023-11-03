// ignore_for_file: avoid_print

import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/response_parser.dart';
import 'package:cogniopenapp/src/data_service.dart';

import 'package:flutter/material.dart';

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| INITIAL SCREEN |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class ResponseScreen extends StatefulWidget {
  const ResponseScreen();

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen>
    with WidgetsBindingObserver {
  List<VideoResponse> displayedResponses = ResponseParser.getListOfResponses();
  TextEditingController searchController = TextEditingController();

  List<VideoResponse> responses = ResponseParser.getListOfResponses();

  @override
  void initState() {
    super.initState();
    searchController.addListener(filterResponses);
  }

  void filterResponses() {
    final searchTerm = searchController.text.toLowerCase();
    setState(() {
      displayedResponses = responses.where((response) {
        return response.title.toLowerCase().contains(searchTerm);
      }).toList();
    });
  }

  void refreshScreen() {
    // You can do any necessary refresh logic here
    setState(() {});
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
          decoration: const InputDecoration(
            hintText: 'Search by Title',
          ),
        ),
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 80,
                    ),
                    for (var response in displayedResponses)
                      GestureDetector(
                          onTap: () {
                            // Navigate to the VideoResponseGridScreen when a returnTextBox is tapped.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ImageNavigatorScreen(
                                    ResponseParser.getRequestedResponseList(
                                        response.title,
                                        filterInterval: 3000)),
                              ),
                            );
                          },
                          child: ResponseBox(response,
                              "${response.title}: ${ResponseParser.getTimeStampFromResponse(response)} (${ResponseParser.getHoursFromResponse(response)}) \nSeen at: ${response.address}")),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SizedBox addSpacingSizedBox() {
    return const SizedBox(
      height: 8,
    );
  }
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ENHANCED SEARCH |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

class ImageNavigatorScreen extends StatefulWidget {
  final List<VideoResponse> videoResponses;

  ImageNavigatorScreen(this.videoResponses);

  @override
  _ImageNavigatorScreenState createState() => _ImageNavigatorScreenState();
}

class _ImageNavigatorScreenState extends State<ImageNavigatorScreen>
    with WidgetsBindingObserver {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0x440000), // Set appbar background color
        centerTitle: true,
        title: Text('${widget.videoResponses[0].title}',
            style: const TextStyle(color: Colors.black54)),
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: Container(
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView.builder(
          itemCount: widget.videoResponses.length,
          controller: PageController(initialPage: currentIndex),
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          itemBuilder: (context, index) {
            final videoResponse = widget.videoResponses[index];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(
                    height: 60,
                  ),
                  ResponseBox(videoResponse,
                      "${ResponseParser.getTimeStampFromResponse(videoResponse)} (${ResponseParser.getHoursFromResponse(videoResponse)}) \nSeen at: ${videoResponse.address}"),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| RESPONSE WIDGET |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

class ResponseBox extends StatelessWidget {
  final VideoResponse response;
  final String title;

  ResponseBox(this.response, this.title);

  @override
  Widget build(BuildContext context) {
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Stack(
            children: [
              FutureBuilder<Image>(
                future: ResponseParser.getThumbnail(response),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Image? image = snapshot.data;
                    return Container(
                      child: image,
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
              getBoundingBox(response),
              Positioned(
                bottom: 0, // Position the Row at the top of the Stack
                left: 0, // You can adjust the left position if needed
                right: 0, // You can adjust the right position if needed
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(133, 102, 179, 194),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                10.0), // Adjust the radius as needed
                          ),
                        ),
                        child:
                            const Text("This is the object I was looking for"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> deletePreviousResponses(String responsesToDelete) async {
    List<VideoResponse> responses =
        ResponseParser.getRequestedResponseList(responsesToDelete);
    for (VideoResponse response in responses) {
      await DataService.instance.removeVideoResponse(response.id!);
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
              "Saved as a significant object (NOT REALLY YET THOUGH)"),
          content: const Text(
            "Would you like to delete all previous spottings of this item to save space?",
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop the third screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResponseScreen()),
                    );
                  },
                  child: const Text("No, keep them"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await deletePreviousResponses(response.title);
                    Navigator.of(context).pop(); // Close the dialog

                    // Navigate back to the ResponseScreen
                    Navigator.of(context).pop(); // Pop the third screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ResponseScreen()),
                    );
                  },
                  child: Text("Yes, please delete them"),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Positioned getBoundingBox(VideoResponse response) {
    double imageWidth = 375;
    double imageHeight = 675;

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
