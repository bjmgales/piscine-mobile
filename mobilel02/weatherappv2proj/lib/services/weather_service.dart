import 'package:weather_proj/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<Weather> getWeather(double latitude, double longitude) async {
    final response =
        await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?'
            'latitude=$latitude&longitude=$longitude&'
            'current=temperature_2m,weather_code,wind_speed_10m&'
            'hourly=temperature_2m,weather_code,wind_speed_10m&'
            'daily=weather_code,temperature_2m_max,temperature_2m_min'
            '&timezone=auto'));
    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    }
    throw Exception('Failed to load Weather Data.');
  }
}
