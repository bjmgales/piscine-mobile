import 'package:flutter/material.dart';
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
      if (index != null) {
        selectedLocation =
            cachedSuggestions[searchController.text]!.suggestion[index];
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(selectedLocation!.coordinates.latitude,
            selectedLocation!.coordinates.longitude);
      }
      if (cachedSuggestions.containsKey(searchController.text)) {
        selectedLocation =
            cachedSuggestions[searchController.text]!.suggestion[0];
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
        _processWeatherFetch(selectedLocation!.coordinates.latitude,
            selectedLocation!.coordinates.longitude);
      } else {
        searchController.text = newQuery;
      }
    });
    searchController.closeView(null);
  }

  void onGeoLocPressed() async {
    try {
      Position pos = await determinePosition();
      debugPrint('$pos');
      try {
        City location = await reverseGeocoder(pos);
        setState(() {
          searchController.text = '${location.city}, ${location.region},'
              ' ${location.countryCode}';
          _processWeatherFetch(location.latitude, location.longitude);
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
    var citySlider = Align(
        alignment: Alignment.topCenter,
        child: Container(
          color: Colors.grey,
          child: Row(children: [
            SizedBox(
              height: 50,
              width: screenWidth,
              child: Marquee(
                text: searchController.text.isEmpty
                    ? "Please provide location..."
                    : searchController.text,
                style: TextStyle(fontSize: 25, color: Colors.white),
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
          ),
          body: Stack(
            children: [
              citySlider,
              PageView(
                controller: pageController,
                onPageChanged: onPageChanged,
                children: [
                  currentWeather == null
                      ? Center(child: Text("Please provide location."))
                      : Current(
                          currentWeather: currentWeather!,
                        ),
                  hourlyWeather == null
                      ? Center(child: Text("Please provide location."))
                      : Hourly(
                          hourlyWeather: hourlyWeather!,
                        ),
                  dailyWeather == null
                      ? Center(child: Text("Please provide location."))
                      : Daily(
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
