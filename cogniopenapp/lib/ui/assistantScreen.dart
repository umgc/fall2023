import 'dart:async';

import 'package:cogniopenapp/src/typingIndicator.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';

// This is a AssistantScreen class.

class AssistantScreen extends StatefulWidget {
  @override
  _AssitantScreenState createState() => _AssitantScreenState();
}

class _AssitantScreenState extends State<AssistantScreen> {
  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> _chatMessages = [];
  late Future<bool> goodAPIKey;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    goodAPIKey = loadAPIKey();
  }

  // Add user messages to chat list then query ChatGPT API and add its
  // response to chat list
  Future<void> _handleUserMessage(String messageText, bool display) async {
    if (display) {
      // Create a user message
      ChatMessage userMessage = ChatMessage(
        messageText: messageText,
        isUserMessage: true,
      );

      // Add the user message to the chat
      setState(() {
        _chatMessages.add(userMessage);
      });
    }

    _scrollDown();

    // Clear the input field
    _messageController.clear();

    // Send the user message to the AI assistant (ChatGPT) and get a response
    String aiResponse = await getChatGPTResponse(messageText);

    // Create an AI message
    ChatMessage aiMessage = ChatMessage(
      messageText: aiResponse,
      isUserMessage: false,
    );

    // Add the AI message to the chat
    setState(() {
      _chatMessages.add(aiMessage);
    });

    _scrollDown();
  }

// Scroll to the bottom of the chat list with delay to make sure newest message is rendered
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  // Send user Message to ChatGPT 3.5 Turbo and return response
  Future<String> getChatGPTResponse(String userMessage) async {
    // when testing UI, set to true to avoid API calls
    bool debugSampleText = false;

    // TODO: remove this before sending to production
    if (debugSampleText) {
      await Future.delayed(const Duration(seconds: 5));
      return "AI Assistant: Sample response message.";
    }

    setState(() {
      _isTyping = true;
    });

    String response;
    try {
      OpenAIChatCompletionModel chatCompletion =
          await OpenAI.instance.chat.create(
        model: "gpt-3.5-turbo",
        messages: [
          OpenAIChatCompletionChoiceMessageModel(
            content: userMessage,
            role: OpenAIChatMessageRole.user,
          ),
        ],
      );

      final content = chatCompletion.choices[0].message.content;

      response = 'AI Assistant: $content';
    } on RequestFailedException catch (e) {
      _showAlert("API Request Error", e.message);
      response = "";
    } on Exception catch (e) {
      _showAlert("Unknown Error", e.toString());
      response = "";
    }

    setState(() {
      _isTyping = false;
    });

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: goodAPIKey, //Lock text input if API key is not found
        initialData: false,
        builder: (BuildContext context, AsyncSnapshot<bool> isLoad) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Virtual Assistant'),
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _chatMessages.length,
                    itemBuilder: (context, index) {
                      return _chatMessages[index];
                    },
                  ),
                ),
                if (_isTyping) TypingIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          enabled: isLoad.data, //Disable input without API key
                          controller: _messageController,
                          decoration: const InputDecoration(
                            hintText: 'Type your message...',
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          String messageText = _messageController.text.trim();
                          if (messageText.isNotEmpty) {
                            _handleUserMessage(messageText, true);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future<bool> loadAPIKey() async {
    // Load function will throw an error if cogniopenapp/.env is missing or empty
    // make sure this file holds your api key in the format "OPEN_AI_API_KEY=<key>"
    // Also, make sure not to share your API key or push it to Git
    await dotenv.load(fileName: ".env");
    String apiKeyEnv = dotenv.get('OPEN_AI_API_KEY', fallback: "");
    if (apiKeyEnv.isEmpty) {
      _showAlert("API Key Error",
          "OpenAI API Key must be set to use the Virtual Assistant.");
      return false;
    } else {
      //TODO: API key sould be stored in the database, not env file
      OpenAI.apiKey = apiKeyEnv;
      print("Welcome user here");
      _handleUserMessage("Welcome John and offer to help him.", false);
      return true;
    }
  }

// Display alert when API key is empty
  FutureOr _showAlert(String title, String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(message),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}

class ChatMessage extends StatelessWidget {
  final String messageText;
  final bool isUserMessage;

// TODO: add text to speech button for AI messages

  ChatMessage({
    required this.messageText,
    required this.isUserMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUserMessage ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.all(8.0),
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Text(
          messageText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
