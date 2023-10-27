// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/ui/settingsScreen.dart';

void main() {
  testWidgets('Tests settings screen has all options', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: SettingsScreen()));

    // Check for three options
    final passiveAudioTextFinder = find.text("Passive Audio Recording", skipOffstage: false);
    expect(passiveAudioTextFinder, findsOneWidget);
    final passiveVideoTextFinder = find.text("Passive Video Recording", skipOffstage: false);
    expect(passiveVideoTextFinder, findsOneWidget);
    final locationServicesTextFinder = find.text("Location Services", skipOffstage: false);
    expect(locationServicesTextFinder, findsOneWidget);
  });
}
