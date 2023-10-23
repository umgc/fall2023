import 'dart:io';

import 'package:cogniopenapp/ui/galleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks/image_mock_http_client.dart';

void main() {
  testWidgets('U-18-1: gallery screen loads correctly ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GalleryScreen(), //Gallery Scren
    ));

    //search icon
    final searchIcon = find.byKey(const Key('searchIcon'));
    expect(searchIcon, findsOneWidget);

    //favorites star
    final favoriteIcon = find.byKey(const Key('favoriteIcon'));
    expect(favoriteIcon, findsOneWidget);

    //photo filter icon
    final photoFilter =
        find.byKey(const Key('filterPhotoIcon'), skipOffstage: false);
    expect(photoFilter, findsOneWidget);

    //video filter icon
    final videoFilter =
        find.byKey(const Key('filterVideoIcon'), skipOffstage: false);
    expect(videoFilter, findsOneWidget);

    //conversation filter icon
    final conversationFilter =
        find.byKey(const Key('filterConversationIcon'), skipOffstage: false);
    expect(conversationFilter, findsOneWidget);

    //sort gallery menu item
    final sortGalleryButton =
        find.byKey(const Key('sortGalleryButton'), skipOffstage: false);
    expect(sortGalleryButton, findsOneWidget);

    //slider
    expect(find.byKey(const Key('gridSizeSlider'), skipOffstage: false),
        findsOneWidget);
  });
}
