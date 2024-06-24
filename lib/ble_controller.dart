// //default
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'distance_screen.dart'; // Import the distance screen
//
// class ScanResultsScreen extends StatefulWidget {
//   @override
//   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// }
//
// class _ScanResultsScreenState extends State<ScanResultsScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   String searchQuery = "";
//   bool isSearching = false;
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
//   List<ScanResult> get filteredScanResults {
//     if (searchQuery.isEmpty) {
//       return scanResults;
//     } else {
//       return scanResults
//           .where((result) => result.device.name.toLowerCase().contains(searchQuery.toLowerCase()))
//           .toList();
//     }
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
//         title: !isSearching
//             ? Text('Scanned Bluetooth Devices')
//             : TextField(
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'Search for a device',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.blueGrey),
//           ),
//           style: TextStyle(color: Colors.black), // Change text color to black
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
//         backgroundColor: Colors.white10, // Change AppBar color
//       ),
//       body: Container(
//         color: Colors.blueGrey, // Set the background color of the page
//         child: ListView.builder(
//           itemCount: filteredScanResults.length,
//           itemBuilder: (context, index) {
//             final device = filteredScanResults[index].device;
//             final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
//             final deviceAddress = device.id.id;
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding between buttons
//               child: Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   width: 2.5 * 130, // 2.5cm in pixels (1cm ≈ 38.1 pixels)
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       // Button text color
//                       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0), // Rounded corners
//                       ),
//                       elevation: 3.0, // Button shadow
//                     ),
//                     onPressed: () {
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
//                     child: Text(
//                       '$deviceName\n$deviceAddress',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14.0), // Text size
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
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
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:permission_handler/permission_handler.dart';
import 'distance_screen.dart';

class ScanResultsScreen extends StatefulWidget {
  @override
  _ScanResultsScreenState createState() => _ScanResultsScreenState();
}

class _ScanResultsScreenState extends State<ScanResultsScreen> {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> scanResults = [];
  String searchQuery = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  void requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();

    if (await Permission.bluetooth.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted &&
        await Permission.location.isGranted) {
      startScan();
    } else {
      // Handle permission denied case
      print("Permissions not granted");
    }
  }

  void startScan() {
    // Clear previous results
    scanResults.clear();

    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 15));

    // Listen to scan results
    flutterBlue.scanResults.listen((results) {
      setState(() {
        scanResults = results;
      });
      for (ScanResult result in results) {
        print("Device found: ${result.device.name}, ID: ${result.device.id.id}");
      }
    }, onDone: () {
      print("Scan complete");
    }, onError: (error) {
      print("Scan error: $error");
    });
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DistanceScreen(
          device: device,
        ),
      ),
    );
  }

  List<ScanResult> get filteredScanResults {
    if (searchQuery.isEmpty) {
      return scanResults;
    } else {
      return scanResults
          .where((result) => result.device.name.toLowerCase().contains(searchQuery.toLowerCase()) || result.device.id.id.contains(searchQuery))
          .toList();
    }
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
        child: ListView.builder(
          itemCount: filteredScanResults.length,
          itemBuilder: (context, index) {
            final device = filteredScanResults[index].device;
            final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
            final deviceAddress = device.id.id;

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
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ScanResultsScreen(),
  ));
}


// bluetooth_screen.dart
//google
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// FlutterBlue flutterBlue = FlutterBlue.instance;
//
// // Start scanning
// flutterBlue.startScan(timeout: Duration(seconds: 4));
//
//
//
// Future<void> requestPermissions() async {
// if (await Permission.bluetoothScan.isGranted &&
// await Permission.bluetooth.isGranted &&
// await Permission.location.isGranted) {
// // Permissions are granted, proceed with scanning
// } else {
// await Permission.bluetoothScan.request();
// await Permission.bluetooth.request();
// await Permission.location.request();
// }
// }
// flutterBlue.scanResults.listen((List<ScanResult> results) {
// // Do something with scan results
// for (ScanResult r in results) {
// print('${r.device.name} found! rssi: ${r.rssi}');
// }
// });
//
//
// class ScanResultsPage extends StatelessWidget {
// final List<ScanResult> scanResults;
//
// ScanResultsPage({required this.scanResults});
//
// @override
// Widget build(BuildContext context) {
// return Scaffold(
// appBar: AppBar(
// title: Text('Scanned Devices'),
// ),
// body: ListView.builder(
// itemCount: scanResults.length,
// itemBuilder: (context, index) {
// var result = scanResults[index];
// return ListTile(
// title: Text(result.device.name),
// subtitle: Text(result.device.id.toString()),
// trailing: Text(result.rssi.toString()),
// );
// },
// ),
// );
// }
// }
// flutterBlue.stopScan();
// 22/6/24-2
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'distance_screen.dart';
//
// class ScanResultsScreen extends StatefulWidget {
//   @override
//   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// }
//
// class _ScanResultsScreenState extends State<ScanResultsScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   String searchQuery = "";
//   bool isSearching = false;
//
//   @override
//   void initState() {
//     super.initState();
//     requestPermissions();
//   }
//
//   void requestPermissions() async {
//     await [
//       Permission.bluetooth,
//       Permission.bluetoothScan,
//       Permission.bluetoothConnect,
//       Permission.location
//     ].request();
//
//     if (await Permission.bluetooth.isGranted &&
//         await Permission.bluetoothScan.isGranted &&
//         await Permission.bluetoothConnect.isGranted &&
//         await Permission.location.isGranted) {
//       startScan();
//     } else {
//       // Handle permission denied case
//       print("Permissions not granted");
//     }
//   }
//
//   void startScan() {
//     // Clear previous results
//     scanResults.clear();
//
//     // Start scanning
//     flutterBlue.startScan(timeout: Duration(seconds: 15));
//
//     // Listen to scan results
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//       for (ScanResult result in results) {
//         print("Device found: ${result.device.name}, ID: ${result.device.id.id}");
//       }
//     }, onDone: () {
//       print("Scan complete");
//     }, onError: (error) {
//       print("Scan error: $error");
//     });
//   }
//
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DistanceScreen(
//           device: device,
//         ),
//       ),
//     );
//   }
//
//   List<ScanResult> get filteredScanResults {
//     if (searchQuery.isEmpty) {
//       return scanResults;
//     } else {
//       return scanResults
//           .where((result) => result.device.name.toLowerCase().contains(searchQuery.toLowerCase()) || result.device.id.id.contains(searchQuery))
//           .toList();
//     }
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
//         child: ListView.builder(
//           itemCount: filteredScanResults.length,
//           itemBuilder: (context, index) {
//             final device = filteredScanResults[index].device;
//             final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
//             final deviceAddress = device.id.id;
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   width: 2.5 * 130,
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0),
//                       ),
//                       elevation: 3.0,
//                     ),
//                     onPressed: () => connectToDevice(device),
//                     child: Text(
//                       '$deviceName\n$deviceAddress',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14.0),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
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


// 22/6/24 -1
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'distance_screen.dart'; // Import the distance screen
//
// class ScanResultsScreen extends StatefulWidget {
//   @override
//   _ScanResultsScreenState createState() => _ScanResultsScreenState();
// }
//
// class _ScanResultsScreenState extends State<ScanResultsScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   String searchQuery = "";
//   bool isSearching = false;
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
//     flutterBlue.startScan(timeout: Duration(seconds: 10));
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
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => DistanceScreen(
//           device: device,
//         ),
//       ),
//     );
//   }
//
//   List<ScanResult> get filteredScanResults {
//     if (searchQuery.isEmpty) {
//       return scanResults;
//     } else {
//       return scanResults
//           .where((result) => result.device.name.toLowerCase().contains(searchQuery.toLowerCase()))
//           .toList();
//     }
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
//         title: !isSearching
//             ? Text('Scanned Bluetooth Devices')
//             : TextField(
//           autofocus: true,
//           decoration: InputDecoration(
//             hintText: 'Search for a device',
//             border: InputBorder.none,
//             hintStyle: TextStyle(color: Colors.blueGrey),
//           ),
//           style: TextStyle(color: Colors.black), // Change text color to black
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
//         backgroundColor: Colors.white10, // Change AppBar color
//       ),
//       body: Container(
//         color: Colors.blueGrey, // Set the background color of the page
//         child: ListView.builder(
//           itemCount: filteredScanResults.length,
//           itemBuilder: (context, index) {
//             final device = filteredScanResults[index].device;
//             final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
//             final deviceAddress = device.id.id;
//
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding between buttons
//               child: Align(
//                 alignment: Alignment.center,
//                 child: SizedBox(
//                   width: 2.5 * 130, // 2.5cm in pixels (1cm ≈ 38.1 pixels)
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       // Button text color
//                       padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12.0), // Rounded corners
//                       ),
//                       elevation: 3.0, // Button shadow
//                     ),
//                     onPressed: () => connectToDevice(device),
//                     child: Text(
//                       '$deviceName\n$deviceAddress',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(fontSize: 14.0), // Text size
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
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



//20-june 1st
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class BLEControllerScreen extends StatefulWidget {
//   @override
//   _BLEControllerScreenState createState() => _BLEControllerScreenState();
// }
//
// class _BLEControllerScreenState extends State<BLEControllerScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   bool isScanning = false;
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     setState(() {
//       isScanning = true;
//     });
//
//     flutterBlue.startScan(timeout: Duration(seconds: 10)).then((_) {
//       setState(() {
//         isScanning = false;
//       });
//     });
//
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//     });
//   }
//
//   void connectToDevice(BluetoothDevice device) async {
//     await device.connect();
//     // Navigate to the control screen or perform other operations
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => DeviceControlScreen(device: device)),
//     );
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
//         title: Text('BLE Controller'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Container(
//         color: Colors.blueGrey,
//         child: Column(
//           children: [
//             isScanning
//                 ? LinearProgressIndicator()
//                 : ElevatedButton(
//               onPressed: startScan,
//               child: Text('Scan Again'),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scanResults.length,
//                 itemBuilder: (context, index) {
//                   final result = scanResults[index];
//                   return ListTile(
//                     title: Text(result.device.name.isNotEmpty ? result.device.name : 'Unknown Device'),
//                     subtitle: Text(result.device.id.id),
//                     onTap: () => connectToDevice(result.device),
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
// class DeviceControlScreen extends StatelessWidget {
//   final BluetoothDevice device;
//
//   DeviceControlScreen({required this.device});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Control'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Connected to ${device.name}'),
//             // Add more controls for the device here
//           ],
//         ),
//       ),
//     );
//   }
// }


//sucess
//
// import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
//
// class BLEControllerScreen extends StatefulWidget {
//   @override
//   _BLEControllerScreenState createState() => _BLEControllerScreenState();
// }
//
// class _BLEControllerScreenState extends State<BLEControllerScreen> {
//   FlutterBlue flutterBlue = FlutterBlue.instance;
//   List<ScanResult> scanResults = [];
//   bool isScanning = false;
//   Map<String, bool> connectedDevices = {}; // Map to track connected devices
//
//   @override
//   void initState() {
//     super.initState();
//     startScan();
//   }
//
//   void startScan() {
//     setState(() {
//       isScanning = true;
//     });
//
//     flutterBlue.startScan(timeout: Duration(seconds: 10)).then((_) {
//       setState(() {
//         isScanning = false;
//       });
//     });
//
//     flutterBlue.scanResults.listen((results) {
//       setState(() {
//         scanResults = results;
//       });
//     });
//   }
//
//   Future<void> connectToDevice(BluetoothDevice device) async {
//     try {
//       await device.connect();
//       connectedDevices[device.id.id] = true; // Update connection status
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Connected to ${device.name.isNotEmpty ? device.name : 'Unknown Device'}')),
//       );
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => DeviceControlScreen(device: device)),
//       );
//     } catch (e) {
//       connectedDevices[device.id.id] = false; // Update connection status
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to connect to ${device.name.isNotEmpty ? device.name : 'Unknown Device'}')),
//       );
//       print("Connection error: $e");
//     }
//     setState(() {}); // Update UI after connection attempt
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
//         title: Text('BLE Controller'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Container(
//         color: Colors.blueGrey,
//         child: Column(
//           children: [
//             isScanning
//                 ? LinearProgressIndicator()
//                 : ElevatedButton(
//               onPressed: startScan,
//               child: Text('Scan Again'),
//             ),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: scanResults.length,
//                 itemBuilder: (context, index) {
//                   final result = scanResults[index];
//                   final isConnected = connectedDevices[result.device.id.id] ?? false;
//                   return ListTile(
//                     title: Text(result.device.name.isNotEmpty ? result.device.name : 'Unknown Device'),
//                     subtitle: Text(result.device.id.id),
//                     trailing: isConnected ? Text('Connected') : Text('Not Connected'), // Show connection status
//                     onTap: () => connectToDevice(result.device),
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
// class DeviceControlScreen extends StatelessWidget {
//   final BluetoothDevice device;
//
//   DeviceControlScreen({required this.device});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Device Control'),
//         backgroundColor: Colors.blueGrey,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Connected to ${device.name.isNotEmpty ? device.name : 'Unnamed Device'}'),
//             // Add more controls for the device here
//           ],
//         ),
//       ),
//     );
//   }
// }
//
