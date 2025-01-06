import 'package:weather_proj/mappers/condition_mapper.dart';
import 'package:weather_proj/utils/formatter.dart';

import '../metrics/temperature.dart';
import '../metrics/wind_speed.dart';
import 'hour_weather.dart';

class HourlyWeather {
  final List<HourWeather> hourWeathers;

  HourlyWeather({required this.hourWeathers});

  factory HourlyWeather.fromJson(
      Map<String, dynamic> hourlyJson, Map<String, dynamic> hourlyUnitsJson) {
    final temperatureUnit = hourlyUnitsJson["temperature_2m"];
    final windSpeedUnit = hourlyUnitsJson["wind_speed_10m"];

    final timeList = formatTime(List<String>.from(hourlyJson["time"]));
    final temperatureList = hourlyJson["temperature_2m"];
    final windSpeedList = hourlyJson["wind_speed_10m"];
    final weatherCodeList = hourlyJson["weather_code"];
    final List<HourWeather> result = [];
    for (int i = 0; i < timeList.length; i++) {
      final time = timeList[i];
      final temperature = temperatureList[i];
      final windSpeed = windSpeedList[i];
      final weatherCode = ConditionMapper.fromCode(weatherCodeList[i]);

      result.add(HourWeather(
          time: time,
          temperature: Temperature(value: temperature, unit: temperatureUnit),
          windSpeed: WindSpeed(value: windSpeed, unit: windSpeedUnit),
          condition: weatherCode));
    }

    return HourlyWeather(hourWeathers: result);
  }
}
