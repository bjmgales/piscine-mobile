import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class MyPageView extends StatelessWidget {
  final PageController pageController;
  final void Function(int index) onPageChanged;
  final String submittedSearch;

  const MyPageView(
      {super.key,
      required this.pageController,
      required this.onPageChanged,
      required this.submittedSearch});

    @override
  Widget build(BuildContext context) {
    return PageView(
      controller: pageController,
      onPageChanged: onPageChanged,
      children: [
        Center(
            child: Text(
          'Currently\n$submittedSearch',
          textAlign: TextAlign.center,
        )),
        Center(
            child: Text(
          'Today\n$submittedSearch',
          textAlign: TextAlign.center,
        )),
        Center(
            child: Text(
          'Weekly\n$submittedSearch',
          textAlign: TextAlign.center,
        ))
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
            label: 'Daily',
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
