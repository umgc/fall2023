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

    // Check that the title is displayed
    expect(find.text('CogniOpen', skipOffstage: false), findsOneWidget);

    // Check all the buttons are visible
    final recordButtonFinder = find.widgetWithText(ElevatedButton, "Record", skipOffstage: false);
    expect(recordButtonFinder, findsOneWidget);

    // It breaks the build unless button is forcibly put in view
    await tester.ensureVisible(recordButtonFinder);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(ElevatedButton, "Conversation History", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Significant Objects", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Tour Guide", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "My Gallery", skipOffstage: false), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Settings", skipOffstage: false), findsOneWidget);
  });
}
