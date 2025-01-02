import 'package:weather_proj/models/weather/metrics/temperature.dart';

class DayWeather {
  final String date;
  final Temperature minTemperature;
  final Temperature maxTemperature;
  final String condition;

  DayWeather(
      {required this.date,
      required this.minTemperature,
      required this.maxTemperature,
      required this.condition});
}
