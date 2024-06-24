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
//       body: Container(
//         color: Colors.blueGrey, // Set the background color to blue-grey
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text('Device Name: ${widget.deviceName}', style: TextStyle(fontSize: 20, color: Colors.white)),
//               SizedBox(height: 10),
//               distance != null
//                   ? Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20, color: Colors.white))
//                   : CircularProgressIndicator(), // Show a loading indicator while distance is null
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//





//22/6/24
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'distance_calculator.dart';

class DistanceScreen extends StatefulWidget {
  final BluetoothDevice device;

  DistanceScreen({required this.device});

  @override
  _DistanceScreenState createState() => _DistanceScreenState();
}

class _DistanceScreenState extends State<DistanceScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  double? distance;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    discoverServices();
  }

  void discoverServices() async {
    List<BluetoothService> services = await widget.device.discoverServices();
    for (var service in services) {
      for (var char in service.characteristics) {
        if (char.properties.write) {
          setState(() {
            characteristic = char;
          });
        }
      }
    }
  }

  void sendData(String data) async {
    if (characteristic != null) {
      await characteristic!.write(data.codeUnits);
    }
  }

  void startScan() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));
    flutterBlue.scanResults.listen((results) {
      for (var result in results) {
        if (result.device.id.id == widget.device.id.id) {
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
      body: Container(
        color: Colors.blueGrey, // Set the background color to blue-grey
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Device Name: ${widget.device.name}', style: TextStyle(fontSize: 20, color: Colors.white)),
              SizedBox(height: 10),
              distance != null
                  ? Text('Distance: ${distance!.toStringAsFixed(2)} meters', style: TextStyle(fontSize: 20, color: Colors.white))
                  : CircularProgressIndicator(), // Show a loading indicator while distance is null
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => sendData('1'), // Turn on the LED
                child: Text('Turn On'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => sendData('0'), // Turn off the LED
                child: Text('Turn Off'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
