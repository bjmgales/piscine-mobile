import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'city_finder.dart' as cityfinder;

const Map<int, String> weatherCodes = {
  0: 'Clear sky',
  1: 'Mainly clear',
  2: 'Partly cloudy',
  3: 'Overcast',
  45: 'Fog',
  48: 'Depositing rime fog',
  51: 'Drizzle: Light intensity',
  53: 'Drizzle: Moderate intensity',
  55: 'Drizzle: Dense intensity',
  56: 'Freezing Drizzle: Light intensity',
  57: 'Freezing Drizzle: Dense intensity',
  61: 'Rain: Slight intensity',
  63: 'Rain: Moderate intensity',
  65: 'Rain: Heavy intensity',
  66: 'Freezing Rain: Light intensity',
  67: 'Freezing Rain: Heavy intensity',
  71: 'Snow fall: Slight intensity',
  73: 'Snow fall: Moderate intensity',
  75: 'Snow fall: Heavy intensity',
  77: 'Snow grains',
  80: 'Rain showers: Slight intensity',
  81: 'Rain showers: Moderate intensity',
  82: 'Rain showers: Violent intensity',
  85: 'Snow showers: Slight intensity',
  86: 'Snow showers: Heavy intensity',
  95: 'Thunderstorm: Slight or moderate',
  96: 'Thunderstorm with slight hail',
  99: 'Thunderstorm with heavy hail'
};

class WeatherFetched {
  final Map<String, dynamic> current;
  final Map<String, dynamic> units;
  final Map<String, dynamic> hourly;
  final Map<String, dynamic> daily;

  const WeatherFetched(
      {required this.current,
      required this.hourly,
      required this.daily,
      required this.units});

  factory WeatherFetched.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('current') &&
        json.containsKey('current_units') &&
        json.containsKey('hourly') &&
        json.containsKey('daily')) {
      return WeatherFetched(
          current: json['current'],
          units: json['current_units'],
          hourly: json['hourly'],
          daily: json['daily']);
    } else {
      throw ('Miss one or more entries.');
    }
  }
  @override
  String toString() {
    return 'WeatherFetched(current: $current\n hourly: $hourly\n, '
        'daily: $daily)\n';
  }

  WeatherFetched parseResult(WeatherFetched result) {
    Map<String, dynamic> units = result.units;
    String temperatureUnit = units['temperature_2m'];
    String speedUnit = units["wind_speed_10m"];

    result.current['temperature_2m'] =
        result.current['temperature_2m'].toString() + temperatureUnit;
    result.current['wind_speed_10m'] =
        result.current['wind_speed_10m'].toString() + speedUnit;
    result.current['weather_code'] =
        weatherCodes[result.current['weather_code']];

    DateTime now = DateTime.now();
    DateTime endOfDay = now.add(Duration(hours: 24));
    result.hourly['time'] = result.hourly['time'].where((time) {
      DateTime t = DateTime.parse(time);
      return t.isAfter(now) && t.isBefore(endOfDay);
    }).toList();

    result.hourly['temperature_2m'] =
        result.hourly['temperature_2m'].map((temp) {
      return temp.toString() + temperatureUnit;
    }).toList();
    result.hourly['wind_speed_10m'] =
        result.hourly['wind_speed_10m'].map((speed) {
      return speed.toString() + speedUnit;
    }).toList();
    result.hourly['weather_code'] = result.hourly['weather_code'].map((temp) {
      return weatherCodes[temp];
    }).toList();
    result.hourly['temperature_2m'].

    result.daily['temperature_2m_max'] =
        result.daily['temperature_2m_max'].map((temp) {
      return temp.toString() + temperatureUnit;
    }).toList();
    result.daily['temperature_2m_min'] =
        result.daily['temperature_2m_min'].map((temp) {
      return temp.toString() + temperatureUnit;
    }).toList();
    result.daily['weather_code'] = result.daily['weather_code'].map((temp) {
      return weatherCodes[temp];
    }).toList();
    debugPrint('$result');
    return result;
  }
}

Future<WeatherFetched> getWeather(double latitude, double longitude) async {
  final response =
      await http.get(Uri.parse('https://api.open-meteo.com/v1/forecast?'
          'latitude=$latitude&longitude=$longitude&'
          'current=temperature_2m,weather_code,wind_speed_10m&'
          'hourly=temperature_2m,weather_code,wind_speed_10m&'
          'daily=weather_code,temperature_2m_max,temperature_2m_min'
          '&timezone=auto'));
  if (response.statusCode == 200) {
    Map<String, dynamic> weatherData = jsonDecode(response.body);
    WeatherFetched result;
    try {
      debugPrint('toto');
      result = WeatherFetched.fromJson(weatherData);
      result.parseResult(result);
    } catch (error) {
      throw Exception('Failed to load Weather Data.\n$error');
    }
    return result;
  } else {
    throw Exception('Failed to load Weather Data.\n');
  }
}

class Current extends StatelessWidget {
  final cityfinder.LocationSuggestion? location;
  final Map<String, WeatherFetched> cached;
  final void Function(WeatherFetched) save;

  const Current(
      {super.key,
      required this.location,
      required this.cached,
      required this.save});

  @override
  Widget build(BuildContext context) {
    if (location == null) return Container();
    String cacheKey =
        location!.latitude.toString() + location!.longitude.toString();
    debugPrint('Cache keys: ${cached.keys}');
    Future<WeatherFetched> weather;
    if (cached.containsKey(cacheKey)) {
      debugPrint('used cache');
      weather = Future.value(cached[cacheKey]);
    } else {
      debugPrint('fetched weather');
      weather = getWeather(location!.latitude, location!.longitude);
      weather.then((result) {
        save(result);
      }).onError((err, stackTrace) {
        debugPrint('$err');
      });
    }
    return FutureBuilder(
      future: weather,
      builder: (BuildContext context, AsyncSnapshot<WeatherFetched> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return Row(
            spacing: MediaQuery.of(context).size.width * 0.2,
            mainAxisAlignment: MainAxisAlignment.center,
            children: (snapshot.data!.current.entries).where((element) {
              return element.key != 'time' && element.key != 'interval';
            }).map((element) {
              return Flexible(
                child: Text(
                  element.value.toString(),
                  softWrap: true,
                  overflow: TextOverflow.clip,
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }
}

class Hourly extends StatelessWidget {
  final cityfinder.LocationSuggestion? location;
  final Map<String, WeatherFetched> cached;
  final void Function(WeatherFetched) save;

  const Hourly(
      {super.key,
      required this.location,
      required this.cached,
      required this.save});

  @override
  Widget build(BuildContext context) {
    if (location == null) return Container();
    String cacheKey =
        location!.latitude.toString() + location!.longitude.toString();
    Future<WeatherFetched> weather;
    if (cached.containsKey(cacheKey)) {
      weather = Future.value(cached[cacheKey]);
    } else {
      weather = getWeather(location!.latitude, location!.longitude);
    }

    return FutureBuilder(
      future: weather,
      builder: (BuildContext context, AsyncSnapshot<WeatherFetched> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  snapshot.data!.hourly['time'].length,
                  (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          snapshot.data!.hourly['time'][index].substring(
                              snapshot.data!.hourly['time'][index]
                                      .indexOf('T') +
                                  1),
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${snapshot.data!.hourly['temperature_2m'][index]}',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${snapshot.data!.hourly['wind_speed_10m'][index]}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class Daily extends StatelessWidget {
  final cityfinder.LocationSuggestion? location;
  final Map<String, WeatherFetched> cached;
  final void Function(WeatherFetched) save;

  const Daily(
      {super.key,
      required this.location,
      required this.cached,
      required this.save});

  @override
  Widget build(BuildContext context) {
    if (location == null) return Container();
    String cacheKey =
        location!.latitude.toString() + location!.longitude.toString();
    Future<WeatherFetched> weather;
    if (cached.containsKey(cacheKey)) {
      weather = Future.value(cached[cacheKey]);
    } else {
      weather = getWeather(location!.latitude, location!.longitude);
    }

    return FutureBuilder(
      future: weather,
      builder: (BuildContext context, AsyncSnapshot<WeatherFetched> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  snapshot.data!.daily['time'].length,
                  (index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          snapshot.data!.daily['time'][index],
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${snapshot.data!.daily['temperature_2m_min'][index]}',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(width: 10),
                        Text(
                          '${snapshot.data!.daily['temperature_2m_max'][index]}',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
