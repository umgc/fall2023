// Tests CogniOpen home screen

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets('Tests that the audio screen functions.', (WidgetTester tester) async {
    // Build our app and trigger a frrame.
    await tester.pumpWidget(MyApp());

    // Open the audio recording screen
    final audioRecordingButtonFinder = find.widgetWithText(ElevatedButton, "Audio Recording", skipOffstage: false);
    expect(audioRecordingButtonFinder, findsOneWidget);
    await tester.ensureVisible(audioRecordingButtonFinder);
    await tester.pumpAndSettle();
    await tester.tap(audioRecordingButtonFinder);
    await tester.pump();

    // Verify there is no stop button visible
    final stopIconInitialFinder = find.byIcon(Icons.stop, skipOffstage: false);
    expect(stopIconInitialFinder, findsNothing);

    //Tap the mic button to start recording
    final micIconInitialFinder = find.byIcon(Icons.mic, skipOffstage: false);
    expect(micIconInitialFinder, findsOneWidget);
    final audioRecordingTextButton = find.widgetWithText(TextButton, "Press to Start Audio Recording", skipOffstage: false);
    expect(audioRecordingTextButton, findsOneWidget);
    await tester.ensureVisible(audioRecordingTextButton);
    await tester.pumpAndSettle();
    await tester.tap(audioRecordingTextButton);
    await tester.pump();

    /*
    // Verify the icons changed after tapping record
    final micIconSubsequentFinder = find.byIcon(Icons.mic, skipOffstage: false);
    expect(micIconSubsequentFinder, findsNothing);
    final stopIconSubsequentFinder = find.byIcon(Icons.stop, skipOffstage: false);
    expect(stopIconSubsequentFinder, findsOneWidget);

    // Verify tapping stop icon displays three choices: Preview, Save, and Cancel
    await tester.tap(audioRecordingTextButton);
    await tester.pump();
    final playPreviewButtonFinder = find.widgetWithText(ElevatedButton, "Play Preview", skipOffstage: false);
    expect(playPreviewButtonFinder, findsOneWidget);
    final saveButtonFinder = find.widgetWithText(ElevatedButton, "Save", skipOffstage: false);
    expect(saveButtonFinder, findsOneWidget);
    final cancelButtonFinder = find.widgetWithText(ElevatedButton, "Cancel", skipOffstage: false);
    expect(cancelButtonFinder, findsOneWidget);
    */
  });
}
