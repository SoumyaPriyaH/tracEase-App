import 'package:flutter/material.dart';
import 'ble_controller.dart';


class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanResultsScreen()),
            );
          },
          child: Text('Find Bluetooth Devices'),
        ),
      ),
    );
  }
}
