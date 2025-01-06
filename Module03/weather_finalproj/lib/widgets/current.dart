import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/weather/current_weather.dart';
import 'temperature_widget.dart';
import 'wind_speed_widget.dart';

class Current extends StatelessWidget {
  final CurrentWeather currentWeather;

  const Current({super.key, required this.currentWeather});
  @override
  Widget build(BuildContext context) {
    // Orientation orientation = MediaQuery.of(context).orientation;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 0,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 90.0),
          child: Text(
            currentWeather.condition[0],
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 40, right: 20),
                child: TemperatureWidget(
                  temperature: currentWeather.temperature,
                  fontSize: 30,
                ),
              ),
              SvgPicture.asset(currentWeather.condition[1],
                  width: 150,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 30, bottom: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 10,
            children: [
              SvgPicture.asset('assets/weather_svg/wind-speed.svg',
                  width: 80,
                  colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn)),
              Padding(
                padding: const EdgeInsets.only(top: 40, left:20),
                child: WindSpeedWidget(
                  windSpeed: currentWeather.windSpeed,
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
