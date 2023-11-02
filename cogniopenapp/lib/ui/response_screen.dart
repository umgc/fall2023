import 'package:cogniopenapp/src/database/model/video_response.dart';
import 'package:cogniopenapp/src/response_parser.dart';
import 'package:cogniopenapp/src/data_service.dart';

import 'package:flutter/material.dart';

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| INITIAL SCREEN |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
class ResponseScreen extends StatefulWidget {
  ResponseScreen();

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
    print("BUILDING AGIAN");
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
                              builder: (context) => ImageNavigatorScreen(
                                  ResponseParser.getRequestedResponseList(
                                      response.title,
                                      filterInterval: 3000)),
                            ),
                          );
                        },
                        child: returnResponseBox(response,
                            "${response.title}: ${ResponseParser.getTimeStampFromResponse(response)} (${ResponseParser.getHoursFromResponse(response)}) \nADDRRESS"),
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

  SizedBox addSpacingSizedBox() {
    return SizedBox(
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
            style: TextStyle(color: Colors.black54)),
        elevation: 0,
        leading: const BackButton(color: Colors.black54),
      ),
      body: Container(
        height: screenHeight,
        decoration: BoxDecoration(
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
                  SizedBox(
                    height: 60,
                  ),
                  returnResponseBox(videoResponse,
                      "${ResponseParser.getTimeStampFromResponse(videoResponse)} (${ResponseParser.getHoursFromResponse(videoResponse)}) \nADDRRESS"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            showConfirmationDialog(videoResponse.title);
                          },
                          child: Text("This is the object I was looking for"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void showConfirmationDialog(String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Saved as a significant object (NOT REALLY YET THOUGH)"),
          content: Text(
            "Would you like to delete all previous spottings of this item to save space?",
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Pop one screen
                    Navigator.of(context).pop(); // Pop the second screen
                  },
                  child: Text("No, keep them"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await deletePreviousResponses(title);
                    Navigator.of(context).pop(); // Pop one screen
                    Navigator.of(context).pop(); // Pop the second screen
                    Navigator.of(context).pop(); // Pop the second screen
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

  Future<void> deletePreviousResponses(String responsesToDelete) async {
    List<VideoResponse> responses =
        ResponseParser.getRequestedResponseList(responsesToDelete);
    print("RESPONSE LENGTH: ${responses.length}");
    for (VideoResponse response in responses) {
      print("REMOVED ID: ${response.id!}");
      await DataService.instance.removeVideoResponse(response.id!);
    }
  }
}

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| COMMON FUNCTIONALITY |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

FutureBuilder<Image> getFutureThumbnail(VideoResponse videoResponse) {
  return FutureBuilder<Image>(
    future: ResponseParser.getThumbnail(videoResponse),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        Image? image = snapshot.data; // Get the Image widget from the snapshot

        // Access the height and width of the Image widget with null-aware operators
        double imageHeight = image?.height ?? 0.0;
        double imageWidth = image?.width ?? 0.0;

        return Column(
          children: [
            Container(
              child: image, // Wrap Image in a Container
            ),
            //Text(
            //'Height: $imageHeight, Width: $imageWidth'), // Display height and width
          ],
        );
      } else {
        // While loading the image, you can display a loading indicator or placeholder.
        return CircularProgressIndicator();
      }
    },
  );
}

Container returnResponseBox(VideoResponse response, String title) {
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
        Stack(
          children: [
            getFutureThumbnail(response),
            getBoundingBox(response),
          ],
        )
      ],
    ),
  );
}

Positioned getBoundingBox(
  VideoResponse response,
  /* Image stillImage*/
) {
  double imageWidth = 400;
  double imageHeight = 700;

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
