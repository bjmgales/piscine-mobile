import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';
import 'package:weather_proj/widgets/line_chart_widget.dart';

import '../models/weather/daily/daily_weather.dart';
import 'temperature_widget.dart';

class Daily extends StatelessWidget {
  final DailyWeather dailyWeather;

  const Daily({super.key, required this.dailyWeather});

  @override
  Widget build(BuildContext context) {
    final List<List<Temperature>> temperaturesList = [
      dailyWeather.dayWeathers.map((e) => e.maxTemperature).toList(),
      dailyWeather.dayWeathers.map((e) => e.minTemperature).toList()
    ];
    final List<String> timeList =
        dailyWeather.dayWeathers.map((e) => e.date).toList();
    final scrollController = ScrollController();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LineChartWidget(
          temperaturesList: temperaturesList,
          timeList: timeList,
          isListOfList: true,
          chartTitle: 'Weekly temperatures',
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
                for (var day in dailyWeather.dayWeathers)
                  Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        spacing: 4,
                        children: [
                          Text(
                            day.date,
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Colors.white, fontSize: 13),
                          ),
                          SvgPicture.asset(
                            day.condition[1],
                            colorFilter: ColorFilter.mode(
                                Colors.white, BlendMode.srcIn),
                            width: 50,
                          ),
                          TemperatureWidget(
                            temperature: day.maxTemperature,
                            color: Colors.orangeAccent,
                            fontSize: 15,
                          ),
                          TemperatureWidget(
                            temperature: day.minTemperature,
                            color: Colors.lightBlueAccent,
                            fontSize: 15,
                          ),
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
