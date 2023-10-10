import 'package:cogniopenapp/src/media.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/src/photo.dart';

void main() {
  Photo photo = createTestMediaList()[0] as Photo;

  //test code here!
  test("create a photo", () {
    expect(photo.associatedImage, isNot(null));
  });
}
