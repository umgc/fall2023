// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:cogniopenapp/ui/galleryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets(
      'Tests that the title and subtitle of the application displays after starting.',
      (WidgetTester tester) async {
    // Build our app and trigger a frrame.
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();

    // Verify that our counter starts at 0.
    expect(find.text('CogniOpen', skipOffstage: false), findsOneWidget);
    debugPrint("-------");
    final galleryButtonFinder2 =
        find.byKey(const Key("GalleryButtonKey"), skipOffstage: false);
    debugPrint("*******");
    debugPrint(galleryButtonFinder2.toString());
    debugPrint("*******");
    await tester.tap(galleryButtonFinder2);
    final iconButtonFinder = find.byType(IconButton, skipOffstage: false);
    debugPrint(iconButtonFinder.toString());
    debugPrint("________");

    //final elevatedButtonFinder =
    //  find.byType(ElevatedButton, skipOffstage: false);
    // debugPrint(elevatedButtonFinder.toString());
    //final galleryScreenFinder = find.byType(GalleryScreen, skipOffstage: false);
    // expect(galleryScreenFinder, findsOneWidget);
    debugPrint("*******");
    // debugPrint(galleryScreenFinder.toString());
    debugPrint("*******");

/*    expect(
        find.text(
            'Helping you remember the important thing\n Choose a feature from here to get started!'),
        findsOneWidget);*/
  });
}
