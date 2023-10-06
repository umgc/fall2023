import 'package:flutter/material.dart';

import 'homescreen.dart';
import '../src/media.dart';

// Images taken from: https://www.yttags.com/blog/image-url-for-testing/
List<Photo> createTestPhotoList() {
  return [
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam.png'),
      Media(
        title: 'Spunky Sam',
        description: 'Avatar of Spunky Sam',
        tags: ['avatar', 'spunky'],
        timeStamp: DateTime.now(),
        storageSize: 1024,
        isFavorited: false,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png'),
      Media(
        title: 'Spunky Sam (Green)',
        description: 'Green version of Spunky Sam avatar',
        tags: ['avatar', 'spunky', 'green'],
        timeStamp: DateTime.now(),
        storageSize: 2048,
        isFavorited: true,
      ),
    ),
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi.png'),
      Media(
        title: 'Purple Pi',
        description: 'Avatar of Purple Pi',
        tags: ['avatar', 'purple', 'pi'],
        timeStamp: DateTime.now(),
        storageSize: 512,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'),
      Media(
        title: 'Purple Pi (Teal)',
        description: 'Teal version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'teal'],
        timeStamp: DateTime.now(),
        storageSize: 1536,
        isFavorited: true,
      ),
    ),
    // Photo for 'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'
    Photo(
      Image.network(
          'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'),
      Media(
        title: 'Purple Pi (Pink)',
        description: 'Pink version of Purple Pi avatar',
        tags: ['avatar', 'purple', 'pink'],
        timeStamp: DateTime.now(),
        storageSize: 768,
        isFavorited: false,
      ),
    ),
    // Add more test objects for other URLs as needed
  ];
}

class GalleryScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      // Implement the Gallery screen UI here
    );
  }

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  // List of image URLs, you can replace these with your image URLs.
  List<Photo> testPhotos = createTestPhotoList();

  double _crossAxisCount = 2.0; // Default crossAxisCount value
  double _fontSize = 16.0; // Default font size for text
  double _iconSize = 40.0; // Default icon size

  void _updateLayoutValues() {
    if (_crossAxisCount <= 1.0) {
      _crossAxisCount = 1.0;

      _fontSize = 20.0;
      _iconSize = 40.0;
    } else if (_crossAxisCount <= 2.0) {
      _fontSize = 18.0;
      _iconSize = 36.0;
    } else if (_crossAxisCount <= 3.0) {
      _fontSize = 16.0;
      _iconSize = 30.0;
    } else {
      _crossAxisCount = 4.0;
      _fontSize = 12.0;
      _iconSize = 24.0;
    }
    print(_crossAxisCount);
  }

  @override
  Widget build(BuildContext context) {
    _updateLayoutValues();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
      ),
      body: Column(
        children: [
          Slider(
            value: _crossAxisCount,
            min: 1.0,
            max: 4.0,
            divisions: 3,
            onChanged: (value) {
              setState(() {
                _crossAxisCount = value;
              });
            },
            label: 'Grid Size',
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount.toInt(),
              ),
              itemCount: testPhotos.length,
              itemBuilder: (BuildContext context, int index) {
                Photo photo = testPhotos[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return Scaffold(
                            appBar: AppBar(
                              title: Text('Full Screen Image and Details'),
                            ),
                            body: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(image: photo.associatedImage.image),
                                  SizedBox(height: 16),
                                  Text('Title: ${photo.title}',
                                      style: TextStyle(fontSize: _fontSize)),
                                  Text('Description: ${photo.description}',
                                      style: TextStyle(fontSize: _fontSize)),
                                  Text('Tags: ${photo.tags?.join(", ")}',
                                      style: TextStyle(fontSize: _fontSize)),
                                  Text(
                                      'Time Stamp: ${photo.timeStamp?.toString() ?? "N/A"}',
                                      style: TextStyle(fontSize: _fontSize)),
                                  Text('Storage Size: ${photo.storageSize}',
                                      style: TextStyle(fontSize: _fontSize)),
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
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child:
                                      Image(image: photo.associatedImage.image),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                photo.title,
                                style: TextStyle(fontSize: _fontSize),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                print("THE STAR WAS CLICKED");
                                setState(() {
                                  // Toggle favorite status when the star icon is tapped
                                  photo.isFavorited = !photo.isFavorited;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    photo.isFavorited
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: photo.isFavorited
                                        ? Colors.yellow
                                        : Colors.grey,
                                    size: _iconSize,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: photo.iconType,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
