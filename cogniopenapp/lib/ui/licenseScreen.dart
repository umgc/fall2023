import 'package:flutter/material.dart';
import 'homeScreen.dart';

class LicenseScreen extends StatefulWidget {
  @override
  MyLicenseScreen createState() => MyLicenseScreen();
}

class MyLicenseScreen extends State<LicenseScreen> {
  bool _isVisible = true;
  String licensepath = 'assets/images/tour_1.jpg';

  @override
  Widget build(BuildContext context){
    return Scaffold(

      extendBodyBehindAppBar: true,
      extendBody: true,

      appBar: AppBar(
        backgroundColor: const Color(0x440000),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),

            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                       child: Image.asset('assets/images/license_agreement.png', scale: 1.95,),

                              ),
                      Row(
                        children: [
                          Visibility(
                            visible: _isVisible,

                            child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 45, 30, 0),
                            child: MyElevatedButton(

                              onPressed: () {
                                // Navigate to Gallery screen

                                setState (() {
                                  _isVisible = false;
                                });
                              },

                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height:
                                    8.0, // Add some spacing between the image and text
                                  ),
                                  Text(
                                    'Decline', // This is the subheading text
                                    style: TextStyle(
                                      fontSize: 18.0, // Adjust font size as needed
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ),
                          Container(
                            margin: const EdgeInsets.fromLTRB(30, 45, 0, 0),
                            child: MyElevatedButton(

                              onPressed: () {
                                // Navigate to Gallery screen
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomeScreen()));
                              },


                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height:
                                    8.0, // Add some spacing between the image and text
                                  ),
                                  Text(
                                    'Accept', // This is the subheading text
                                    style: TextStyle(
                                      fontSize: 18.0, // Adjust font size as needed
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),




                                ]
                              )
                          ],
                      )
                  ]
            )
      ),
    );
  }
}

class MyElevatedButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final Gradient gradient;
  final VoidCallback? onPressed;
  final Widget child;

  const MyElevatedButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 44.0,
    this.gradient = const LinearGradient(colors: [Colors.black, Colors.black45]),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final borderRadius = this.borderRadius ?? BorderRadius.circular(25);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        child: child,
      ),
    );
  }
}

