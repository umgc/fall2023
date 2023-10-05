import 'package:flutter/material.dart';
import 'package:chat_gpt_flutter/chat_gpt_flutter.dart';

// This is a AssistantScreen class.
// Page modification may be needed to link it with chatGPT.

class AssistantScreen extends StatefulWidget {
  @override
  _AssitantScreenState createState() => _AssitantScreenState();
}

class _AssitantScreenState extends State<AssistantScreen> {
  TextEditingController _messageController = TextEditingController();
  List<ChatMessage> _chatMessages = [];

  // Function to handle user messages
  void _handleUserMessage(String messageText) {
    // Create a user message
    ChatMessage userMessage = ChatMessage(
      messageText: messageText,
      isUserMessage: true,
    );

    // Add the user message to the chat
    setState(() {
      _chatMessages.add(userMessage);
    });

    // Send the user message to the AI assistant (ChatGPT) and get a response
    String aiResponse = getChatGPTResponse(messageText);

    // Create an AI message
    ChatMessage aiMessage = ChatMessage(
      messageText: aiResponse,
      isUserMessage: false,
    );

    // Add the AI message to the chat
    setState(() {
      _chatMessages.add(aiMessage);
    });

    // Clear the input field
    _messageController.clear();
  }

  // Function to simulate ChatGPT's response (Replace with actual API call)
  String getChatGPTResponse(String userMessage) {
    // Here, you can replace this with your code to communicate with ChatGPT
    // and get the AI assistant's response.
    // For a real implementation, you would make an API call to ChatGPT.
    // For simplicity, we'll just echo the user's message as the response.
    return 'AI Assistant: $userMessage (Echo)';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Assistant'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _chatMessages.length,
              itemBuilder: (context, index) {
                return _chatMessages[index];
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    String messageText = _messageController.text.trim();
                    if (messageText.isNotEmpty) {
                      _handleUserMessage(messageText);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String messageText;
  final bool isUserMessage;

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
