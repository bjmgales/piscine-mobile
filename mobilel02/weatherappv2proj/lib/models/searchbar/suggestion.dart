import 'package:weather_proj/models/searchbar/coordinates.dart';

class Suggestion {
  final String city;
  final String region;
  final String country;
  final Coordinates coordinates;

  Suggestion(
      {required this.city,
      required this.region,
      required this.country,
      required this.coordinates,
    });
}
