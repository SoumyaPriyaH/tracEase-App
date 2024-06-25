//
//
//
// import 'dart:async';
// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'distance_calculator.dart';
//
// class DistanceScreen extends StatefulWidget {
//   final BluetoothDevice device;
//   final BluetoothConnection connection;
//
//   DistanceScreen({required this.device, required this.connection});
//
//   @override
//   _DistanceScreenState createState() => _DistanceScreenState();
// }
//
// class _DistanceScreenState extends State<DistanceScreen> {
//   double? distance;
//
//   @override
//   void initState() {
//     super.initState();
//     startListening();
//   }
//
//   void startListening() {
//     widget.connection.input?.listen((Uint8List data) {
//       // Handle incoming data if needed
//       // Example: print("Data received: ${utf8.decode(data)}");
//     }).onDone(() {
//       print("Disconnected remotely");
//       setState(() {
//         // Handle disconnection here
//       });
//     });
//   }
//
//   void sendData(String data) async {
//     try {
//       widget.connection.output.add(utf8.encode(data));
//       await widget.connection.output.allSent;
//     } catch (e) {
//       print("Error sending data: $e");
//       // Handle error as needed
//     }
//   }
//
//   @override
//   void dispose() {
//     widget.connection.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Details'),
//       ),
//       body: Container(
//         color: Colors.blueGrey, // Set the background color to blue-grey
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Device Name: ${widget.device.name}', style: TextStyle(fontSize: 20, color: Colors.white)),
//               SizedBox(height: 10),
//               distance != null
//                   ? Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20, color: Colors.white))
//                   : CircularProgressIndicator(), // Show a loading indicator while distance is null
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () => sendData('1'), // Turn on the LED
//                 child: Text('Turn On'),
//               ),
//               SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: () => sendData('2'), // Turn off the LED
//                 child: Text('Turn Off'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//


import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class DistanceScreen extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothConnection connection;

  DistanceScreen({required this.device, required this.connection});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  @override
  void initState() {
    super.initState();
    startListening();
  }

  void startListening() {
    widget.connection.input?.listen((Uint8List data) {
      // Handle incoming data if needed
      // Example: print("Data received: ${utf8.decode(data)}");
    }).onDone(() {
      print("Disconnected remotely");
      setState(() {
        // Handle disconnection here
      });
    });
  }

  void sendData(String data) async {
    try {
      widget.connection.output.add(utf8.encode(data));
      await widget.connection.output.allSent;
    } catch (e) {
      print("Error sending data: $e");
      // Handle error as needed
    }
  }

  @override
  void dispose() {
    widget.connection.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
      ),
      body: Container(
        color: Colors.blueGrey, // Set the background color to blue-grey
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Device Name: ${widget.device.name}', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => sendData('1'), // Turn on the buzzer
                child: Text('Turn On'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => sendData('2'), // Turn off the buzzer
                child: Text('Turn Off'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
