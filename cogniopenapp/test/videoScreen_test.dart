// Tests CogniOpen home screen

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/ui/videoScreen.dart';

void main() {
  testWidgets('W-3: video screen loads correctly ',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: VideoScreen(), //Video Screen
    ));

    //Camera text
    expect(find.text('Camera'), findsOneWidget);

    //camera icon
    final cameraIcon = find.byIcon(Icons.camera_alt);
    expect(cameraIcon, findsOneWidget);

    //video icon
    expect(find.byIcon(Icons.videocam), findsOneWidget);

    //pause icon
    expect(find.byIcon(Icons.pause), findsOneWidget);

    //stop icon
    expect(find.byIcon(Icons.stop), findsOneWidget);
  });
}
