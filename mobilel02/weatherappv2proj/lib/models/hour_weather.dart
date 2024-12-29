import 'package:weather_proj/models/temperature.dart';
import 'package:weather_proj/models/wind_speed.dart';

class HourWeather {
  final String time;
  final Temperature temperature;
  final WindSpeed windSpeed;

  HourWeather(
      {required this.time, required this.temperature, required this.windSpeed});
}
