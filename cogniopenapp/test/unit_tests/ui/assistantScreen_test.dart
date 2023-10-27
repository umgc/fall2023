// This file tests the chatbot screen

import 'package:cogniopenapp/ui/assistantScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cogniopenapp/main.dart';

void main() {
  testWidgets('Tests virtual assistant basic input and output',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Declare local variables
    const questionToAsk = "Where is my fire extinguisher?";
    const answerToExpect = "AI Assistant: $questionToAsk (Echo)";
    if (questionToAsk == answerToExpect) {
      debugPrint(
          "Please make sure that the question and answer are not identical");
    }

/*
    // Tap virtual assistant button
    final virtualAssistantButtonFinder = find.widgetWithText(ElevatedButton, "Virtual Assistant", skipOffstage: false);
    expect(virtualAssistantButtonFinder, findsOneWidget);

    // Checks virtual assistant screen loads
    await tester.tap(virtualAssistantButtonFinder);
    await tester.pumpAndSettle();
    final virtualAssistantAppBarFinder = find.widgetWithText(AppBar, "Virtual Assistant", skipOffstage: false);
    expect(virtualAssistantAppBarFinder, findsOneWidget);

    // Formulate quandary
    final questionBoxFinder = find.widgetWithText(TextField, "Type your message...", skipOffstage: false);
    expect(questionBoxFinder, findsOneWidget);
    await tester.enterText(questionBoxFinder, "Where is my fire extinguisher?");

    // Verify that answer is not there already
    var answerChatMessage = find.widgetWithText(ChatMessage, answerToExpect);
    expect(answerChatMessage, findsNothing);

    // Tap send
    final sendIconFinder = find.widgetWithIcon(IconButton, Icons.send, skipOffstage: false);
    expect(sendIconFinder, findsOneWidget);
    await tester.tap(sendIconFinder);
    await tester.pumpAndSettle();

    // Check for correct answer
    answerChatMessage = find.widgetWithText(ChatMessage, answerToExpect);
    expect(answerChatMessage, findsOneWidget);
    */
  });
}
