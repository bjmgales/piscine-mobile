import 'package:flutter/material.dart';

import '../models/weather/metrics/wind_speed.dart';

class WindSpeedWidget extends StatelessWidget {
  final WindSpeed windSpeed;
  double? fontSize;

  WindSpeedWidget({super.key, required this.windSpeed, this.fontSize});

  String _formatWindSpeed() {
    return "${windSpeed.value}${windSpeed.unit}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatWindSpeed(),
      style: TextStyle(
        color: Colors.lightBlueAccent,
        fontSize: fontSize,
        shadows: [
          Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 10.0,
        color: Colors.black.withAlpha(200),
          ),
        ],
      ),
    );
  }
}
