import 'package:weather_proj/models/temperature.dart';

class DayWeather {
  final String date;
  final Temperature minTemperature;
  final Temperature maxTemperature;

  DayWeather(
      {required this.date,
      required this.minTemperature,
      required this.maxTemperature});
}
