import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';
import 'package:weather_proj/widgets/line_chart_widget.dart';

import '../models/weather/hourly/hourly_weather.dart';
import 'temperature_widget.dart';
import 'wind_speed_widget.dart';

class Hourly extends StatelessWidget {
  final HourlyWeather hourlyWeather;

  const Hourly({super.key, required this.hourlyWeather});

  @override
  Widget build(BuildContext context) {
    final List<Temperature> temperatureList =
        hourlyWeather.hourWeathers.map((e) => e.temperature).toList();
    final List<String> timeList =
        hourlyWeather.hourWeathers.map((e) => e.time).toList();
    final scrollController = ScrollController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LineChartWidget(
          temperaturesList: [temperatureList],
          timeList: timeList,
          chartTitle: 'Today temperatures',
        ),
        RawScrollbar(
          controller: scrollController,
          thumbColor: Colors.orangeAccent,
          thumbVisibility: true,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: scrollController,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var hour in hourlyWeather.hourWeathers)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        spacing: 4,
                        children: [
                          Text(
                            hour.time,
                            style: TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          SvgPicture.asset(hour.condition[1],
                              colorFilter: ColorFilter.mode(
                                  Colors.white, BlendMode.srcIn), width: 50,),
                          TemperatureWidget(temperature: hour.temperature, fontSize: 15,),
                          WindSpeedWidget(windSpeed: hour.windSpeed, fontSize: 15,),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
