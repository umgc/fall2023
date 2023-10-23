import 'dart:io';

import 'package:cogniopenapp/ui/galleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/image_mock_http_client.dart';

void main() {
  /*
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

  /*testWidgets(
      'when favorite icon is clicked, then favorited items should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //7 items in grid when Gallery loads
    final gridFinder = find.byType(GridView);
    expect(gridFinder, findsOneWidget);
    final gridInitial = tester.widget<GridView>(gridFinder);
    expect(gridInitial.childrenDelegate.estimatedChildCount, 7);

    //push favorites icon - toggle on favorites
    final favoriteIcon = find.byKey(const Key('favoriteIcon'));
    await tester.tap(favoriteIcon);
    await tester.pumpAndSettle();

    //only 3 items left on screen
    final gridAfter = tester.widget<GridView>(gridFinder);
    expect(gridAfter.childrenDelegate.estimatedChildCount, 3);

    //push favorites icon - toggle off favorites
    await tester.tap(favoriteIcon);
    await tester.pumpAndSettle();

    //7 items left on screen again
    final gridFinal = tester.widget<GridView>(gridFinder);
    expect(gridFinal.childrenDelegate.estimatedChildCount, 7);
  });*/
/*
  testWidgets(
      'when photo filter icon is clicked, then only photo items should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    final photoItemsFinder =
        find.byKey(const Key('photoItem'), skipOffstage: false);

    await tester.ensureVisible(photoItemsFinder.first);
    await tester.pumpAndSettle();

    expect(photoItemsFinder, findsNWidgets(5));

    //click photo filter icon, remove photos
    final photoFilter =
        find.byKey(const Key('filterPhotoIcon'), skipOffstage: false);

    await tester.tap(photoFilter);
    await tester.pumpAndSettle();

    expect(photoItemsFinder, findsNothing);

    //toggle back on
    await tester.tap(photoFilter);
    await tester.pumpAndSettle();

    expect(photoItemsFinder, findsNWidgets(5));
  });
  */
/*
  testWidgets(
      'when video filter icon is clicked, then only video items should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //find videoItem widget
    final videoItemsFinder =
        find.byKey(const Key('videoItem'), skipOffstage: false);
    //find vertical scrollbar
    final scrollView =
        find.byType(PrimaryScrollController, skipOffstage: false).first;
    //drag until videoitem is visible
    await tester.dragUntilVisible(
        videoItemsFinder, scrollView, Offset(0, -500));

    expect(videoItemsFinder, findsNWidgets(1));

    //click video filter icon, remove videos
    final videoFilter =
        find.byKey(const Key('filterVideoIcon'), skipOffstage: false);

    await tester.tap(videoFilter);
    await tester.pumpAndSettle();

    expect(videoItemsFinder, findsNothing);

    //toggle back on
    await tester.tap(videoFilter);
    await tester.pumpAndSettle();

    expect(videoItemsFinder, findsNWidgets(1));
  });
*/
/*
  testWidgets(
      'when conversation filter icon is clicked, then only conversation items should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //find conversationItem widget
    final conversationItemsFinder =
        find.byKey(const Key('conversationItem'), skipOffstage: false);
    //find vertical scrollbar
    final scrollView =
        find.byType(PrimaryScrollController, skipOffstage: false).first;
    //drag until conversationitem is visible
    await tester.dragUntilVisible(
        conversationItemsFinder, scrollView, Offset(0, -500));

    expect(conversationItemsFinder, findsNWidgets(1));

    //click conversation filter icon, remove conversation
    final conversationFilter =
        find.byKey(const Key('filterConversationIcon'), skipOffstage: false);

    await tester.tap(conversationFilter);
    await tester.pumpAndSettle();

    expect(conversationItemsFinder, findsNothing);

    //toggle back on
    await tester.tap(conversationFilter);
    await tester.pumpAndSettle();

    expect(conversationItemsFinder, findsNWidgets(1));
  });
*/

  testWidgets(
      'when menu icon is clicked, then sort menu should appear/disappear ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //tap sort button to bring up menu
    final sortGalleryButton =
        find.byKey(const Key('sortGalleryButton'), skipOffstage: false);

    //find center of button, to ensure our tap doesnt miss
    //this got rid of "warn if miss" warnings in the test output
    await tester.tapAt(tester.getCenter(sortGalleryButton));
    await tester.pump();

    //menu is visible on screen
    expect(find.text('Sort by Storage Size'), findsOneWidget);
    expect(find.text('Sort by Time Stamp'), findsOneWidget);
    expect(find.text('Sort by Title'), findsOneWidget);
    expect(find.text('Sort by Type'), findsOneWidget);

    //another click toggles it off again
    await tester.tapAt(tester.getCenter(sortGalleryButton));
    await tester.pump();

    expect(find.text('Sort by Storage Size'), findsNothing);
    expect(find.text('Sort by Time Stamp'), findsNothing);
    expect(find.text('Sort by Title'), findsNothing);
    expect(find.text('Sort by Type'), findsNothing);
  });
/*
  testWidgets('when photo item is clicked, then photo item should be expanded ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    final photoItem = find.byKey(const Key('photoItem'));
    await tester.tapAt(tester.getCenter(photoItem.first));
    await tester.pumpAndSettle();

    //check text visible on screen
    expect(find.text('Title: Spunky Sam'), findsOneWidget);
    expect(find.text('Description: Avatar of Spunky Sam'), findsOneWidget);
    expect(find.text('Tags: avatar, spunky'), findsOneWidget);
    expect(find.text('Storage Size: 1.00 KB'), findsOneWidget);
    expect(find.text('Full Screen Image and Details'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
*/
/*
  testWidgets('when video item is clicked, then video item should be expanded ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //find videoItem widget
    final videoItemsFinder =
        find.byKey(const Key('videoItem'), skipOffstage: false);
    //find vertical scrollbar
    final scrollView =
        find.byType(PrimaryScrollController, skipOffstage: false).first;
    //drag until videoitem is visible
    await tester.dragUntilVisible(
        videoItemsFinder, scrollView, Offset(0, -500));

    await tester.tapAt(tester.getCenter(videoItemsFinder));
    await tester.pumpAndSettle();

    //check text visible on screen
    expect(find.text('Title: Test Video'), findsOneWidget);
    expect(find.text('Description: This is a placeholder for a video'),
        findsOneWidget);
    expect(find.text('Tags: video, test'), findsOneWidget);
    expect(find.text('Storage Size: 4.00 KB'), findsOneWidget);
    expect(find.text('Full Screen Image and Details'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
  */
  /*

  testWidgets(
      'when conversation item is clicked, then conversation item should be expanded ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //find videoItem widget
    final conversationItemsFinder =
        find.byKey(const Key('conversationItem'), skipOffstage: false);
    //find vertical scrollbar
    final scrollView =
        find.byType(PrimaryScrollController, skipOffstage: false).first;
    //drag until videoitem is visible
    await tester.dragUntilVisible(
        conversationItemsFinder, scrollView, Offset(0, -900));

    await tester.tapAt(tester.getCenter(conversationItemsFinder));
    await tester.pumpAndSettle();

    //check text visible on screen
    expect(find.text('Title: Conversation'), findsOneWidget);
    expect(find.text('Description: This is a sample conversation'),
        findsOneWidget);
    expect(find.text('Time Stamp: October 5th, 2023'), findsOneWidget);
    expect(find.text('Tags: sample, conversation'), findsOneWidget);
    expect(find.text('Storage Size: 2.00 KB'), findsOneWidget);
    expect(find.text('Full Screen Image and Details'), findsOneWidget);
  });
  */
   */
//TODO: add in tests for sorting, https://dev.azure.com/ProjectCogniOpen/CogniOpen/_workitems/edit/322
}
