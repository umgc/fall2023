import 'package:flutter/material.dart';
//import 'package:cogniopen/chatbotscreen.dart';

import 'assistantScreen.dart';
import 'audioScreen.dart';
import 'customizableScreen.dart';
import 'galleryScreen.dart';
import 'helpScreen.dart';
import 'profileScreen.dart';
import 'recentScreen.dart';
import 'searchScreen.dart';
import 'videoScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF880E4F), // Set background color
      appBar: AppBar(
        backgroundColor: const Color(0XFFE91E63), // Set appbar background color
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/app_icon.png', // Replace this with your icon's path
              fit: BoxFit.contain,
              height: 32, // Adjust the size as needed
            ),
            const SizedBox(width: 10), // Spacing between the icon and title
            const Text('CogniOpen', textAlign: TextAlign.center),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu, // Hamburger icon
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate back to the previous screen
              Navigator.pop(context);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
            ),
            ListTile(
              title: const Text('Help Center'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HelpCenterScreen()));
              },
            ),
            ListTile(
              title: const Text('Customizable Application'),
              onTap: () {
                Navigator.pop(context); // Close the drawer
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => CustomScreen()));
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                // Handle logout logic (e.g., clear user session and navigate to login screen)
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
                16.0, 16.0, 16.0, 4.0), // Adjust padding as needed
            child: Text(
              'Welcome!', // This is the header text
              style: TextStyle(
                fontSize: 24.0, // Adjust font size as needed
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Padding(
            // New subheading section starts here
            padding: EdgeInsets.fromLTRB(
                16.0, 4.0, 16.0, 4.0), // Adjust padding as needed
            child: Text(
              'Helping you remember the important thing\n Choose a feature from here to get started!', // This is the subheading text
              style: TextStyle(
                fontSize: 16.0, // Adjust font size as needed
                color:
                    Colors.white70, // Slightly transparent white for subheading
              ),
              textAlign: TextAlign.center,
            ),
          ), // New subheading section ends here
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Two columns
              crossAxisSpacing: 16.0, // Spacing between columns
              mainAxisSpacing: 16.0, // Spacing between rows
              padding: const EdgeInsets.all(16.0),
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Chat bot/Virtual Assistant screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatbotScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/chatbot.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Virtual Assistant'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Gallery screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GalleryScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/gallery.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Gallery'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Video Screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => VideoScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/video.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Video Recording'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Audio Recording screen
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AudioScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/audio.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Audio Recording'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Search screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/search.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Search'),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to Recent Questions/Requests screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RecentScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor:
                        const Color(0XFFC6FF00), // Button text color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Square border
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/icons/recentrequest.png',
                        width: 75.0, // You can adjust the width and height
                        height: 75.0, // as per your requirement
                      ),
                      const SizedBox(
                        height:
                            8.0, // Add some spacing between the image and text
                      ),
                      const Text('Recent Requests'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0XFFE91E63),
        // Set the BottomNavigationBar background color
        items: const [
          BottomNavigationBarItem(
            backgroundColor: Color(0XFFE91E63),
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chatbot',
          ),
        ],
        onTap: (int index) {
          // Handle navigation bar item taps
          if (index == 0) {
            // Stay on the Home Interface Screen
          } else if (index == 1) {
            // Navigate to Search screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SearchScreen()));
          } else if (index == 2) {
            // Navigate to Gallery screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GalleryScreen()));
          } else if (index == 3) {
            // Navigate to Chatbot screen
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatbotScreen()));
          }
        },
      ),
    );
  }
}

class HelpCenterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center Screen'),
      ),
      // Implement the Help Center screen UI here
    );
  }
}

class CustomScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customizable Application Screen'),
      ),
      // Implement the Customizable Application screen UI here
    );
  }
}
// This is a chatbotScreen class.
// Page modification may be needed to link it with chatGPT.

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
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

class AudioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Recording'),
      ),
      // Implement the Audio Recording screen UI here
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      // Implement the Search screen UI here
    );
  }
}
