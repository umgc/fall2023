import 'imageUploads.dart';
import 'package:flutter/material.dart';

class SignificantObjectScreen extends StatelessWidget {
  SignificantObjectScreen({super.key});

  List<String> imagelist = [
    "assets/test_images/coat.jpg",
    "assets/test_images/coffee.jpg",
    "assets/test_images/key.jpg",
    "assets/test_images/laptop.jpg",
    "assets/test_images/pen.jpg",
    "assets/test_images/wallet.jpg",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF880E4F), // Set background color
      appBar: AppBar(
        backgroundColor: const Color(0XFFE91E63), // Set appbar background color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/app_icon.png', // Replace this with your icon's path
              fit: BoxFit.contain,
              height: 32, // Adjust the size as needed
            ),
            const SizedBox(width: 10), // Spacing between the icon and title
            const Text('CogniOpen', textAlign: TextAlign.center),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu, // Hamburger icon
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ],
      ),

      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  // Spacing between rows

                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Chat bot/Virtual Assistant screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FromCamera()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor:
                            const Color(0XFFC6FF00), // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Square border
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/gallery.png',
                            width: 75.0, // You can adjust the width and height
                            height: 25.0, // as per your requirement
                          ),
                          const SizedBox(
                            height:
                                8.0, // Add some spacing between the image and text
                          ),
                          const Text('Camera'),
                        ],
                      ),
                      key: const Key("TakePictureButtonKey"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigate to Gallery screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UploadFromGallery()));
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor:
                            const Color(0XFFC6FF00), // Button text color
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(10.0), // Square border
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            'assets/icons/gallery.png',
                            width: 75.0, // You can adjust the width and height
                            height: 25.0, // as per your requirement
                          ),
                          const SizedBox(
                            height:
                                8.0, // Add some spacing between the image and text
                          ),
                          const Text('Gallery'),
                        ],
                      ),
                      key: const Key("UploadFromGalleryButtonKey"),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              color: const Color(0XFFC6FF00),
              height: 25,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            )),
            Text(
              "Significants",
              style: TextStyle(
                fontSize: 20.0, // Adjust font size as needed
                color:
                    Colors.white70, // Slightly transparent white for subheading
              ),
            ),
            Expanded(
                child: Divider(
              color: const Color(0XFFC6FF00),
              height: 25,
              thickness: 2,
              indent: 15,
              endIndent: 15,
            )),
          ]),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 788,
            child: GridView.builder(
                itemCount: imagelist.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 15),
                itemBuilder: (
                  context,
                  index,
                ) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                          image: AssetImage(imagelist[index]),
                          fit: BoxFit.cover),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
