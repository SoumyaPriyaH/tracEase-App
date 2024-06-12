import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'dart:io' show Platform;
import 'homescreen.dart';

class BluetoothCheckScreen extends StatefulWidget {
  @override
  _BluetoothCheckScreenState createState() => _BluetoothCheckScreenState();
}

class _BluetoothCheckScreenState extends State<BluetoothCheckScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
  }

  void _checkBluetoothState() async {
    var state = await flutterBlue.state.first;
    if (state == BluetoothState.off) {
      _showBluetoothDialog();
    } else {
      _navigateToHomeScreen();
    }
  }

  void _showBluetoothDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enable Bluetooth'),
          content: Text('Please enable Bluetooth to use this app.'),
          actions: <Widget>[
            TextButton(
              child: Text('Open Settings'),
              onPressed: () async {
                Navigator.of(context).pop();
                if (Platform.isAndroid) {
                  final intent = AndroidIntent(
                    action: 'android.settings.BLUETOOTH_SETTINGS',
                  );
                  await intent.launch();
                } else if (Platform.isIOS) {
                  await openAppSettings();
                }

                // Wait for a short period to give the user time to enable Bluetooth
                Future.delayed(Duration(seconds: 5), () {
                  _checkBluetoothState(); // Re-check the Bluetooth state
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
