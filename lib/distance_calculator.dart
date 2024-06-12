import 'dart:math';

class DistanceCalculator {
  static double calculateDistance(int rssi) {
    int txPower = -59; // Reference RSSI at 1 meter
    double ratio = rssi * 1.0 / txPower;
    if (ratio < 1.0) {
      return pow(ratio, 10).toDouble(); // Convert to double
    } else {
      return (0.89976) * pow(ratio, 7.7095) + 0.111;
    }
  }
}

