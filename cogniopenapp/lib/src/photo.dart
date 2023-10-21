import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:flutter/material.dart';
import 'media.dart';

class Photo extends Media {
  Image associatedImage;
  MediaType mediaType = MediaType.video;

  Photo(this.associatedImage, Media media) : super.copy(media);
}
