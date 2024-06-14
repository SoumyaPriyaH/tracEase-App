import 'package:flutter/material.dart';
import 'dart:async';
import 'bluetoothcheck_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BluetoothCheckScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color for the entire screen
      body: Stack(
        fit: StackFit.expand, // Make the stack fill the entire screen
        children: [
          // Background image
          Image.asset(
            "assets/images/background2.png", // Replace with your full-size background image path
            fit: BoxFit.cover, // Cover the entire stack area
          ),
          // Centered logo (if needed)
          // Center(
          //   child: SizedBox(
          //     width: 200, // specify the desired width
          //     height: 200, // specify the desired height
          //     child: Image.asset("assets/images/logo2.jpg", fit: BoxFit.contain),
          //   ),
          // ),
        ],
      ),
    );
  }
}
