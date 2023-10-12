// Tests CogniOpen home screen

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets('Tests that the application home page loads correctly.', (WidgetTester tester) async {
    // Build our app and trigger a frrame.
    await tester.pumpWidget(MyApp());

    // Check that the title is displayed
    expect(find.text('CogniOpen', skipOffstage: false), findsOneWidget);

    // Check all the buttons are visible
    expect(find.widgetWithText(ElevatedButton, "Record", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Conversation History", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Significant Objects", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Tour Guide", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "My Gallery", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Settings", skipOffstage: false), findsOneWidget);
  });
}
