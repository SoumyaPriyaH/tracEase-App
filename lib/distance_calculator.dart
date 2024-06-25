 // import 'dart:math';
//
// class DistanceCalculator {
//   static double calculateDistance(int rssi) {
//     int txPower = -59; // Reference RSSI at 1 meter
//     double ratio = rssi * 1.0 / txPower;
//     if (ratio < 1.0) {
//       return pow(ratio, 10).toDouble(); // Convert to double
//     } else {
//       return (0.89976) * pow(ratio, 7.7095) + 0.111;
//     }
//   }
// }
//


 import 'dart:math';

 class DistanceCalculator {
   static double calculateDistance(int rssi) {
     // Constants for distance calculation
     const int txPower = -59; // RSSI value at 1 meter
     const double n = 2.0; // Path-loss exponent (environment factor)

     if (rssi == 0) {
       return -1.0; // if we cannot determine accuracy, return -1.
     }

     double ratio = rssi * 1.0 / txPower;
     if (ratio < 1.0) {
       return pow(ratio, 10).toDouble(); // Explicitly cast to double
     } else {
       double distance = (0.89976 * pow(ratio, 7.7095)) + 0.111;
       return distance;
     }
   }
 }
