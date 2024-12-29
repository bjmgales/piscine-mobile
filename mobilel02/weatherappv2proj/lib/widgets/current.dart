import 'package:flutter/material.dart';
import 'package:weather_proj/models/current_weather.dart';
import 'package:weather_proj/widgets/temperature_widget.dart';
import 'package:weather_proj/widgets/wind_speed_widget.dart';

class Current extends StatelessWidget {
  final CurrentWeather currentWeather;

  const Current({super.key, required this.currentWeather});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        TemperatureWidget(
          temperature: currentWeather.temperature,
        ),
        Text(currentWeather.condition),
        WindSpeedWidget(
          windSpeed: currentWeather.windSpeed,
        ),
      ],
    );
  }
}
