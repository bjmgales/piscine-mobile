import 'package:flutter/material.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';

class TemperatureWidget extends StatelessWidget {
  final Temperature temperature;

  const TemperatureWidget({super.key, required this.temperature});

  String _formatTemperature() {
    return "${temperature.value}${temperature.unit}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatTemperature());
  }
}
