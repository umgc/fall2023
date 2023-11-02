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
import 'package:flutter_sound/flutter_sound.dart';
import 'package:cogniopenapp/ui/assistantScreen.dart';
import 'package:flutter/material.dart';
import 'package:cogniopenapp/src/video_display.dart';

// Define an enumeration for sorting criteria
enum SortingCriteria { storageSize, timeStamp, title, type }

// Default font size, icon size, and other layout values
double _crossAxisCount = 2.0; // Default options for grid columns
double _fontSize = 16.0;
double _iconSize = 40.0;
double _sizedBoxSpacing = 8;
final double _defaultFontSize = 20.0;

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

  bool _searchBarVisible = false;
  String _searchText = '';

  // Variables used to toggle what is being viewed
  bool _showFavoritedOnly = false;
  bool _showPhotos = true;
  bool _showVideos = true;
  bool _showConversations = true;

  // Variables used for sorting
  SortingCriteria? _selectedSortingCriteria;
  bool _isSortAscending = true;

  _GalleryScreenState() {
    _populateMedia();
  }

  @override
  void initState() {
    super.initState();
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

  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| BUILD METHODS |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  //||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
  @override
  Widget build(BuildContext context) {
    _updateLayoutValues();

    return Scaffold(
        backgroundColor: const Color(0xFFB3E5FC),
        extendBodyBehindAppBar: true,
        extendBody: true,
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
      iconTheme: IconThemeData(
        color: Colors.black54, //change your color here
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
              color: Colors.black54,
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
              color: _showPhotos ? Colors.blueAccent : Colors.grey,
              onPressed: _toggleShowPhotos,
            ),
            IconButton(
              key: const Key('filterVideoIcon'),
              color: _showVideos ? Colors.blueAccent : Colors.grey,
              icon: _showVideos
                  ? const Icon(Icons.videocam)
                  : const Icon(Icons.videocam_outlined),
              onPressed: _toggleShowVideos,
            ),
            IconButton(
              key: const Key('filterConversationIcon'),
              color: _showConversations ? Colors.blueAccent : Colors.grey,
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullObjectView(media),
          ),
        );
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
            _buildFavoriteIcon(media),
            _buildGridItemTitle(media.title),
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
          fit: BoxFit.fill,
          width: double.infinity,
          height: double.infinity
        ),
      ),
    ); 
  }

  Widget _buildVideoImage(Video media) {
    return Image(
      key: const Key('videoItem'),
      image: media.thumbnail!.image,
      // ||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| "ALGORITHM" FOR DETERMINING ICON/FONT SIZE IN GRID VIEW|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
      //width: 110.0 + (2.0 - _crossAxisCount) * 25.0,
      //height: 110.0 + (2.0 - _crossAxisCount) * 25.0,
      fit: BoxFit.fill,
      width: double.infinity,
      height: double.infinity
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.end, children: [
    Text(
      title,
      style: TextStyle(fontSize: _fontSize),
      textAlign: TextAlign.center,
    )
    ]
    );
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

//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||| FULL OBJECT WIDGET |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||(widget and item creation)||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
//||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||

class FullObjectView extends StatefulWidget {
  Media activeMedia;

  FullObjectView(this.activeMedia);

  @override
  _FullObjectViewState createState() => _FullObjectViewState();
}

class _FullObjectViewState extends State<FullObjectView> {
  FlutterSoundPlayer? _player;
  bool _isPlaying = false;

  late Audio activeAudio;

  @override
  void initState() {
    super.initState();
    _player = FlutterSoundPlayer();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen height
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor:
          Colors.transparent, // Make the Scaffold's background transparent
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor:
            Colors.transparent, // Make the AppBar's background transparent
        elevation: 0.0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black54),
        title: const Text('Full Screen Image and Details',
            style: TextStyle(color: Colors.black54)),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedMedia =
                  await displayEditPopup(context, widget.activeMedia);
              if (updatedMedia != null) {
                Navigator.pop(context); // Close the current view
                setState(() {
                  //displayFullObjectView(context, updatedMedia);
                });
              }
            },
          ),
        ],
      ),
      body: Container(
        height:
            screenHeight, // Set the height of the Container to the screen height
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
                    ), // Used to provide an invisible barrier for the objects

                    SizedBox(
                      height: 8,
                    ),
                    if (!widget.activeMedia.title.isEmpty)
                      returnTextBox("Title", '${widget.activeMedia.title}'),
                    SizedBox(
                      height: 8,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    returnTextBox("Timestamp",
                        '${FormatUtils.getDateString(widget.activeMedia.timestamp)}'),
                    addSpacingSizedBox(),
                    if (widget.activeMedia is Audio)
                      createAudioControlButtons(),
                    addSpacingSizedBox(),
                    if (widget.activeMedia is Photo &&
                        (widget.activeMedia as Photo).photo != null)
                      Image(
                        image: (widget.activeMedia as Photo).photo!.image,
                      ),
                    if (widget.activeMedia is Video &&
                        (widget.activeMedia as Video).thumbnail != null)
                      videoDisplay(widget.activeMedia as Video),
                    addSpacingSizedBox(),
                    if (widget.activeMedia.description != null &&
                        widget.activeMedia.description != "")
                      returnTextBox(
                          "Description", '${widget.activeMedia.description}'),

                    addSpacingSizedBox(),

                    if (widget.activeMedia is Audio)
                      returnTextBox("Summary",
                          '${(widget.activeMedia as Audio).summary}'),

                    addSpacingSizedBox(),
                    if (widget.activeMedia is Audio)
                      FutureBuilder<String>(
                        future: readFileAsString(widget.activeMedia as Audio),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return returnTextBox(
                                "Transcription", '${snapshot.data}');
                          }
                        },
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

  Column createAudioPlayer() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 3),
              )
            ],
          ),
          child: audioPlayer(widget.activeMedia as Audio),
        ),
      ],
    );
  }

  SizedBox addSpacingSizedBox() {
    return SizedBox(
      height: 8,
    );
  }

  ElevatedButton coraButton() {
    var virtualAssistantIcon = Image.asset(
      'assets/icons/virtual_assistant.png',
      width: 25.0,
      height: 25.0,
    );
    return ElevatedButton.icon(
      icon: virtualAssistantIcon,
      label: const Text("Ask Cora"),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AssistantScreen(conversation: widget.activeMedia as Audio),
          ),
        );
      },
    );
  }

  Container createAudioControlButtons() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: createBoxDecoration(),
              child: coraButton(),
            ),
          ),
          SizedBox(width: 16), // Add space between the children
          Expanded(
            child: Container(
              decoration: createBoxDecoration(),
              child: audioPlayer(widget.activeMedia as Audio),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration createBoxDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
      border: Border.all(
        color: Colors.black,
        width: 2.0,
      ),
    );
  }

  Container returnTextBox(String title, String contents) {
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
            height: _sizedBoxSpacing,
          ),
          Text(
            contents,
            style: TextStyle(fontSize: _defaultFontSize),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<Media?> displayEditPopup(BuildContext context, Media media) async {
    TextEditingController titleController =
        TextEditingController(text: media.title);
    TextEditingController descriptionController =
        TextEditingController(text: media.description);

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
                if (media is Photo) {
                  DataService.instance.updatePhoto(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text);

                  // TODO: Find a better way to refresh
                  updatedMedia = Photo(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      photoFileName: media.photoFileName,
                      title: titleController.text,
                      description: descriptionController.text);
                } else if (media is Video) {
                  DataService.instance.updateVideo(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text);

                  // TODO: Find a better way to refresh
                  updatedMedia = Video(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      videoFileName: media.videoFileName,
                      title: titleController.text,
                      description: descriptionController.text,
                      duration: media.duration,
                      thumbnailFileName: media.thumbnailFileName);
                } else if (media is Audio) {
                  DataService.instance.updateAudio(
                      id: media.id!,
                      title: titleController.text,
                      description: descriptionController.text);

                  // TODO: Find a better way to refresh
                  updatedMedia = Audio(
                      timestamp: media.timestamp,
                      storageSize: media.storageSize,
                      isFavorited: false,
                      audioFileName: media.audioFileName,
                      title: titleController.text,
                      description: descriptionController.text);
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

  Future<String> readFileAsString(Audio audio) async {
    String path =
        "${DirectoryManager.instance.transcriptsDirectory.path}/${activeAudio.transcriptFileName}";
    try {
      File file = File(path);
      String fileContent = await file.readAsString();
      print("TRANSCRIPT");
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
      child: Text(_isPlaying ? 'Stop Audio' : 'Play Audio'),
    );
  }

  VideoDisplay videoDisplay(Video video) {
    String fullFilePath =
        "${DirectoryManager.instance.videosDirectory.path}/${video.videoFileName}";
    print("THE PATH IS: ${fullFilePath}");
    return VideoDisplay(fullFilePath: fullFilePath);
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
}
