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
    return '$userMessage';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0x440000),
        elevation: 0,
        leading: const BackButton(
            color: Colors.black54
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.fromLTRB(20, 115, 20, 0),
                itemCount: _chatMessages.length,
                itemBuilder: (context, index) {
                  return _chatMessages[index];
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25.0,20,0,30),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                       filled: true,
                        contentPadding: EdgeInsets.fromLTRB(15, 5, 0, 5),
                        hintText: 'Ask Something...',

                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
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
      alignment: isUserMessage ? const Alignment(1.0,0.0) : const Alignment(-1.0,0.0),
      child: Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUserMessage ? Colors.red[300] : Colors.blue[300],
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey, //New
                blurRadius: 15,
                offset: Offset(0, 12))
          ],
        ),
        child: Text(
          messageText,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.5,
          ),
        ),
      ),
    );
  }
}
