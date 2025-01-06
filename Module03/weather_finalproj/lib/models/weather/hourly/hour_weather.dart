import '../metrics/temperature.dart';
import '../metrics/wind_speed.dart';

class HourWeather {
  final String time;
  final List<String> condition;
  final Temperature temperature;
  final WindSpeed windSpeed;

  HourWeather({
    required this.time,
    required this.condition,
    required this.temperature,
    required this.windSpeed,
  });
}
