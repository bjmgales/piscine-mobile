import 'package:weather_proj/mappers/condition_mapper.dart';
import 'package:weather_proj/models/weather/daily/day_weather.dart';
import 'package:weather_proj/models/weather/metrics/temperature.dart';

class DailyWeather {
  final List<DayWeather> dayWeathers;

  DailyWeather({required this.dayWeathers});

  factory DailyWeather.fromJson(
      Map<String, dynamic> dailyJson, Map<String, dynamic> dailyUnitsJson) {
    final temperatureUnit = dailyUnitsJson["temperature_2m_min"];

    final dateList = dailyJson["time"];
    final minTemperatureList = dailyJson["temperature_2m_min"];
    final maxTemperatureList = dailyJson["temperature_2m_max"];
    final conditionList = dailyJson['weather_code'];

    final List<DayWeather> result = [];
    for (int i = 0; i < dateList.length; i++) {
      final date = dateList[i];
      final minTemperature = minTemperatureList[i];
      final maxTemperature = maxTemperatureList[i];
      final condition = ConditionMapper.fromCode(conditionList[i]);

      result.add(DayWeather(
          date: date,
          minTemperature:
              Temperature(value: minTemperature, unit: temperatureUnit),
          maxTemperature:
              Temperature(value: maxTemperature, unit: temperatureUnit),
          condition: condition));
    }

    return DailyWeather(dayWeathers: result);
  }
}
