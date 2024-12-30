import 'package:weather_proj/mappers/condition_mapper.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';
import 'package:weather_proj/models/weather/metrics/wind_speed.dart';

class CurrentWeather {
  final Temperature temperature;
  final String condition;
  final WindSpeed windSpeed;

  CurrentWeather(
      {required this.temperature,
      required this.condition,
      required this.windSpeed});

  factory CurrentWeather.fromJson(
      Map<String, dynamic> currentJson, Map<String, dynamic> currentUnitsJson) {
    final temperature = currentJson["temperature_2m"];
    final windSpeed = currentJson["wind_speed_10m"];
    final weatherCode = currentJson["weather_code"];
    final temperatureUnit = currentUnitsJson["temperature_2m"];
    final windSpeedUnit = currentUnitsJson["wind_speed_10m"];
    if (temperature != null &&
        windSpeed != null &&
        weatherCode != null &&
        temperatureUnit != null &&
        windSpeedUnit != null) {
      return CurrentWeather(
          temperature: Temperature(value: temperature, unit: temperatureUnit),
          condition: ConditionMapper.fromCode(weatherCode),
          windSpeed: WindSpeed(value: windSpeed, unit: windSpeedUnit));
    }
    throw Exception(
        "Cannot build CurrentWeather with value : $currentJson \n and \n$currentUnitsJson");
  }
}
