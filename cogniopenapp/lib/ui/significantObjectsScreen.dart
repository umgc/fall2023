import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class SignificantObjectScreen extends StatefulWidget {
  SignificantObjectScreen({super.key});

  @override
  State<SignificantObjectScreen> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<SignificantObjectScreen> {
  File? _image;
  final imagePicker = ImagePicker();

  final ImagePicker _picker = ImagePicker();
  Future imagePickerMethodfromcamera() async {
    await _picker
        .pickImage(source: ImageSource.camera)
        .then((XFile? recordedimage) {
      if (recordedimage != null && recordedimage.path != null) {
        //   setState(() {
        //   firstbuttontext = 'saving in progress...';
        //  });
        GallerySaver.saveImage(recordedimage.path).then((path) {
          setState(() {
            //   firstbuttontext = 'image saved!';
          });
        });
      }
    });
    showSnackBar("Image Uploaded Succesfully", Duration(milliseconds: 700));
  }

  Future imagePickerMethodfromgallery() async {
    await _picker
        .pickImage(source: ImageSource.gallery)
        .then((XFile? recordedimage) {
      if (recordedimage != null && recordedimage.path != null) {
        // setState(() {
        //    firstbuttontext = 'saving in progress...';
        //});
        GallerySaver.saveImage(recordedimage.path).then((path) {
          setState(() {
            // firstbuttontext = 'image saved!';
          });
        });
      }
    });
    showSnackBar("Image Uploaded Succesfully", Duration(milliseconds: 700));
  }
//Directory? directory = Directory('/selam');

  bool isImageSelected = false;
  late File imageFile;

  late Future _futureGetPath;
  List<dynamic> listImagePath = <dynamic>[];
  var _permissionStatus;

  void initState() {
    super.initState();
    _listenForPermissionStatus();
    // Declaring Future object inside initState() method
    // prevents multiple calls inside stateful widget
    _futureGetPath = _getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        //backgroundColor: const Color(0xFFB3E5FC), // Set background color
        appBar: AppBar(
          backgroundColor: const Color(0x440000), // Set appbar background color
          elevation: 0.0,
          centerTitle: true, // This centers the title
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisSize: MainAxisSize
                .min, // This ensures the Row takes the least amount of space
            children: [
              Image.asset(
                'assets/icons/app_icon.png', // Replace this with your icon's path
                fit: BoxFit.contain,
                height: 32, // Adjust the size as needed
              ),
              const SizedBox(width: 10), // Spacing between the icon and title
              const Text('CogniOpen',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54)),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black54,
              ),
              onPressed: () {
                // Navigate back to the previous screen
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: <Widget>[
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
                            imagePickerMethodfromcamera();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                const Color(0XFFCCFFFF), // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Square border
                            ),
                          ),
                          key: const Key("TakePictureButtonKey"),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.camera,
                                  size: 40, color: Colors.black54),
                              const SizedBox(
                                height:
                                    8.0, // Add some spacing between the image and text
                              ),
                              const Text('Camera'),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            imagePickerMethodfromgallery();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor:
                                const Color(0XFFCCFFFF), // Button text color
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0), // Square border
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.upload_file,
                                  size: 40, color: Colors.black54),
                              const SizedBox(
                                height:
                                    8.0, // Add some spacing between the image and text
                              ),
                              const Text(' Upload Image'),
                            ],
                          ),
                          key: const Key("UploadFromGalleryButtonKey"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              FutureBuilder(
                future: _futureGetPath,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    var dir = Directory(snapshot.data);
                    if (_permissionStatus) _fetchFiles(dir);
                    return Text("");
                  } else {
                    return Text("Loading");
                  }
                },
              ),
              const Divider(
                color: Colors.black54,
                height: 25,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Significant Objects",
                      style: TextStyle(
                        fontSize: 20.0, // Adjust font size as needed
                        color: Colors
                            .black87, // Slightly transparent white for subheading
                      ),
                    ),
                  ]),
              Divider(
                color: Colors.black54,
                height: 25,
                thickness: 2,
                indent: 15,
                endIndent: 15,
              ),
              SizedBox(
                height: 5000,
                child: GridView.count(
                  primary: false,
                  padding: const EdgeInsets.all(20),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: _getListImg(listImagePath),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ));
  }

  void _listenForPermissionStatus() async {
    final status = await Permission.storage.request().isGranted;
    // setState() triggers build again
    setState(() => _permissionStatus = status);
  }

  Future<String> _getPath() {
    return ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_PICTURES);
  }

  _fetchFiles(Directory dir) {
    List<dynamic> listImage = <dynamic>[];
    dir.list().forEach((element) {
      RegExp regExp =
          new RegExp("\.(gif|jpe?g|tiff?|png|webp|bmp)", caseSensitive: false);
      // Only add in List if path is an image
      if (regExp.hasMatch('$element')) listImage.add(element);
      setState(() {
        listImagePath = listImage;
      });
    });
  }

  List<Widget> _getListImg(List<dynamic> listImagePath) {
    List<Widget> listImages = <Widget>[];
    for (var imagePath in listImagePath) {
      listImages.add(
        Container(
          padding: const EdgeInsets.all(8),
          child: Image.file(imagePath, fit: BoxFit.cover),
        ),
      );
    }
    return listImages;
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(content: Text(snackText), duration: d);
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
