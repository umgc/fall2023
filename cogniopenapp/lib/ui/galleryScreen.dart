import 'dart:io';

import 'package:aws_client/lex_models_v2_2020_08_07.dart';
import 'package:cogniopenapp/src/data_service.dart';
import 'package:cogniopenapp/src/database/model/audio.dart';
import 'package:cogniopenapp/src/database/model/media.dart';
import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:cogniopenapp/src/database/model/photo.dart';
import 'package:cogniopenapp/src/database/model/video.dart';
import 'package:cogniopenapp/src/utils/directory_manager.dart';
import 'package:cogniopenapp/src/utils/format_utils.dart';
import 'package:cogniopenapp/src/utils/ui_utils.dart';
import 'package:cogniopenapp/src/video_display.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:cogniopenapp/ui/assistantScreen.dart';
import 'package:flutter/material.dart';

// Define an enumeration for sorting criteria
enum SortingCriteria { storageSize, timeStamp, title, type }

// Define a StatefulWidget for the GalleryScreen
class GalleryScreen extends StatefulWidget {
  @override
  Widget build(BuildContext context) {
    // Scaffold widget for the Gallery screen
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery', style: TextStyle(color: Colors.black54)),
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
  List<Media> testMedia = DataService.instance.mediaList;

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

  FlutterSoundPlayer? _player;
  bool _isPlaying = false;

  late Audio activeAudio;

  _GalleryScreenState() {
    _populateMedia();
  }

  @override
  void initState() {
    super.initState();

    _player = FlutterSoundPlayer();
  }

  void _populateMedia() async {
    testMedia = DataService.instance.mediaList;
  }

  // Function to update font and icon size based on grid size
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

  // Function to toggle the sorting order
  void _toggleSortOrder() {
    setState(() {
      _isSortAscending = !_isSortAscending;
      _sortMediaItems();
    });
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

  // Toggles
  void _toggleSearchBarVisibility() {
    setState(() {
      _searchBarVisible = !_searchBarVisible;
    });
  }

  void _toggleShowFavorited() {
    setState(() {
      _showFavoritedOnly = !_showFavoritedOnly;
    });
  }

  void _toggleFavoriteStatus(Media media) async {
    //TODO: Update persistence
    //await DataService.instance
    //    .updateMediaIsFavorited(media, !media.isFavorited);
    setState(() {
      media.isFavorited = !media.isFavorited;
    });
  }

  void _onSearchTextChanged(String value) {
    setState(() {
      _searchText = value;
    });
  }

  void _updateCrossAxisCount(double value) {
    setState(() {
      _crossAxisCount = value;
    });
  }

  void _onSortingCriteriaSelected(SortingCriteria criteria) {
    setState(() {
      if (_selectedSortingCriteria == criteria) {
        _toggleSortOrder();
      } else {
        _selectedSortingCriteria = criteria;
        _isSortAscending = true;
        _sortMediaItems();
      }
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
            ? a.timestamp.compareTo(b.timestamp)
            : b.timestamp.compareTo(a.timestamp));
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

  // Function to get favorited photos
  List<Media> getFavoritedMedia() {
    return testMedia.where((media) => media.isFavorited).toList();
  }

  // Display names for sorting criteria
  final Map<SortingCriteria, String> sortingCriteriaNames = {
    SortingCriteria.storageSize: 'Sort by Storage Size',
    SortingCriteria.timeStamp: 'Sort by Time Stamp',
    SortingCriteria.title: 'Sort by Title',
    SortingCriteria.type: 'Sort by Type',
  };

  void displayFullObjectView(BuildContext context, Media media) async {
    var virtualAssistantIcon = Image.asset(
      'assets/icons/virtual_assistant.png',
      width: 25.0, // You can adjust the width and height
      height: 25.0, // as per your requirement
    );

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Full Screen Image and Details'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    final updatedMedia = await displayEditPopup(context, media);
                    if (updatedMedia != null) {
                      // Call a callback to update the parent view
                      Navigator.pop(context); // Close the current view
                      setState(() {
                        displayFullObjectView(context, updatedMedia);
                      });
                    }
                  },
                ),
              ],
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (media is Audio)
                      ElevatedButton.icon(
                        icon: virtualAssistantIcon,
                        label: const Text("Ask the Assistant"),
                        onPressed: () {
                          // String transcript = await getTranscriptPath(media
                          //     .timestamp.millisecondsSinceEpoch
                          //     .toString());
                          // print("transcript: $transcript");
                          // Send transcript to chatbot
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AssistantScreen(conversation: media)));
                          // "/files/audios/transcripts/${media.timestamp.millisecondsSinceEpoch.toString()}transcript.txt")));
                        },
                      ),
                    if (!media.title.isEmpty)
                      Text('Title: ${media.title}',
                          style: TextStyle(fontSize: _defaultFontSize)),
                    Text(
                        'Timestamp: ${FormatUtils.getDateString(media.timestamp)}',
                        style: TextStyle(fontSize: _defaultFontSize)),
                    if (media is Photo && media.photo != null)
                      Image(
                        image: media.photo!.image,
                      ),
                    if (media is Video && media.thumbnail != null)
                      //TODO: ADD VIDEO PLAYER HERE
                      videoDisplay(media),
                    if (media is Audio) Icon(Icons.chat, size: 100),
                    if (media is Audio) audioPlayer(media),
                    SizedBox(height: 16),
                    if (media.description != null && media.description != "")
                      Text(
                        'Description: ${media.description}',
                        style: TextStyle(fontSize: _defaultFontSize),
                        textAlign: TextAlign.center,
                      ),
                    if (media.tags != null &&
                        media.tags!.isNotEmpty &&
                        !media.tags!.every((tag) => tag.isEmpty))
                      Text('Tags: ${media.tags?.join(", ")}',
                          style: TextStyle(fontSize: _defaultFontSize)),
                    /* Text(
                      'Storage Size: ${FormatUtils.getStorageSizeString(media.storageSize)}',
                      style: TextStyle(fontSize: _defaultFontSize),
                    ), */
                    SizedBox(height: 25),
                    if (media is Audio)
                      Text('Summary: ${media.summary}',
                          style: TextStyle(fontSize: _defaultFontSize)),
                    SizedBox(height: 25),
                    if (media is Audio)
                      FutureBuilder<String>(
                        future: readFileAsString(media),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            // While the future is still running, you can show a loading indicator.
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            // If an error occurs, you can display an error message.
                            return Text('Error: ${snapshot.error}');
                          } else {
                            // If the future is complete, display the summary.
                            return Text('Transcript: ${snapshot.data}',
                                style: TextStyle(fontSize: _defaultFontSize));
                          }
                        },
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // TODO: MAKE THIS LOAD THE VIDEO
  VideoDisplay videoDisplay(Video video) {
    String fullFilePath =
        "${DirectoryManager.instance.videosDirectory.path}/${video.videoFileName}";
    print("THE PATH IS: ${fullFilePath}");
    return VideoDisplay(fullFilePath: fullFilePath);
  }

  Future<String> readFileAsString(Audio audio) async {
    String path =
        "${DirectoryManager.instance.transcriptsDirectory.path}/${activeAudio.transcriptFileName}";
    try {
      File file = File(path);
      String fileContent = await file.readAsString();
      print("TARNSRCIPT");
      print(fileContent);
      return fileContent;
    } catch (e) {
      print("Error reading the file: $e");
      return ""; // Handle the error as needed
    }
  }

  ElevatedButton audioPlayer(Audio audio) {
    activeAudio = audio;
    return ElevatedButton(
      onPressed: _isPlaying ? _stopPlayback : _startPlayback,
      child: Text(_isPlaying ? 'Stop Preview' : 'Play Preview'),
    );
  }

  /// Function to handle starting the playback of the recorded audio.
  Future<void> _startPlayback() async {
    String path =
        "${DirectoryManager.instance.audiosDirectory.path}/${activeAudio.audioFileName}";
    debugPrint(path);
    await _player!.openPlayer();
    await _player!.startPlayer(
        fromURI: path,
        whenFinished: () {
          setState(() {
            _isPlaying = false;
          });
          _player!.closePlayer();
        });
    setState(() {
      _isPlaying = true;
    });
  }

  /// Function to handle stopping the playback of the recorded audio.
  Future<void> _stopPlayback() async {
    await _player!.stopPlayer();
    setState(() {
      _isPlaying = false;
    });
    _player!.closePlayer();
  }

  Future<Media?> displayEditPopup(BuildContext context, Media media) async {
    TextEditingController titleController =
        TextEditingController(text: media.title);
    TextEditingController descriptionController =
        TextEditingController(text: media.description);
    TextEditingController tagsController =
        TextEditingController(text: media.tags?.join(', ') ?? '');

    return showDialog<Media>(
      context: context,
      builder: (BuildContext context) {
        Media? updatedMedia;
        return AlertDialog(
          title: Text('Edit Media'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  buildEditableField(titleController, 'Title', setState),
                  buildEditableField(
                      descriptionController, 'Description', setState),
                  buildEditableField(
                      tagsController, 'Tags (comma-separated)', setState),
                ],
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                List<String> tags = tagsController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .toList();
                // TODO: FIX (Note we should update the media using persistent storage then refresh the data)
                if (media is Photo) {
                  DataService.instance.updatePhoto(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags);

                  // TODO: Find a better way to refresh
                  updatedMedia = Photo(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      photoFileName: media.photoFileName,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags);
                } else if (media is Video) {
                  DataService.instance.updateVideo(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags);

                  // TODO: Find a better way to refresh
                  updatedMedia = Video(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      videoFileName: media.videoFileName,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags,
                      duration: media.duration,
                      thumbnailFileName: media.thumbnailFileName);
                } else if (media is Audio) {
                  DataService.instance.updateAudio(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags);

                  // TODO: Find a better way to refresh
                  updatedMedia = Audio(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      audioFileName: media.audioFileName,
                      title: titleController.text,
                      description: descriptionController.text,
                      tags: tags);
                }
                setState(() {});
                Navigator.of(context)
                    .pop(updatedMedia); // Return the updated media
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildEditableField(
    TextEditingController controller,
    String label,
    StateSetter setState,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      enabled: true,
      onChanged: (value) {
        setState(() {
          // You can add logic here if needed when the text changes.
        });
      },
    );
  }

  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| BUILD METHODS |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    _updateLayoutValues();

    return Scaffold(
        backgroundColor: const Color(0xFFB3E5FC),
        appBar: _buildAppBar(),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              if (_searchBarVisible) _buildSearchBar(),
              Expanded(
                child: _buildGridView(),
              ),
              _buildSliderBar(),
            ],
          ),
        ));
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0x440000),
      elevation: 0.0,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '', // Gallery view title
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 4),
        ],
      ),
      actions: [
        Row(
          children: [
            // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| SEARCH BAR |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            IconButton(
              key: const Key('searchIcon'),
              icon: Icon(Icons.search),
              onPressed: _toggleSearchBarVisibility,
            ),
            // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| FAVORITE/TYPE ICONS FOR GRID VIEW |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
            IconButton(
              key: const Key('favoriteIcon'),
              color: _showFavoritedOnly ? Colors.yellow : Colors.grey,
              icon: _showFavoritedOnly
                  ? Icon(Icons.star)
                  : Icon(Icons.star_border),
              onPressed: _toggleShowFavorited,
            ),
            IconButton(
              key: const Key('filterPhotoIcon'),
              icon: _showPhotos
                  ? const Icon(Icons.photo)
                  : const Icon(Icons.photo_outlined),
              color: _showPhotos ? Colors.white : Colors.grey,
              onPressed: _toggleShowPhotos,
            ),
            IconButton(
              key: const Key('filterVideoIcon'),
              color: _showVideos ? Colors.white : Colors.grey,
              icon: _showVideos
                  ? const Icon(Icons.videocam)
                  : const Icon(Icons.videocam_outlined),
              onPressed: _toggleShowVideos,
            ),
            IconButton(
              key: const Key('filterConversationIcon'),
              color: _showConversations ? Colors.white : Colors.grey,
              icon: _showConversations
                  ? const Icon(Icons.chat)
                  : const Icon(Icons.chat_outlined),
              onPressed: _toggleShowConversations,
            ),
          ],
        ),
        // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| POP UP MENU BAR |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
        PopupMenuButton<SortingCriteria>(
          key: const Key('sortGalleryButton'),
          itemBuilder: (BuildContext context) {
            return _buildSortingCriteriaMenuItems();
          },
          onSelected: _onSortingCriteriaSelected,
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        labelText: 'Search by Title',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: _onSearchTextChanged,
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount.toInt(),
      ),
      itemCount: _showFavoritedOnly
          ? getFavoritedMedia().length
          : filteredPhotos.length,
      itemBuilder: _buildGridItem,
    );
  }

  Widget _buildGridItem(BuildContext context, int index) {
    List<Media> displayedMedia = _filterDisplayedMedia();

    if (index >= displayedMedia.length) {
      return SizedBox.shrink();
    }

    Media media = displayedMedia[index];
    return GestureDetector(
      onTap: () {
        displayFullObjectView(context, media);
      },
      child: _buildGridItemContent(media),
    );
  }

  Widget _buildGridItemContent(Media media) {
    return Padding(
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
                if (media is Photo && media.photo != null)
                  _buildPhotoImage(media),
                if (media is Video && media.thumbnail != null)
                  _buildVideoImage(media),
                if (media is Audio) _buildConversationIcon(),
              ],
            ),
            _buildGridItemTitle(media.title),
            _buildFavoriteIcon(media),
            _buildMediaTypeIcon(media.mediaType),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoImage(Photo media) {
    return Expanded(
      child: Center(
        child: Image(
          key: const Key('photoItem'),
          image: media.photo!.image,
          width: 110.0,
          height: 115.0,
        ),
      ),
    );
  }

  Widget _buildVideoImage(Video media) {
    return Image(
      key: const Key('videoItem'),
      image: media.thumbnail!.image,
      // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| "ALGORITHM" FOR DETERMINING ICON/FONT SIZE IN GRID VIEW|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
      width: 110.0 + (2.0 - _crossAxisCount) * 25.0,
      height: 110.0 + (2.0 - _crossAxisCount) * 25.0,
    );
  }

  Widget _buildConversationIcon() {
    return const Icon(
      key: Key('conversationItem'),
      Icons.chat,
      size: 50,
    );
  }

  Widget _buildGridItemTitle(String title) {
    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
    Text(
      title,
      style: TextStyle(fontSize: _fontSize),
      textAlign: TextAlign.center,
    )
    ],);
  }

  List<Media> _filterDisplayedMedia() {
    return filteredPhotos.where((media) {
      if (_showFavoritedOnly && !media.isFavorited) {
        return false;
      }
      if (media is Photo && !_showPhotos) {
        return false;
      }
      if (media is Video && !_showVideos) {
        return false;
      }
      if (media is Audio && !_showConversations) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildFavoriteIcon(Media media) {
    return Positioned(
      top: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          _toggleFavoriteStatus(media);
        },
        child: Row(
          children: [
            Icon(
              media.isFavorited ? Icons.star : Icons.star_border,
              color: media.isFavorited ? Colors.yellow : Colors.grey,
              size: _iconSize,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaTypeIcon(MediaType mediaType) {
    return Positioned(
      top: 0,
      left: 0,
      child: Icon(
        UiUtils.getMediaIconData(mediaType),
        size: _iconSize,
      ),
    );
  }

  Widget _buildSliderBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Slider(
        value: _crossAxisCount,
        min: 1.0,
        max: 4.0,
        divisions: 3,
        onChanged: _updateCrossAxisCount,
        label: 'Grid Size',
      ),
    );
  }

  List<PopupMenuItem<SortingCriteria>> _buildSortingCriteriaMenuItems() {
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
                _isSortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                color: Colors.blue,
              ),
          ],
        ),
      );
    }).toList();
  }
}
