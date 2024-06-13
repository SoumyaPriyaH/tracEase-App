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
      backgroundColor: Colors.white, //backgroundColor: const Color(0xFFE9FFDB),
      body: Center(
        child: SizedBox(
          width: 200, // specify the desired width
          height: 200, // specify the desired height
          child: Image.asset("assets/images/logo2.jpg", fit: BoxFit.contain),
        ),
      ),
    );
  }
}
