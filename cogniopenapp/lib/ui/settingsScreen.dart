import 'package:flutter/material.dart';
import 'homeScreen.dart';
import 'galleryScreen.dart';
import 'assistantScreen.dart';
import 'searchScreen.dart';


class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
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

        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                  margin: const EdgeInsets.only(top: 225.0),
                  child: Row(
                    children: [
                      Image.asset('assets/icons/mic_on.png',
                        width: 75.0, // You can adjust the width and height
                      ),
                      const Text("Passive Audio Recording", textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      const SwitchExample(),
                    ],
                  )
              ),
              Container(
                  child: Row(
                    children: [
                      Image.asset('assets/icons/camera_on.png',
                        width: 75.0, // You can adjust the width and height

                      ),
                      const Text("Passive Video Recording", textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),

                      const SwitchExample(),
                    ],
                  )
                  ),
              Container(

                  child: Row(
                    children: [
                      Image.asset('assets/icons/location_on.png',
                        width: 75.0, // You can adjust the width and height
                      ),
                      const Text("Location Services", textAlign: TextAlign.left,
                          style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      const SwitchExample(),
                    ],
                  )
              ),
            ],
          ),
        ),

        ),
      bottomNavigationBar: BottomNavigationBar(
      elevation: 0.0,

      items: const [
        BottomNavigationBarItem(
          backgroundColor: Color(0x00ffffff),

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
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HomeScreen()));
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
              MaterialPageRoute(builder: (context) => AssistantScreen()));
        }
      },
    ),


    );
  }
}

class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light = true;

  @override
  Widget build(BuildContext context) {
    return Switch(
      // This bool value toggles the switch.
      value: light,
      activeColor: Colors.blue,
      onChanged: (bool value) {
        // This is called when the user toggles the switch.
        setState(() {
          light = value;
        });
      },
    );
  }
}