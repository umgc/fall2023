import 'package:flutter/material.dart';

import 'package:cogniopenapp/src/media.dart';

class Photo extends Media {
  Image associatedImage;

  Photo(this.associatedImage, Media media) : super.copy(media) {
    iconType = Icon(
      Icons.photo,
      color: Colors.grey,
    );
  }
}
