import 'dart:async';

import 'package:cogniopenapp/src/typingIndicator.dart';
import 'package:dart_openai/dart_openai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// This is a AssistantScreen class.

class AssistantScreen extends StatefulWidget {
  @override
  _AssitantScreenState createState() => _AssitantScreenState();
}

class _AssitantScreenState extends State<AssistantScreen> {
  late FlutterTts tts;
  bool isPlaying = false;

  TextEditingController _messageController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
  List<ChatMessage> _chatMessages = [];
  late Future<bool> goodAPIKey;
  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    goodAPIKey = loadAPIKey();
    initTTS();
  }

  @override
  void dispose() {
    super.dispose();
    tts.stop();
  }

  void initTTS() {
    tts = FlutterTts();

    tts.setStartHandler(() {
      setState(() {
        print("Playing");
        isPlaying = true;
      });
    });

    tts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        isPlaying = false;
      });
    });

    tts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        isPlaying = false;
      });
    });
  }

// Play or stop text to speech
  void toggleTTS(String text) async {
    if (isPlaying) {
      await tts.stop();
    } else {
      await tts.speak(text);
    }
  }

  // Add user messages to chat list then query ChatGPT API and add its
  // response to chat list
  Future<void> _handleUserMessage(String messageText, bool display) async {
    if (display) {
      // Create a user message
      ChatMessage userMessage = ChatMessage(
        messageText: messageText,
        isUserMessage: true,
        toggleTTS: (chatText) => toggleTTS(chatText),
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
      toggleTTS: (chatText) => toggleTTS(chatText),
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
      await Future.delayed(const Duration(seconds: 3));
      return "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.";
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
  final Function toggleTTS;
  final String messageText;
  final bool isUserMessage;

  ChatMessage({
    required this.messageText,
    required this.isUserMessage,
    required this.toggleTTS,
  });

  @override
  Widget build(BuildContext context) {
    var chatbotIcon = Image.asset(
      'assets/icons/chatbot.png',
      width: 25.0, // You can adjust the width and height
      height: 25.0, // as per your requirement
    );
    IconButton speakerButton = IconButton(
      icon: const Icon(IconData(0xe6c5, fontFamily: 'MaterialIcons')),
      onPressed: () {
        toggleTTS(messageText);
      },
    );
    const TextStyle messageStyle = TextStyle(
      color: Colors.white,
      fontSize: 16.0,
    );
    const TextStyle titleStyle = TextStyle(
      color: Color.fromRGBO(223, 223, 223, 1.0),
      fontSize: 16.0,
    );

    return Align(
      alignment: isUserMessage ? Alignment.topRight : Alignment.topLeft,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.blue : Colors.blueGrey,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: FractionallySizedBox(
          widthFactor: 0.85,
          child: ListTile(
            textColor: Colors.white,
            leading: isUserMessage ? null : chatbotIcon,
            minLeadingWidth: 25,
            title: Text(
              isUserMessage ? "User:" : "Virtual Assistant:",
              style: titleStyle,
            ),
            subtitle: Text(
              messageText,
              style: messageStyle,
            ),
            trailing: isUserMessage ? null : speakerButton,
            horizontalTitleGap: 16,
            minVerticalPadding: 16,
          ),
        ),
      ),
    );
  }
}
