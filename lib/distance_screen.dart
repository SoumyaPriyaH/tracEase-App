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
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     // Start scanning
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//
//     // Listen to scan results
//     flutterBlue.scanResults.listen((results) {
//       for (var result in results) {
//         if (result.device.id.id == widget.deviceAddress) {
//           final newDistance = DistanceCalculator.calculateDistance(result.rssi);
//           setState(() {
//             distance = newDistance;
//           });
//         }
//       }
//     }, onDone: () {
//       print("Scan complete");
//       startScan(); // Restart the scan to keep updating the distance
//     }, onError: (error) {
//       print("Scan error: $error");
//     });
//   }
//
//   @override
//   void dispose() {
//     flutterBlue.stopScan();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Details'),
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
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'distance_calculator.dart';
import 'guage_pointer.dart'; // Import the custom painter

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

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    // Clear previous results
    distance = null;

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.id.id == widget.deviceAddress) {
          final newDistance = DistanceCalculator.calculateDistance(result.rssi);
          setState(() {
            distance = newDistance;
          });
        }
      }
    }, onDone: () {
      print("Scan complete");
      startScan(); // Restart the scan to keep updating the distance
    }, onError: (error) {
      print("Scan error: $error");
    });
  }

  @override
  void dispose() {
    flutterBlue.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Device Name: ${widget.deviceName}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            distance != null
                ? Column(
              children: [
                CustomPaint(
                  size: Size(200, 200),
                  painter: GaugePainter(distance: distance!),
                ),
                SizedBox(height: 10),
                Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20)),
              ],
            )
                : CircularProgressIndicator(), // Show a loading indicator while distance is null
          ],
        ),
      ),
    );
  }
}
