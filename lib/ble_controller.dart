
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
//           final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
//           final deviceAddress = device.id.id;
//
//           return ElevatedButton(
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => DistanceScreen(
//                     deviceName: deviceName,
//                     deviceAddress: deviceAddress,
//                   ),
//                 ),
//               );
//             },
//             child: Text('$deviceName\n$deviceAddress'),
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
  String searchQuery = "";
  bool isSearching = false;

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

  List<ScanResult> get filteredScanResults {
    if (searchQuery.isEmpty) {
      return scanResults;
    } else {
      return scanResults
          .where((result) => result.device.name.toLowerCase().contains(searchQuery.toLowerCase()))
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
          style: TextStyle(color: Colors.black), // Change text color to black
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
        backgroundColor: Colors.white10, // Change AppBar color
      ),
      body: Container(
        color: Colors.blueGrey, // Set the background color of the page
        child: ListView.builder(
          itemCount: filteredScanResults.length,
          itemBuilder: (context, index) {
            final device = filteredScanResults[index].device;
            final deviceName = device.name.isNotEmpty ? device.name : "Unknown Device";
            final deviceAddress = device.id.id;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0), // Add vertical padding between buttons
              child: Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: 2.5 * 130, // 2.5cm in pixels (1cm ≈ 38.1 pixels)
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // Button text color
                      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Button padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0), // Rounded corners
                      ),
                      elevation: 3.0, // Button shadow
                    ),
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
                    child: Text(
                      '$deviceName\n$deviceAddress',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0), // Text size
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
