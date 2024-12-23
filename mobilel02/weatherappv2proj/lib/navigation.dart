import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'city_finder.dart' as cityfinder;
import 'weather_result.dart' as weather;

class MyPageView extends StatefulWidget {
  final PageController pageController;
  final void Function(int index) onPageChanged;
  final String submittedSearch;
  final cityfinder.LocationSuggestion? location;
  const MyPageView(
      {super.key,
      required this.pageController,
      required this.onPageChanged,
      required this.submittedSearch,
      required this.location});

  @override
  State<MyPageView> createState() => _MyPageView();
}

class _MyPageView extends State<MyPageView> {
  Map<String, weather.WeatherFetched> cachedWeather = {};
  void saveWeather(weather.WeatherFetched weatherData) {
      cachedWeather.addAll({
        widget.location!.latitude.toString() +
            widget.location!.longitude.toString(): weatherData
    });
  }

  @override
  Widget build(BuildContext context) {


    var citySlider = widget.submittedSearch.isNotEmpty
        ? Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.grey,
              child: Row(children: [
                SizedBox(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: Marquee(
                    text: widget.submittedSearch,
                    style: TextStyle(fontSize: 25, color: Colors.white),
                    velocity: 50.0,
                    blankSpace: 30,
                    startPadding: 10.0,
                  ),
                ),
              ]),
            ))
        : null;

    return Column(
      children: [
        if (citySlider != null) Center(child: citySlider),
        Expanded(
          child: PageView(
            scrollBehavior: ScrollBehavior(),
            controller: widget.pageController,
            onPageChanged: widget.onPageChanged,
            children: [
              weather.Current(
                location: widget.location,
                cached: cachedWeather,
                save: saveWeather,
              ),
              weather.Hourly(
                location: widget.location,
                cached: cachedWeather,
                save: saveWeather,
              ),
              weather.Daily(
                location: widget.location,
                cached: cachedWeather,
                save: saveWeather,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class MyNavBar extends StatelessWidget {
  final double screenHeight;
  final int currentPageIndex;
  final Orientation orientation;
  final void Function(int index) changePage;
  final String submittedSearch;
  const MyNavBar(
      {super.key,
      required this.screenHeight,
      required this.currentPageIndex,
      required this.changePage,
      required this.orientation,
      required this.submittedSearch});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      indicatorColor: const Color.fromARGB(134, 179, 179, 179),
      shadowColor: Colors.black,
      indicatorShape:
          const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      selectedIndex: currentPageIndex,
      onDestinationSelected: changePage,
      destinations: <Widget>[
        NavigationDestination(
            icon: SvgPicture.asset(
              './assets/now.svg',
              width: 40,
              height: 40,
              alignment: Alignment.center,
            ),
            label: 'Currently',
            tooltip: 'Current Weather'),
        NavigationDestination(
            icon: SvgPicture.asset(
              './assets/day.svg',
              width: 40,
              height: 40,
              alignment: Alignment.center,
            ),
            label: 'Today',
            tooltip: 'Weather today'),
        NavigationDestination(
            icon: SvgPicture.asset(
              './assets/week.svg',
              width: 40,
              height: 40,
              alignment: Alignment.center,
            ),
            label: 'Weekly',
            tooltip: 'Weather this week')
      ],
      height: orientation == Orientation.portrait
          ? screenHeight * 0.08
          : screenHeight * 0.2,
    );
  }
}
