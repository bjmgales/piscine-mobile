import 'package:flutter/material.dart';
import 'package:weather_proj/models/current_weather.dart';
import 'package:weather_proj/models/daily_weather.dart';
import 'package:weather_proj/models/hourly_weather.dart';
import 'package:weather_proj/services/weather_service.dart';
import 'package:weather_proj/widgets/app_bar.dart';
import 'package:weather_proj/widgets/current.dart';
import 'package:weather_proj/widgets/daily.dart';
import 'package:weather_proj/widgets/hourly.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_proj/widgets/nav_bar.dart';
import 'geolocation.dart' as geoloc;
import 'city_finder.dart' as cityfinder;

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

  final PageController pageController = PageController();
  final SearchController searchController = SearchController();
  final WeatherService weatherService = WeatherService();

  Map<String, List<cityfinder.LocationSuggestion>> cachedSuggestions = {};
  cityfinder.LocationSuggestion? selectedLocation;
  CurrentWeather? currentWeather;
  HourlyWeather? hourlyWeather;
  DailyWeather? dailyWeather;

  void saveSuggestions(
      String query, List<cityfinder.LocationSuggestion> suggestions) {
    if (suggestions.isEmpty) return;
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
      if (index != null) {
        selectedLocation = cachedSuggestions[searchController.text]![index];
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(
            selectedLocation!.latitude, selectedLocation!.longitude);
      }
      if (cachedSuggestions.containsKey(searchController.text)) {
        selectedLocation = cachedSuggestions[searchController.text]!.first;
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(
            selectedLocation!.latitude, selectedLocation!.longitude);
      } else {
        searchController.text = newQuery;
      }
    });
    searchController.closeView(null);
  }

  void onGeoLocPressed() async {
    try {
      Position pos = await geoloc.determinePosition();
      debugPrint('$pos');
      try {
        geoloc.City location = await geoloc.getCityFetchApi(pos);
        setState(() {
          searchController.text = '${location.city}, ${location.region},'
              ' ${location.countryCode}';
        });
      } catch (error) {
        setState(() {
          searchController.text = "Error:$error";
        });
      }
    } catch (error) {
      setState(() {
        submittedSearch = error.toString();
      });
    }
  }

  void cleanSearch() {
    setState(() {
      searchController.text = '';
    });
  }

  void _processWeatherFetch(double latitude, double longitude) async {
    final weather = await weatherService.getWeather(latitude, longitude);
    setState(() {
      currentWeather = weather.currentWeather;
      hourlyWeather = weather.hourlyWeather;
      dailyWeather = weather.dailyWeather;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    Orientation orientation = MediaQuery.of(context).orientation;

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
          ),
          body: PageView(
            controller: pageController,
            onPageChanged: onPageChanged,
            children: [
              currentWeather == null
                  ? Text("Enter a city")
                  : Current(
                      currentWeather: currentWeather!,
                    ),
              hourlyWeather == null
                  ? Text("Enter a city")
                  : Hourly(
                      hourlyWeather: hourlyWeather!,
                    ),
              dailyWeather == null
                  ? Text("Enter a city")
                  : Daily(
                      dailyWeather: dailyWeather!,
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
