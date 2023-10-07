import 'package:flutter/material.dart';

import 'homescreen.dart';
import '../src/media.dart';
import '../src/video.dart';
import '../src/photo.dart';
import '../src/conversation.dart';

// Define an enumeration for sorting criteria
enum SortingCriteria { storageSize, timeStamp, title, type }

// Define a StatefulWidget for the GalleryScreen
class GalleryScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the Gallery screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'), // AppBar title
      ),
      // Implement the Gallery screen UI here
    );
  }

  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

// Define the state for the Gallery screen
class _GalleryScreenState extends State<GalleryScreen> {
  // List of media items (you can replace with your own data)
  List<Media> testMedia = createTestMediaList();

  final double _defaultFontSize = 20.0;
  bool _searchBarVisible = false;
  String _searchText = '';

  // Default font size, icon size, and other layout values
  double _crossAxisCount = 2.0; // Default options for grid columns
  double _fontSize = 16.0;
  double _iconSize = 40.0;

  // Variables used to toggle what is being viewed
  bool _showFavoritedOnly = false;
  bool _showPhotos = true;
  bool _showVideos = true;
  bool _showConversations = true;

  // Variables used for sorting
  SortingCriteria? _selectedSortingCriteria;
  bool _isSortAscending = true;

  // Function to update layout values based on grid size
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

  // Function to filter photos based on the search text
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

  // Function to toggle the visibility of photos
  void _toggleShowPhotos() {
    setState(() {
      _showPhotos = !_showPhotos;
    });
  }

  // Function to toggle the visibility of videos
  void _toggleShowVideos() {
    setState(() {
      _showVideos = !_showVideos;
    });
  }

  // Function to toggle the visibility of conversations
  void _toggleShowConversations() {
    setState(() {
      _showConversations = !_showConversations;
    });
  }

  // Function to get favorited photos
  List<Media> getFavoritedPhotos() {
    return testMedia.where((media) => media.isFavorited).toList();
  }

  // Display names for sorting criteria
  final Map<SortingCriteria, String> sortingCriteriaNames = {
    SortingCriteria.storageSize: 'Sort by Storage Size',
    SortingCriteria.timeStamp: 'Sort by Time Stamp',
    SortingCriteria.title: 'Sort by Title',
    SortingCriteria.type: 'Sort by Type',
  };

  // Function to toggle the sorting order
  void _toggleSortOrder() {
    setState(() {
      _isSortAscending = !_isSortAscending;
      _sortMediaItems();
    });
  }

  // Function to sort media items based on selected criteria and order
  void _sortMediaItems() {
    if (_selectedSortingCriteria == null) {
      return;
    }
    switch (_selectedSortingCriteria) {
      case null:
        break;
      case SortingCriteria.storageSize:
        testMedia.sort((a, b) => _isSortAscending
            ? a.storageSize.compareTo(b.storageSize)
            : b.storageSize.compareTo(a.storageSize));
        break;
      case SortingCriteria.timeStamp:
        testMedia.sort((a, b) => _isSortAscending
            ? a.timeStamp!.compareTo(b.timeStamp!)
            : b.timeStamp!.compareTo(a.timeStamp!));
        break;
      case SortingCriteria.title:
        testMedia.sort((a, b) => _isSortAscending
            ? a.title.compareTo(b.title)
            : b.title.compareTo(a.title));
        break;
      case SortingCriteria.type:
        testMedia.sort((a, b) => _isSortAscending
            ? a.runtimeType.toString().compareTo(b.runtimeType.toString())
            : b.runtimeType.toString().compareTo(a.runtimeType.toString()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _updateLayoutValues();

    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| MENU ACTIONS ON THE TOP BAR |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        actions: [
          IconButton(
            // Search icon
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                // Toggle the search bar visibility
                _searchBarVisible = !_searchBarVisible;
              });
            },
          ),
          IconButton(
            // Favorite icon
            color: _showFavoritedOnly ? Colors.yellow : Colors.grey,
            icon:
                _showFavoritedOnly ? Icon(Icons.star) : Icon(Icons.star_border),
            onPressed: () {
              setState(() {
                // Toggle favorited media visibility
                _showFavoritedOnly = !_showFavoritedOnly;
              });
            },
          ),
          // Photo icon
          IconButton(
            icon: _showPhotos
                ? const Icon(Icons.photo)
                : const Icon(Icons.photo_outlined),
            color: _showPhotos ? Colors.white : Colors.grey,
            onPressed: _toggleShowPhotos,
          ),
          // Video icon
          IconButton(
            color: _showVideos ? Colors.white : Colors.grey,
            icon: _showVideos
                ? const Icon(Icons.videocam)
                : const Icon(Icons.videocam_outlined),
            onPressed: _toggleShowVideos,
          ),
          // Conversation icon
          IconButton(
            color: _showConversations ? Colors.white : Colors.grey,
            icon: _showConversations
                ? const Icon(Icons.chat)
                : const Icon(Icons.chat_outlined),
            onPressed: _toggleShowConversations,
          ),
          // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| POP UP BUTTON FOR SORTING |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
          PopupMenuButton<SortingCriteria>(
            itemBuilder: (BuildContext context) {
              return sortingCriteriaNames.entries.map((entry) {
                final criteria = entry.key;
                final displayName = entry.value;
                final isSelected = _selectedSortingCriteria == criteria;
                return PopupMenuItem<SortingCriteria>(
                  value: criteria,
                  child: Row(
                    children: [
                      Text(displayName),
                      if (isSelected)
                        Icon(
                          _isSortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: Colors.blue,
                        ),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (SortingCriteria criteria) {
              setState(() {
                if (_selectedSortingCriteria == criteria) {
                  // Toggle sorting order if the same criterion is selected again
                  _toggleSortOrder();
                } else {
                  _selectedSortingCriteria = criteria;
                  _isSortAscending = true; // Reset sorting order to ascending
                  _sortMediaItems();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchBarVisible)
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
              itemCount: _showFavoritedOnly
                  ? getFavoritedPhotos().length
                  : filteredPhotos.length,
              itemBuilder: (BuildContext context, int index) {
                // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| FILTERS MEDIA BASED ON SELECTED OPTIONS |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                List<Media> displayedMedia = filteredPhotos.where((media) {
                  if (media is Photo && !_showPhotos) {
                    return false; // Hide photos if _showPhotos is false
                  }
                  if (media is Video && !_showVideos) {
                    return false; // Hide videos if _showVideos is false
                  }
                  if (media is Conversation && !_showConversations) {
                    return false; // Hide videos if _showVideos is false
                  }
                  return true; // Show all other media
                }).toList();

                if (index >= displayedMedia.length) {
                  return SizedBox.shrink(); // Hide excess items
                }

                Media media = displayedMedia[index];
                // Check if media should be shown based on the favorited filter
                // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| FULL VIEW OF ITEM WHEN PRESSED |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
                                    // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| TITLE AND TIMESTAMP |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                                    Text('Title: ${media.title}',
                                        style: TextStyle(
                                            fontSize: _defaultFontSize)),
                                    Text(
                                        'Time Stamp: ${media.formatDateTime(media.timeStamp) ?? "N/A"}',
                                        style: TextStyle(
                                            fontSize: _defaultFontSize)),
                                    // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| IMAGE SHOWN IN FULL VIEW|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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

                                    if (media is Conversation)
                                      Icon(Icons.chat, size: 100),

                                    SizedBox(height: 16),

                                    // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ADDITIONAL INFO BELOW IMAGE|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
                  // HOME SCREEN GRID ALIGNMENT
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
                          // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| ICONS FOR GRID VIEW |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
                              if (media is Conversation)
                                Icon(Icons.chat, size: 50),
                              // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| TITLE FOR GRID OPTIONS |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
                              Text(
                                media.title,
                                style: TextStyle(fontSize: _fontSize),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| FAVORITE/TYPE ICONS FOR GRID VIEW |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
          // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| SLIDER BAR |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
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
