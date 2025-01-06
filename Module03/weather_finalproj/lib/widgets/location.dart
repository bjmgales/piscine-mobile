import 'package:flutter/material.dart';
import 'package:weather_proj/models/searchbar/suggestion.dart';

class Location extends StatelessWidget {
  final Suggestion location;

  const Location({super.key, required this.location});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          location.city,
          style: TextStyle(color: Colors.orangeAccent, fontSize: 25),
          textAlign: TextAlign.center,
        ),
        Text(
          location.region,
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        Text(
          location.country,
          style: TextStyle(color: Colors.lightBlueAccent),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
