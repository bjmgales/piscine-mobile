import 'package:flutter/material.dart';

import '../models/weather/daily/daily_weather.dart';
import 'temperature_widget.dart';

class Daily extends StatelessWidget {
  final DailyWeather dailyWeather;

  const Daily({super.key, required this.dailyWeather});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var day in dailyWeather.dayWeathers)
          Wrap(

              spacing: 20,
              alignment: WrapAlignment.center,
              children: [
                Text(day.date, textAlign: TextAlign.center,),
                TemperatureWidget(temperature: day.minTemperature),
                TemperatureWidget(temperature: day.maxTemperature),
                Text(day.condition, textAlign: TextAlign.center,)
              ]),
      ],
    );
  }
}
