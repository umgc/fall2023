// Tests CogniOpen home screen

import 'package:cogniopenapp/ui/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets('Tests that the application home page loads correctly.', (WidgetTester tester) async {
    // Build our app and trigger a frrame.

    await tester.pumpWidget(MaterialApp(home: HomeScreen()));
    await tester.pumpAndSettle();
    await tester.pump();

    // Verify application's title
    expect(find.text('CogniOpen', skipOffstage: false), findsOneWidget);

    // Verify the task buttons are visible
    expect(find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Gallery", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Video Recording", skipOffstage: false), findsOneWidget);
    final audioRecordingButtonFinder = find.widgetWithText(ElevatedButton, "Audio Recording", skipOffstage: false);
    expect(audioRecordingButtonFinder, findsOneWidget);
    await tester.ensureVisible(audioRecordingButtonFinder);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, "Conversation History", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Significant Objects", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Tour Guide", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "My Gallery", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Settings", skipOffstage: false), findsOneWidget);
  });
}
