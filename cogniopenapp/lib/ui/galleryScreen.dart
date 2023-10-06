import 'package:flutter/material.dart';

import 'homescreen.dart';
import '../src/media.dart';
import '../src/video.dart';
import '../src/photo.dart';
import '../src/conversation.dart';

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

  List<Media> testMedia = createTestMediaList();

  double _defaultFontSize = 20.0;

  double _crossAxisCount = 2.0; // Default crossAxisCount value
  double _fontSize = 16.0; // Default font size for text
  double _iconSize = 40.0; // Default icon size
  String _searchText = ''; // Text entered in the search bar

  void _updateLayoutValues() {
    if (_crossAxisCount <= 1.0) {
      _crossAxisCount = 1.0;
      _fontSize = 40.0;
      _iconSize = 60.0;
    } else if (_crossAxisCount <= 2.0) {
      _fontSize = 30.0;
      _iconSize = 40.0;
    } else if (_crossAxisCount <= 3.0) {
      _fontSize = 18.0;
      _iconSize = 20.0;
    } else {
      _crossAxisCount = 4.0;
      _fontSize = 10.0;
      _iconSize = 10.0;
    }
  }

  List<Media> get filteredPhotos {
    if (_searchText.isEmpty) {
      return testMedia;
    } else {
      return testMedia
          .where((media) =>
              media.title.toLowerCase().contains(_searchText.toLowerCase()))
          .toList();
    }
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Search by Title',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
            },
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _crossAxisCount.toInt(),
              ),
              itemCount: filteredPhotos.length,
              itemBuilder: (BuildContext context, int index) {
                Media media = filteredPhotos[index];
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
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Title and Time Stamp at the top
                                    Text('Title: ${media.title}',
                                        style: TextStyle(
                                            fontSize: _defaultFontSize)),
                                    Text(
                                        'Time Stamp: ${media.formatDateTime(media.timeStamp) ?? "N/A"}',
                                        style: TextStyle(
                                            fontSize: _defaultFontSize)),

                                    // Image (if applicable)
                                    if (media is Photo &&
                                        media.associatedImage != null)
                                      Image(
                                        image: media.associatedImage.image,
                                      ),
                                    if (media is Video)
                                      Image(
                                        image: media.thumbnail.image,
                                      ),

                                    SizedBox(height: 16),

                                    // Description, Tags, and Storage Size below the image
                                    Text(
                                      'Description: ${media.description}',
                                      style:
                                          TextStyle(fontSize: _defaultFontSize),
                                      textAlign: TextAlign.center,
                                    ),

                                    Text('Tags: ${media.tags?.join(", ")}',
                                        style: TextStyle(
                                            fontSize: _defaultFontSize)),
                                    Text(
                                      'Storage Size: ${media.getStorageSizeString()}',
                                      style:
                                          TextStyle(fontSize: _defaultFontSize),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                  // Home screen grid alignment
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
                              if (media is Photo &&
                                  media.associatedImage != null)
                                Expanded(
                                  child: Center(
                                    child: Image(
                                        image: media.associatedImage.image),
                                  ),
                                ),
                              if (media is Video)
                                Image(
                                    image: media.thumbnail.image,
                                    width:
                                        100.0 + (2.0 - _crossAxisCount) * 25.0,
                                    height:
                                        100.0 + (2.0 - _crossAxisCount) * 25.0),
                              SizedBox(height: 8),
                              Text(
                                media.title,
                                style: TextStyle(fontSize: _fontSize),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  // Toggle favorite status when the star icon is tapped
                                  media.isFavorited = !media.isFavorited;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    media.isFavorited
                                        ? Icons.star
                                        : Icons.star_border,
                                    color: media.isFavorited
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
                            child: Icon(
                              media.iconType.icon,
                              size: _iconSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Slider(
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
          ),
        ],
      ),
    );
  }
}
