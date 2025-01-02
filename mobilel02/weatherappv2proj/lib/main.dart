import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:marquee/marquee.dart';
import 'package:weather_proj/models/geolocation/City.dart';
import 'package:weather_proj/models/weather/current_weather.dart';
import 'package:weather_proj/models/weather/daily/daily_weather.dart';
import 'package:weather_proj/models/weather/hourly/hourly_weather.dart';
import 'package:weather_proj/models/searchbar/suggestion.dart';
import 'package:weather_proj/models/searchbar/suggestion_list.dart';
import 'package:weather_proj/permissions/geolocation_permission.dart';
import 'package:weather_proj/services/geolocation_service.dart';
import 'package:weather_proj/services/weather_service.dart';
import 'package:weather_proj/widgets/app_bar.dart';
import 'package:weather_proj/widgets/current.dart';
import 'package:weather_proj/widgets/daily.dart';
import 'package:weather_proj/widgets/hourly.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_proj/widgets/nav_bar.dart';
import 'package:weather_proj/widgets/search_error_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentPageIndex = 0;
  String submittedSearch = '';
  String searchFieldUpdate = '';

  bool isGeoloc = false;
  bool isSubmit = false;
  bool isConnectionLost = false;

  final PageController pageController = PageController();
  final SearchController searchController = SearchController();
  final WeatherService weatherService = WeatherService();

  Map<String, SuggestionList> cachedSuggestions = {};
  Suggestion? selectedLocation;

  CurrentWeather? currentWeather;
  HourlyWeather? hourlyWeather;
  DailyWeather? dailyWeather;

  void saveSuggestions(String query, SuggestionList suggestions) {
    cachedSuggestions.addAll({query: suggestions});
  }

  void onDestinationSelected(int index) {
    setState(() {
      currentPageIndex = index;
      pageController.jumpToPage(currentPageIndex);
    });
  }

  void onPageChanged(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  void onLocationSubmitted(String newQuery, int? index) {
    setState(() {
      isSubmit = true;
      if (index != null) {
        selectedLocation =
            cachedSuggestions[searchController.text]!.suggestion[index];
        searchFieldUpdate = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(selectedLocation!.coordinates.latitude,
            selectedLocation!.coordinates.longitude);
      } else if (cachedSuggestions.containsKey(searchController.text)) {
        selectedLocation =
            cachedSuggestions[searchController.text]!.suggestion[0];

        searchFieldUpdate = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(selectedLocation!.coordinates.latitude,
            selectedLocation!.coordinates.longitude);
      } else {
        debugPrint('hedw');
        currentWeather = null;
        hourlyWeather = null;
        dailyWeather = null;
      }
    });
    searchController.closeView(null);
  }

  void onGeoLocPressed() async {
    try {
      isGeoloc = true;
      Position pos = await determinePosition();
      try {
        City location = await reverseGeocoder(pos);
        setState(() {
          searchFieldUpdate = '${location.city}, ${location.region},'
              ' ${location.countryCode}';
          _processWeatherFetch(location.latitude, location.longitude);
        });
      } catch (error) {
        if (error is http.ClientException || error is TimeoutException) {
          debugPrint('here');
          setConnectionLost();
        }
      }
    } catch (error) {
      setState(() {
        searchFieldUpdate =
            "Please allow geolocation or enter a location manually";
        currentWeather = null;
        hourlyWeather = null;
        dailyWeather = null;
      });
    }
  }

  void cleanSearch() {
    setState(() {
      searchController.text = '';
    });
  }

  void _processWeatherFetch(double latitude, double longitude) async {
    try {
      final weather = await weatherService.getWeather(latitude, longitude);
      setState(() {
        currentWeather = weather.currentWeather;
        hourlyWeather = weather.hourlyWeather;
        dailyWeather = weather.dailyWeather;
        isConnectionLost = false;
      });
    } catch (err) {
      setConnectionLost();
      currentWeather = null;
      hourlyWeather = null;
      dailyWeather = null;
    }
  }

  void setConnectionLost() {
    setState(() {
      isConnectionLost = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;
    final textDisplay = SearchError().evaluateContext(currentWeather,
        searchController.text, isSubmit, isGeoloc, isConnectionLost);
    isSubmit = false;
    isGeoloc = false;
    var citySlider = Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.grey,
          child: Row(children: [
            SizedBox(
              height: 50,
              width: screenWidth,
              child: Marquee(
                text: textDisplay.text ?? searchFieldUpdate,
                style: TextStyle(
                    fontSize: 25, color: textDisplay.color ?? Colors.white),
                velocity: 50.0,
                blankSpace: 30,
                startPadding: 10.0,
              ),
            ),
          ]),
        ));

    return MaterialApp(
      home: Scaffold(
          appBar: MyAppBar(
            screenWidth: screenWidth,
            searchController: searchController,
            submittedSearch: submittedSearch,
            onSubmitted: onLocationSubmitted,
            onPressed: onGeoLocPressed,
            saveSuggestions: saveSuggestions,
            cachedSuggestions: cachedSuggestions,
            setConnectionLost: setConnectionLost,
          ),
          body: Stack(
            children: [
              citySlider,
              PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  if (textDisplay.text != null || currentWeather == null)
                    Center(
                        child: Text(
                      textDisplay.text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textDisplay.color),
                    ))
                  else
                    Current(
                      currentWeather: currentWeather!,
                    ),
                  if (textDisplay.text != null || hourlyWeather == null)
                    Center(
                        child: Text(
                      textDisplay.text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: textDisplay.color),
                    ))
                  else
                    Hourly(
                      hourlyWeather: hourlyWeather!,
                    ),
                  if (textDisplay.text != null || dailyWeather == null)
                    Center(
                        child: Text(
                      textAlign: TextAlign.center,
                      textDisplay.text!,
                      style: TextStyle(color: textDisplay.color),
                    ))
                  else
                    Daily(
                      dailyWeather: dailyWeather!,
                    ),
                ],
              ),
            ],
          ),
          bottomNavigationBar: NavBar(
              screenHeight: screenHeight,
              changePage: onDestinationSelected,
              currentPageIndex: currentPageIndex,
              submittedSearch: submittedSearch,
              orientation: orientation)),
    );
  }
}
