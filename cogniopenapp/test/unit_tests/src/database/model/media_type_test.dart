import 'package:cogniopenapp/src/database/model/media_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MediaType', () {

    // MediaType enum tests:

    test('MediaType.audio should have the correct String and name values', () {
      expect(MediaType.audio.toString(), 'MediaType.audio');
      expect(MediaType.audio.name, 'audio');
    });

    test('MediaType.photo should have the correct String and name values', () {
      expect(MediaType.photo.toString(), 'MediaType.photo');
      expect(MediaType.photo.name, 'photo');
    });

    test('MediaType.video should have the correct String and name values', () {
      expect(MediaType.video.toString(), 'MediaType.video');
      expect(MediaType.video.name, 'video');
    });
  });
}
