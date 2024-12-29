import 'package:flutter/material.dart';
import 'package:weather_proj/models/daily_weather.dart';
import 'package:weather_proj/widgets/temperature_widget.dart';

class Daily extends StatelessWidget {
  final DailyWeather dailyWeather;

  const Daily({super.key, required this.dailyWeather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var day in dailyWeather.dayWeathers)
          Row(children: [
            Text(day.date),
            TemperatureWidget(temperature: day.minTemperature),
            TemperatureWidget(temperature: day.maxTemperature),
          ]),
      ],
    );
  }
}
