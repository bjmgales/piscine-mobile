class ConditionMapper {
  static const Map<int, List<String>> weatherCodes = {
    0: ['Clear sky', 'assets/weather_svg/wi-day-sunny.svg'],
    1: ['Mainly clear', 'assets/weather_svg/wi-day-sunny-overcast.svg'],
    2: ['Cloudy', 'assets/weather_svg/wi-day-cloudy.svg'],
    3: ['Overcast', 'assets/weather_svg/wi-cloudy.svg'],
    45: ['Fog', 'assets/weather_svg/wi-fog.svg'],
    48: ['Rime fog', 'assets/weather_svg/wi-dust.svg'],
    51: ['Light drizzle', 'assets/weather_svg/wi-sprinkle.svg'],
    53: ['Moderate drizzle', 'assets/weather_svg/wi-showers.svg'],
    55: ['Dense drizzle', 'assets/weather_svg/wi-rain.svg'],
    56: ['Freezing drizzle', 'assets/weather_svg/wi-rain-mix.svg'],
    57: ['Freezing drizzle', 'assets/weather_svg/wi-rain-mix.svg'],
    61: ['Slight rain', 'assets/weather_svg/wi-rain.svg'],
    63: ['Moderate rain', 'assets/weather_svg/wi-rain.svg'],
    65: ['Heavy rain', 'assets/weather_svg/wi-rain-wind.svg'],
    66: ['Freezing rain', 'assets/weather_svg/wi-rain-mix.svg'],
    67: ['Freezing rain', 'assets/weather_svg/wi-rain-mix.svg'],
    71: ['Snow fall', 'assets/weather_svg/wi-snow.svg'],
    73: ['Snow fall', 'assets/weather_svg/wi-snow.svg'],
    75: ['Heavy snow fall', 'assets/weather_svg/wi-snow-wind.svg'],
    77: ['Snow grains', 'assets/weather_svg/wi-snowflake-cold.svg'],
    80: ['Rain showers', 'assets/weather_svg/wi-day-showers.svg'],
    81: ['Rain showers', 'assets/weather_svg/wi-day-showers.svg'],
    82: ['Violent rain showers', 'assets/weather_svg/wi-storm-showers.svg'],
    85: ['Snow showers', 'assets/weather_svg/wi-day-snow.svg'],
    86: ['Snowstorm', 'assets/weather_svg/wi-snow.svg'],
    95: ['Thunderstorm', 'assets/weather_svg/wi-thunderstorm.svg'],
    96: ['Hailstorm', 'assets/weather_svg/wi-thunderstorm.svg'],
    99: ['Hailstorm', 'assets/weather_svg/wi-thunderstorm.svg']
  };

  static List<String> fromCode(int code) {
    var result = weatherCodes[code];
    if (result == null) {
      throw Exception("Cannot map condition with code : $code");
    }
    return result;
  }
}
