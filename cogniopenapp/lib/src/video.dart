import 'package:flutter/material.dart';
import 'media.dart';
import 'package:video_player/video_player.dart';

class Video extends Media {
  String duration;
  late bool autoDelete; // This is a comment
  late List<IdentifiedItem> identifiedItems;
  late Image thumbnail;

  // Constructor using initializing formals: https://dart.dev/tools/linter-rules/prefer_initializing_formals
  Video(this.duration, this.autoDelete, this.identifiedItems, this.thumbnail,
      Media media, {required VideoDisplay home})
      : super.copy(media) {
    iconType = const Icon(
      Icons.video_camera_back,
      color: Colors.grey,
    );
  }
}

// Removed the photo class, and changed the int time spotted to date time (can just go off of recent dates)
class IdentifiedItem {
  final String _itemName;
  final DateTime _timeSpotted;
  final Image _itemImage;

  IdentifiedItem(this._itemName, this._timeSpotted, this._itemImage);

  // Getter for itemName
  String get itemName => _itemName;

  // Getter for timeSpotted
  DateTime get timeSpotted => _timeSpotted;

  // Getter for itemImage
  Image get itemImage => _itemImage;
}



class VideoDisplay extends StatefulWidget {
  const VideoDisplay({super.key});

  @override
  State<VideoDisplay> createState() =>  _VideoDisplayState();
}

class  _VideoDisplayState extends State<VideoDisplay> {
  late VideoPlayerController _controller;
  late Future<void> _video;

@override 
void initState() {
  super.initState();
  _controller = VideoPlayerController.networkUrl(Uri.parse(
    'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4'),
    );
    _video = _controller.initialize();
}

@override
void dispose() {
_controller.dispose();

super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _video,
        builder: (context,snapshot)
      {
          if(snapshot.connectionState==ConnectionState.done)
          {
            return AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller)
              );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_controller.value.isPlaying)
          {
            setState(() {
              _controller.pause();
            });
          } else {
            setState(() {
              _controller.play();
            });
          }
        },
        child: Icon(_controller.value.isPlaying?Icons.pause:Icons.play_arrow),
      ),
    );
  }
}