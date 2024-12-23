import 'package:flutter/material.dart';
import 'package:weather_proj/app_bar.dart';
import 'package:weather_proj/navigation.dart';

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
  String searchQuery = '';
  String submittedSearch = '';
  final PageController pageController = PageController();
  final TextEditingController searchController = TextEditingController();

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

  void onSubmitted(String searchQuery) {
    setState(() {
      submittedSearch = searchQuery;
      searchController.value = TextEditingValue.empty;
    });
  }

  void onPressed() {
    setState(() {
      submittedSearch = 'Geolocation';
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
            onSubmitted: onSubmitted,
            onPressed: onPressed,
          ),
          body: MyPageView(
            pageController: pageController,
            onPageChanged: onPageChanged,
            submittedSearch: submittedSearch,

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
