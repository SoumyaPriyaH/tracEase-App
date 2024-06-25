//
//
// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'distance_calculator.dart';
//
// class DistanceScreen extends StatefulWidget {
//   final String deviceName;
//   final String deviceAddress;
//
//   DistanceScreen({required this.deviceName, required this.deviceAddress});
//
//   @override
//   _DistanceScreenState createState() => _DistanceScreenState();
// }
//
// class _DistanceScreenState extends State<DistanceScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   double? distance;
//   bool isScanning = false;
//   StreamSubscription<List<ScanResult>>? scanSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     startContinuousScan();
//   }
//
//   void startContinuousScan() {
//     setState(() {
//       isScanning = true;
//     });
//
//     scanSubscription = flutterBlue.scanResults.listen((results) {
//       for (var result in results) {
//         if (result.device.id.id == widget.deviceAddress) {
//           final newDistance = DistanceCalculator.calculateDistance(result.rssi);
//           setState(() {
//             distance = newDistance;
//           });
//         }
//       }
//     }, onError: (error) {
//       print('Error during scan: $error');
//     });
//
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//   }
//
//   @override
//   void dispose() {
//     scanSubscription?.cancel();
//     flutterBlue.stopScan();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Distance from ${widget.deviceName}'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Device Name: ${widget.deviceName}', style: TextStyle(fontSize: 20)),
//             SizedBox(height: 10),
//             distance != null
//                 ? Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20))
//                 : CircularProgressIndicator(), // Show a loading indicator while distance is null
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'distance_calculator.dart';

class DistanceScreen extends StatefulWidget {
  final String deviceName;
  final String deviceAddress;

  DistanceScreen({required this.deviceName, required this.deviceAddress});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  double? distance;
  StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    startContinuousScan();
  }

  void startContinuousScan() {
    setState(() {
      distance = null;
    });

    scanSubscription = flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.id.id == widget.deviceAddress) {
          final newDistance = DistanceCalculator.calculateDistance(result.rssi);
          setState(() {
            distance = newDistance;
          });
        }
      }
    }, onError: (error) {
      print('Error during scan: $error');
    });

    flutterBlue.startScan(timeout: Duration(seconds: 4)).whenComplete(() {
      flutterBlue.stopScan();
    }).catchError((error) {
      print('Error starting scan: $error');
    });
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Distance from ${widget.deviceName}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Device Name: ${widget.deviceName}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            distance != null
                ? Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20))
                : CircularProgressIndicator(), // Show a loading indicator while distance is null
          ],
        ),
      ),
    );
  }
}
