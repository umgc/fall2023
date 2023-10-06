import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color(0x440000),
        elevation: 0,
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
        )
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
