import 'package:flutter/material.dart';

import 'homescreen.dart';
import '../src/media.dart';

// Images taken from: https://www.yttags.com/blog/image-url-for-testing/
List<Media> createTestMediaList() {
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
    Video(
      '2:30', // Duration
      true, // Auto-delete
      [
        IdentifiedItem(
          'Item 1',
          DateTime.now(), // Time spotted
          Image.network(
            'https://www.example.com/item1.jpg', // Item image URL
          ),
        ),
        IdentifiedItem(
          'Item 2',
          DateTime.now()
              .subtract(Duration(days: 1)), // Time spotted (1 day ago)
          Image.network(
            'https://www.example.com/item2.jpg', // Item image URL
          ),
        ),
      ],
      Image.network(
          'https://cdn.fstoppers.com/styles/article_med/s3/media/2020/05/18/exploration_is_key_to_making_unique_landscape_photos_01.jpg'),
      Media(
        title: 'Test Video',
        description: 'This is a test video',
        tags: ['video', 'test'],
        timeStamp: DateTime.now(),
        storageSize: 4096,
        isFavorited: false,
      ), // Associated media (in this case, a photo)
    )
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
