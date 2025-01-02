import 'package:flutter/material.dart';
import 'package:weather_proj/models/weather/current_weather.dart';

class SearchError {
  String? text;
  Color? color;
  Text? widget;

  SearchError evaluateContext(CurrentWeather? weather, String search,
      bool isSubmit, bool isGeoloc, bool isConnectionLost) {
    debugPrint('$isConnectionLost');
    if (weather == null && isConnectionLost) {
      text = 'The service connection is lost.'
          'Please check your internet connection or try again later.';
      color = Colors.red;
      widget = Text(
        text!,
        style: TextStyle(color: color),
      );
    } else if (weather == null && isSubmit) {
      text = "The provided location was not found.";
      color = Colors.red;
      widget = Text(
        text!,
        style: TextStyle(color: color),
      );
    } else if (weather == null && isGeoloc) {
      text = "Please allow geolocation or enter a city manually.";
      color = Colors.red;
      widget = Text(
        text!,
        style: TextStyle(color: color),
      );
    } else if (weather == null) {
      text = "Please provide location...";
      color = Colors.white;
      widget = Text(
        text!,
        style: TextStyle(color: color),
      );
    }
    return this;
  }
}
