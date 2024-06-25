// sucsess
// import 'package:flutter/material.dart';
// import 'ble_controller.dart';
//
// class HomeScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('tracEase'),
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(16.0), // Adjust padding as needed
//             child: Column(
//               children: [
//                 Text(
//                   'Welcome',
//                   style: TextStyle(
//                     fontSize: 50,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//                 SizedBox(height: 35), // Add a gap of 16 logical pixels between the two lines
//                 Text(
//                   'Find your nearby Bluetooth devices',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 25,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Stack(
//               alignment: Alignment.bottomCenter,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.blueGrey, // Set the background color
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(bottom: 100.0), // Adjusted bottom padding for the button
//                   child: Container(
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       gradient: RadialGradient(
//                         colors: [
//                           Colors.white.withOpacity(0.5),
//                           Colors.white.withOpacity(0.5),
//                         ],
//                         center: Alignment(0.0, 0.0),
//                         radius: 0.8,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.5),
//                           blurRadius: 10,
//                           spreadRadius: 5,
//                         ),
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.5),
//                           blurRadius: 10,
//                           spreadRadius: 5,
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       style: ButtonStyle(
//                         backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
//                         shape: MaterialStateProperty.all<OutlinedBorder>(CircleBorder()),
//                         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(35)),
//                       ),
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => ScanResultsScreen()),
//                         );
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.all(40),
//                         child: Text(
//                           'Find Bluetooth Devices',
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.blueGrey, // Set the overall background color
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     home: HomeScreen(),
//   ));
// }
//




import 'package:flutter/material.dart';
import 'ble_controller.dart';
import 'scan_devices.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('tracEase'),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 40, // Adjusted font size
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 24), // Reduced height
                Text(
                  'Discover, Find and Measure',
                  //Find misplaced items and track nearby devices
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // Adjusted font size
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 200.0), // Reduced padding
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
                          )),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 20, horizontal: 80)), // Adjusted padding
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScanResultsScreen()),
                          );
                        },
                        child: Text(
                          'Find Item',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22), // Adjusted font size
                        ),
                      ),
                      SizedBox(height: 30), // Reduced height
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0), // Adjusted border radius
                          )),
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.symmetric(vertical: 20, horizontal: 18)), // Adjusted padding
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ScanDevicesScreen()),
                          );
                        },
                        child: Text(
                          'Scan nearby Devices',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22), // Adjusted font size
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
    );
  }
}
