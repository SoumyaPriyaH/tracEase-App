// // import 'package:flutter/material.dart';
// // import 'package:flutter_blue/flutter_blue.dart';
// //
// //
// // class ScanResultsScreen extends StatefulWidget {
// //   @override
// //   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// // }
// //
// // class _ScanResultsScreenState extends State<ScanResultsScreen> {
// //   FlutterBlue flutterBlue = FlutterBlue.instance;
// //   List<ScanResult> scanResults = [];
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     startScan();
// //   }
// //
// //   void startScan() {
// //     flutterBlue.startScan(timeout: Duration(seconds: 4)).listen((scanResult) {
// //       setState(() {
// //         scanResults.add(scanResult);
// //       });
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Scanned Bluetooth Devices'),
// //       ),
// //       body: ListView.builder(
// //         itemCount: scanResults.length,
// //         itemBuilder: (context, index) {
// //           final device = scanResults[index].device;
// //           return ListTile(
// //             title: Text(device.name.isNotEmpty ? device.name : "Unknown Device"),
// //             subtitle: Text(device.id.id),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class ScanResultsScreen extends StatefulWidget {
//   @override
//   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// }
//
// class _ScanResultsScreenState extends State<ScanResultsScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     // Clear previous results
//     scanResults.clear();
//
//     // Start scanning
//     flutterBlue.startScan(timeout: Duration(seconds: 4));
//
//     // Listen to scan results
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//     }, onDone: () {
//       print("Scan complete");
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
//         title: Text('Scanned Bluetooth Devices'),
//       ),
//       body: ListView.builder(
//         itemCount: scanResults.length,
//         itemBuilder: (context, index) {
//           final device = scanResults[index].device;
//           return ListTile(
//             title: Text(device.name.isNotEmpty ? device.name : "Unknown Device"),
//             subtitle: Text(device.id.id),
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'distance_screen.dart'; // Import the distance screen

class ScanResultsScreen extends StatefulWidget {
  @override
  _ScanResultsScreenState createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    // Clear previous results
    scanResults.clear();

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
    }, onDone: () {
      print("Scan complete");
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
        title: Text('Scanned Bluetooth Devices'),
      ),
      body: ListView.builder(
        itemCount: scanResults.length,
        itemBuilder: (context, index) {
          final device = scanResults[index].device;
          final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
          final deviceAddress = device.id.id;

          return ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DistanceScreen(
                    deviceName: deviceName,
                    deviceAddress: deviceAddress,
                  ),
                ),
              );
            },
            child: Text('$deviceName\n$deviceAddress'),
          );
        },
      ),
    );
  }
}
