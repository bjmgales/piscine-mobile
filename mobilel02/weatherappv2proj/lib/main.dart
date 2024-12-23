import 'package:flutter/material.dart';
import 'package:weather_proj/app_bar.dart';
import 'package:weather_proj/navigation.dart';
import 'package:geolocator/geolocator.dart';
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
  Map<String, List<cityfinder.LocationSuggestion>> cachedSuggestions = {};
  cityfinder.LocationSuggestion? selectedLocation;

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
      if (index != null){
        selectedLocation =
            cachedSuggestions[searchController.text]![index];
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
      }
      if (cachedSuggestions.containsKey(searchController.text)) {
        selectedLocation =
            cachedSuggestions[searchController.text]!.first;
        searchController.text = '${selectedLocation!.city}, '
            '${selectedLocation!.region}, '
            '${selectedLocation!.country}';
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
          body: MyPageView(
            pageController: pageController,
            onPageChanged: onPageChanged,
            submittedSearch: searchController.text,
            location:selectedLocation ?? null,
          ),
          bottomNavigationBar: MyNavBar(
              screenHeight: screenHeight,
              changePage: onDestinationSelected,
              currentPageIndex: currentPageIndex,
              submittedSearch: submittedSearch,
              orientation: orientation)),
    );
  }
}
