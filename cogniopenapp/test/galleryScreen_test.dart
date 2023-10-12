import 'dart:io';

import 'package:cogniopenapp/ui/galleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/image_mock_http_client.dart';

void main() {
  setUp(() async {
    registerFallbackValue(Uri());

    //Load an image from assets and transform it from bytes to List<int>
    final _imageByteData =
        await rootBundle.load('assets/test_images/blank.png');
    final _imageIntList = _imageByteData.buffer.asInt8List();

    HttpOverrides.global = MockHttpOverrides({
      Uri.parse(
              'https://www.kasandbox.org/programming-images/avatars/spunky-sam.png'):
          _imageIntList,
      Uri.parse(
              'https://www.kasandbox.org/programming-images/avatars/spunky-sam-green.png'):
          _imageIntList,
      Uri.parse(
              'https://www.kasandbox.org/programming-images/avatars/purple-pi.png'):
          _imageIntList,
      Uri.parse(
              'https://www.kasandbox.org/programming-images/avatars/purple-pi-teal.png'):
          _imageIntList,
      Uri.parse(
              'https://www.kasandbox.org/programming-images/avatars/purple-pi-pink.png'):
          _imageIntList,
      Uri.parse('https://www.example.com/item1.jpg'): _imageIntList,
      Uri.parse('https://www.example.com/item2.jpg'): _imageIntList,
      Uri.parse(
              'https://cdn.fstoppers.com/styles/article_med/s3/media/2020/05/18/exploration_is_key_to_making_unique_landscape_photos_01.jpg'):
          _imageIntList,
    });
  });

  testWidgets(
      'when search icon is clicked, then search text field should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //no search Text Field on screen, when Gallery loads
    expect(find.byType(TextField), findsNothing);
    final searchIcon = find.byKey(const Key('searchIcon'));
    await tester.tap(searchIcon);
    await tester.pump();

    //search Text Field on screen when search icon is clicked
    expect(find.byType(TextField), findsOneWidget);

    //another click toggles it off again
    await tester.tap(searchIcon);
    await tester.pump();

    //search Text Field on screen when search icon is clicked
    expect(find.byType(TextField), findsNothing);
  });
}
