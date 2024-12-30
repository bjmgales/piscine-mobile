import 'package:flutter/material.dart';
import 'package:weather_proj/models/weather/hourly/hourly_weather.dart';
import 'package:weather_proj/widgets/temperature_widget.dart';
import 'package:weather_proj/widgets/wind_speed_widget.dart';

class Hourly extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  const Hourly({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var hour in hourlyWeather.hourWeathers)
              Wrap(
                spacing: 20,
                children: [
                  Text(hour.time),
                  TemperatureWidget(temperature: hour.temperature),
                  WindSpeedWidget(windSpeed: hour.windSpeed),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
