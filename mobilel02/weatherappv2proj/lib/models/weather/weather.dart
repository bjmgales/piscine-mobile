import 'package:weather_proj/models/weather/current_weather.dart';
import 'package:weather_proj/models/weather/daily/daily_weather.dart';
import 'package:weather_proj/models/weather/hourly/hourly_weather.dart';

class Weather {
  final CurrentWeather currentWeather;
  final HourlyWeather hourlyWeather;
  final DailyWeather dailyWeather;

  const Weather(
      {required this.currentWeather,
      required this.hourlyWeather,
      required this.dailyWeather});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
        currentWeather:
            CurrentWeather.fromJson(json["current"], json["current_units"]),
        hourlyWeather:
            HourlyWeather.fromJson(json["hourly"], json["hourly_units"]),
        dailyWeather:
            DailyWeather.fromJson(json["daily"], json["daily_units"]));
  }
}