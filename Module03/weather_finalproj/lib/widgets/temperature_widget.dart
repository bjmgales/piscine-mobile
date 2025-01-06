import 'package:flutter/material.dart';

import '../models/weather/metrics/temperature.dart';

class TemperatureWidget extends StatelessWidget {
  final Temperature temperature;
  final double? fontSize;
  final Color? color;

  const TemperatureWidget(
      {super.key, required this.temperature, this.fontSize, this.color});

  String _formatTemperature() {
    return "${temperature.value}${temperature.unit}";
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTemperature(),
      style: TextStyle(
        color: color ?? Colors.orangeAccent,
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
