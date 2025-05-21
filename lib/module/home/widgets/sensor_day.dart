import 'package:cloud_firestore/cloud_firestore.dart';

class SensorDay {
  final int hour;
  final double temperature;
  final double humidity;
  final double ppm;

  SensorDay({
    required this.hour,
    required this.temperature,
    required this.humidity,
    required this.ppm,
  });
}
