//showing device names
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'distance_screen.dart';
//
// class ScanDevicesScreen extends StatefulWidget {
//   @override
//   _ScanDevicesScreenState createState() => _ScanDevicesScreenState();
// }
//
// class _ScanDevicesScreenState extends State<ScanDevicesScreen> {
//   FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDiscoveryResult> scanResults = [];
//   bool isScanning = false;
//   StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   void requestPermissions() async {
//     await Permission.bluetooth.request();
//     await Permission.location.request();
//
//     if (await Permission.bluetooth.isGranted && await Permission.location.isGranted) {
//       startScan();
//     } else {
//       print("Permissions not granted");
//     }
//   }
//
//   void startScan() {
//     setState(() {
//       scanResults.clear();
//       isScanning = true;
//     });
//
//     _discoveryStreamSubscription = bluetooth.startDiscovery().listen((result) {
//       setState(() {
//         scanResults.add(result);
//       });
//       print("Device found: ${result.device.name ?? 'Unknown Device'}, ID: ${result.device.address}");
//     }, onDone: () {
//       print("Scan complete");
//       setState(() {
//         isScanning = false;
//       });
//     }, onError: (error) {
//       print("Scan error: $error");
//       setState(() {
//         isScanning = false;
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     _discoveryStreamSubscription?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scan Bluetooth Devices'),
//       ),
//       body: Container(
//         color: Colors.blueGrey,
//         child: Column(
//           children: [
//             if (isScanning)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(),
//               ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scanResults.length,
//                 itemBuilder: (context, index) {
//                   final device = scanResults[index].device;
//                   final deviceName = device.name ?? "Unknown Device";
//                   final deviceAddress = device.address;
//
//                   return ListTile(
//                     title: Text(deviceName),
//                     subtitle: Text(deviceAddress),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DistanceScreen(
//                             deviceName: deviceName,
//                             deviceAddress: deviceAddress,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'distance_screen.dart';

class ScanDevicesScreen extends StatefulWidget {
  @override
  _ScanDevicesScreenState createState() => _ScanDevicesScreenState();
}

class _ScanDevicesScreenState extends State<ScanDevicesScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  bool isScanning = false;
  StreamSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    startScan();
  }

  void startScan() {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    flutterBlue.startScan(timeout: Duration(seconds: 10)).then((_) {
      scanSubscription = flutterBlue.scanResults.listen((results) {
        setState(() {
          scanResults = results;
        });
      });
    }).whenComplete(() {
      setState(() {
        isScanning = false;
      });
    }).catchError((error) {
      print('Error starting scan: $error');
      setState(() {
        isScanning = false;
      });
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
        title: Text('Scan Bluetooth Devices'),
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Column(
          children: [
            if (isScanning)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: scanResults.length,
                itemBuilder: (context, index) {
                  final device = scanResults[index].device;
                  final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
                  final deviceAddress = device.id.id;

                  return ListTile(
                    title: Text(deviceName),
                    subtitle: Text(deviceAddress),
                    onTap: () {
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}







//successs, nnot showing device names
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'distance_screen.dart';
//
// class ScanDevicesScreen extends StatefulWidget {
//   @override
//   _ScanDevicesScreenState createState() => _ScanDevicesScreenState();
// }
//
// class _ScanDevicesScreenState extends State<ScanDevicesScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   bool isScanning = false;
//   StreamSubscription? scanSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     setState(() {
//       scanResults.clear();
//       isScanning = true;
//     });
//
//     scanSubscription = flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//     }, onError: (error) {
//       print('Error during scan: $error');
//       setState(() {
//         isScanning = false;
//       });
//     });
//
//     flutterBlue.startScan(timeout: Duration(seconds: 20)).then((_) {
//       setState(() {
//         isScanning = false;
//       });
//     }).catchError((error) {
//       print('Error starting scan: $error');
//       setState(() {
//         isScanning = false;
//       });
//     });
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
//         title: Text('Scan Bluetooth Devices'),
//       ),
//       body: Container(
//         color: Colors.blueGrey,
//         child: Column(
//           children: [
//             if (isScanning)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CircularProgressIndicator(),
//               ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scanResults.length,
//                 itemBuilder: (context, index) {
//                   final device = scanResults[index].device;
//                   final deviceName = device.name ?? "Unknown Device";
//                   final deviceAddress = device.id.id;
//
//                   return ListTile(
//                     title: Text(deviceName),
//                     subtitle: Text(deviceAddress),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => DistanceScreen(
//                             deviceName: deviceName,
//                             deviceAddress: deviceAddress,
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
