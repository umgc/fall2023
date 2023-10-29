import 'package:flutter/material.dart';
import '../src/onboarding.dart';
import 'homeScreen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final Onboarding _functionality = Onboarding();

  @override
  void initState() {
    super.initState();
    _functionality.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x440000),
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0x440000), // Set appbar background color
        elevation: 0.0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black54),
        title: const Text('Onboarding', style: TextStyle(color: Colors.black54)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
          child: Container(
            padding: const EdgeInsets.only(top: 40.0),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: OnboardingUI(functionality: _functionality),
          ),
        ),
      ),
    );
  }
}

class OnboardingUI extends StatefulWidget {
  final Onboarding functionality;

  OnboardingUI({required this.functionality});

  @override
  _OnboardingUIState createState() => _OnboardingUIState();
}

class _OnboardingUIState extends State<OnboardingUI> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.functionality.controller,
      itemCount: widget.functionality.pages.length,
      itemBuilder: (BuildContext context, int index) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset('assets/icons/virtual_assistant.png'),
                Text(
                  index == 0 ? "Welcome to our App!" : "",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  index == 0
                      ? "Hello and welcome to CogniOpen! My name is Cora your Virtual Assistance. As a new user, I'll guide you through the onboarding process to get you started. Firstly, may I know your name please?"
                      : "",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 14),
                Container(
                  height: 200,
                  child: ConversationView(
                    conversation:
                        widget.functionality.pages[index].conversation,
                    scrollController: _scrollController,
                  ),
                ),
                SizedBox(height: 7),
                TextFormField(
                  controller: widget.functionality.userInputController,
                  decoration: InputDecoration(labelText: 'Your Response'),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        print(
                            "Before processing, current page: ${widget.functionality.currentPage}");

                        if (widget.functionality.currentPage ==
                            widget.functionality.pages.length - 1) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          widget.functionality.handleUserInput(context);
                          widget.functionality.nextPage(context);
                          setState(() {});
                        }

                        print(
                            "After processing, current page: ${widget.functionality.currentPage}");
                      },
                      child: Text("Next"),

                    ),
                    SizedBox(height: 10),

                    FloatingActionButton(
                      onPressed: widget.functionality.startListening,
                      mini: true,
                      child: widget.functionality.isListening
                          ? Icon(Icons.mic_off)
                          : Icon(Icons.mic),
                      backgroundColor: widget.functionality.isListening
                          ? Colors.red
                          : Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ConversationView extends StatelessWidget {
  final List<ConversationBubble> conversation;
  final ScrollController scrollController;

  ConversationView(
      {required this.conversation, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      itemCount: conversation.length,
      itemBuilder: (context, index) {
        final bubble = conversation[index];
        return ListTile(
          title: Text(
            bubble.text,
            style: TextStyle(
              color: bubble.isUser ? Colors.blue : Colors.black,
            ),
          ),
          trailing: bubble.isUser ? Icon(Icons.person) : null,
        );
      },
    );
  }
}

class NextOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Next Onboarding Page")),
      body: Center(child: Text("Welcome to the next onboarding page!")),
    );
  }
}
