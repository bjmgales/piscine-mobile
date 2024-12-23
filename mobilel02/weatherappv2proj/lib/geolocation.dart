import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

Future<Position> determinePosition() async {
  bool isEnabled;
  LocationPermission permission;

  isEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission was denied.');
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permission was permanently denied. Cannot request for location.');
  }
  return await Geolocator.getCurrentPosition();
}

class City {
  final String city;
  final String region;
  final String countryCode;
  final double latitude;
  final double longitude;

  const City({
    required this.city,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.region
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'countryCode': String countryCode,
        'city': String city,
        'principalSubdivision': String region,
        'latitude': double latitude,
        'longitude': double longitude,
      } =>
        City(countryCode: countryCode, city: city, region: region,
        latitude: latitude, longitude: longitude),
      _ => throw const FormatException('Failed to load city.'),
    };
  }
}

Future<City> getCityFetchApi(Position position) async {
  final response = await http
      .get(Uri.parse('https://api-bdc.net/data/reverse-geocode-client?'
          'latitude=${position.latitude}&longitude=${position.longitude}'
          '&localityLanguage=en'));

  if (response.statusCode == 200) {
    return City.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    throw Exception('Failed to load City');
  }
}
