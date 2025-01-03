
import '../metrics/temperature.dart';
import '../metrics/wind_speed.dart';
import 'hour_weather.dart';

class HourlyWeather {
  final List<HourWeather> hourWeathers;

  HourlyWeather({required this.hourWeathers});

  static List<String> _extractTime(List<String> dates) {
    final DateTime now = DateTime.now();
    final List<String> time = [];

    for (var i = 0; i < dates.length; i++) {
      if (DateTime.parse(dates[i]).isBefore(now) &&
          DateTime.parse(dates[i]).isBefore(
            now.add(Duration(hours: 24)))) {
        time.add(dates[i].substring(dates[i].indexOf('T') + 1));
      }
    }
    return time;
  }

  factory HourlyWeather.fromJson(
      Map<String, dynamic> hourlyJson, Map<String, dynamic> hourlyUnitsJson) {
    final temperatureUnit = hourlyUnitsJson["temperature_2m"];
    final windSpeedUnit = hourlyUnitsJson["wind_speed_10m"];

    final timeList = _extractTime(List<String>.from(hourlyJson["time"]));
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
