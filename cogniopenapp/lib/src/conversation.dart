import 'package:flutter/material.dart';

import 'package:cogniopenapp/src/media.dart';

// PLaceholder for testing
class Conversation extends Media {
  String summary;

  Conversation(this.summary, Media media) : super.copy(media) {
    iconType = Icon(
      Icons.chat,
      color: Colors.grey,
    );
  }
}
