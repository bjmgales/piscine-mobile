import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class NavBar extends StatelessWidget {
  final double screenHeight;
  final int currentPageIndex;
  final Orientation orientation;
  final void Function(int index) changePage;
  final String submittedSearch;
  const NavBar(
      {super.key,
      required this.screenHeight,
      required this.currentPageIndex,
      required this.changePage,
      required this.orientation,
      required this.submittedSearch});
  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(color: Colors.orange);
            }
            return TextStyle(color: Colors.white);
          },
        ),
        indicatorColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      child: NavigationBar(
        // labelBehavior: ,
        selectedIndex: currentPageIndex,
        onDestinationSelected: changePage,
        destinations: <Widget>[
          NavigationDestination(
              icon: Icon(Icons.arrow_circle_down_sharp),
              selectedIcon: Icon(
                Icons.arrow_circle_down_sharp,
                color: Colors.orange,
              ),
              label: 'Currently',
              tooltip: 'Current Weather'),
          NavigationDestination(
              icon: Icon(Icons.today),
              selectedIcon: Icon(
                Icons.today,
                color: Colors.orange,
              ),
              label: 'Today',
              tooltip: 'Weather today'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month),
              selectedIcon:  Icon(Icons.calendar_month, color: Colors.orange,),
              label: 'Weekly',
              tooltip: 'Weather this week')
        ],
        height: orientation == Orientation.portrait
            ? screenHeight * 0.08
            : screenHeight * 0.2,
      ),
    );
  }
}
