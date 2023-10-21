import 'package:cogniopenapp/src/database/model/media_type.dart';

import 'media.dart';

// PLaceholder for testing
class Conversation extends Media {
  String summary;
  MediaType mediaType = MediaType.audio;

  Conversation(this.summary, Media media) : super.copy(media);
}
