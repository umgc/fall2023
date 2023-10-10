// Tests CogniOpen home screen

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets('Tests that the application home page loads correctly.', (WidgetTester tester) async {
    // Build our app and trigger a frrame.
    await tester.pumpWidget(MyApp());
    await tester.pumpAndSettle();
    await tester.pump();

    // Verify that our counter starts at 0.
    expect(find.text('CogniOpen', skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Gallery", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Video Recording", skipOffstage: false), findsOneWidget);
    final audioRecordingButtonFinder = find.widgetWithText(ElevatedButton, "Audio Recording", skipOffstage: false);
    expect(audioRecordingButtonFinder, findsOneWidget);
    await tester.ensureVisible(audioRecordingButtonFinder);
    await tester.pumpAndSettle();
    expect(find.widgetWithText(ElevatedButton, "Search", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Recent Requests", skipOffstage: false), findsOneWidget);
  });
}
