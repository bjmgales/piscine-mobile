import 'package:weather_proj/models/hour_weather.dart';
import 'package:weather_proj/models/temperature.dart';
import 'package:weather_proj/models/wind_speed.dart';

class HourlyWeather {
  final List<HourWeather> hourWeathers;

  HourlyWeather({required this.hourWeathers});

  factory HourlyWeather.fromJson(
      Map<String, dynamic> hourlyJson, Map<String, dynamic> hourlyUnitsJson) {
    final temperatureUnit = hourlyUnitsJson["temperature_2m"];
    final windSpeedUnit = hourlyUnitsJson["wind_speed_10m"];

    final timeList = hourlyJson["time"];
    final temperatureList = hourlyJson["temperature_2m"];
    final windSpeedList = hourlyJson["wind_speed_10m"];

    final List<HourWeather> result = [];
    for (int i = 0; i < timeList.length; i++) {
      final time = timeList[i];
      final temperature = temperatureList[i];
      final windSpeed = windSpeedList[i];

      result.add(HourWeather(
          time: time,
          temperature: Temperature(value: temperature, unit: temperatureUnit),
          windSpeed: WindSpeed(value: windSpeed, unit: windSpeedUnit)));
    }

    return HourlyWeather(hourWeathers: result);
  }
}
