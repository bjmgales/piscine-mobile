import 'package:flutter/material.dart';
import 'package:weather_proj/models/weather/metrics/wind_speed.dart';

class WindSpeedWidget extends StatelessWidget {
  final WindSpeed windSpeed;

  const WindSpeedWidget({super.key, required this.windSpeed});

  String _formatWindSpeed() {
    return "${windSpeed.value}${windSpeed.unit}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(_formatWindSpeed());
  }
}
