//sucess
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'track_item.dart';
//
// class ScanResultsScreen extends StatefulWidget {
//   @override
//   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// }
//
// class _ScanResultsScreenState extends State<ScanResultsScreen> {
//   FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
//   List<BluetoothDiscoveryResult> scanResults = [];
//   String searchQuery = "";
//   bool isSearching = false;
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
//     // Clear previous results
//     setState(() {
//       scanResults.clear();
//       isScanning = true;
//     });
//
//     // Start scanning
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
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     try {
//       BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => DistanceScreen(
//             device: device,
//             connection: connection,
//           ),
//         ),
//       );
//     } catch (e) {
//       print("Error connecting to device: $e");
//     }
//   }
//
//   List<BluetoothDiscoveryResult> get filteredScanResults {
//     if (searchQuery.isEmpty) {
//       return scanResults;
//     } else {
//       return scanResults
//           .where((result) =>
//       (result.device.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
//           result.device.address.contains(searchQuery))
//           .toList();
//     }
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
//         title: !isSearching
//             ? Text('Scanned Bluetooth Devices')
//             : TextField(
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'Search for a device',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.blueGrey),
//           ),
//           style: TextStyle(color: Colors.black),
//           onChanged: (query) {
//             setState(() {
//               searchQuery = query;
//             });
//           },
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 isSearching = !isSearching;
//                 if (!isSearching) {
//                   searchQuery = "";
//                 }
//               });
//             },
//           ),
//         ],
//         backgroundColor: Colors.white10,
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
//                 itemCount: filteredScanResults.length,
//                 itemBuilder: (context, index) {
//                   final device = filteredScanResults[index].device;
//                   final deviceName = device.name ?? "Unknown Device";
//                   final deviceAddress = device.address;
//
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 8.0),
//                     child: Align(
//                       alignment: Alignment.center,
//                       child: SizedBox(
//                         width: 2.5 * 130,
//                         child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                             padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12.0),
//                             ),
//                             elevation: 3.0,
//                           ),
//                           onPressed: () => connectToDevice(device),
//                           child: Text(
//                             '$deviceName\n$deviceAddress',
//                             textAlign: TextAlign.center,
//                             style: TextStyle(fontSize: 14.0),
//                           ),
//                         ),
//                       ),
//                     ),
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
// void main() {
//   runApp(MaterialApp(
//     home: ScanResultsScreen(),
//   ));
// }
//
//

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart';
import 'track_item.dart';

class ScanResultsScreen extends StatefulWidget {
  @override
  _ScanResultsScreenState createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  FlutterBluetoothSerial bluetooth = FlutterBluetoothSerial.instance;
  List<BluetoothDiscoveryResult> scanResults = [];
  String searchQuery = "";
  bool isSearching = false;
  bool isScanning = false;
  StreamSubscription<BluetoothDiscoveryResult>? _discoveryStreamSubscription;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.location.request();

    if (await Permission.bluetooth.isGranted && await Permission.location.isGranted) {
      startScan();
    } else {
      print("Permissions not granted");
    }
  }

  void startScan() {
    setState(() {
      scanResults.clear();
      isScanning = true;
    });

    _discoveryStreamSubscription = bluetooth.startDiscovery().listen((result) {
      setState(() {
        scanResults.add(result);
      });
      print("Device found: ${result.device.name ?? 'Unknown Device'}, ID: ${result.device.address}");
    }, onDone: () {
      print("Scan complete");
      setState(() {
        isScanning = false;
      });
    }, onError: (error) {
      print("Scan error: $error");
      setState(() {
        isScanning = false;
      });
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(device.address);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connected to ${device.name ?? "Unknown Device"}')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DistanceScreen(
            device: device,
            connection: connection,
          ),
        ),
      ).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Disconnected from ${device.name ?? "Unknown Device"}')),
        );
      });
    } catch (e) {
      print("Error connecting to device: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error connecting to ${device.name ?? "Unknown Device"}')),
      );
    }
  }

  List<BluetoothDiscoveryResult> get filteredScanResults {
    if (searchQuery.isEmpty) {
      return scanResults;
    } else {
      return scanResults.where((result) =>
      (result.device.name?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          result.device.address.contains(searchQuery)).toList();
    }
  }

  @override
  void dispose() {
    _discoveryStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !isSearching
            ? Text('Scanned Bluetooth Devices')
            : TextField(
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Search for a device',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.blueGrey),
          ),
          style: TextStyle(color: Colors.black),
          onChanged: (query) {
            setState(() {
              searchQuery = query;
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchQuery = "";
                }
              });
            },
          ),
        ],
        backgroundColor: Colors.white10,
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
                itemCount: filteredScanResults.length,
                itemBuilder: (context, index) {
                  final device = filteredScanResults[index].device;
                  final deviceName = device.name ?? "Unknown Device";
                  final deviceAddress = device.address;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 2.5 * 130,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            elevation: 3.0,
                          ),
                          onPressed: () => connectToDevice(device),
                          child: Text(
                            '$deviceName\n$deviceAddress',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14.0),
                          ),
                        ),
                      ),
                    ),
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

void main() {
  runApp(MaterialApp(
    home: ScanResultsScreen(),
  ));
}

