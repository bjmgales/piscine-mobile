import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationSuggestion {
  final String city;
  final String region;
  final String country;
  final double latitude;
  final double longitude;

  const LocationSuggestion(
      {required this.city,
      required this.region,
      required this.country,
      required this.latitude,
      required this.longitude});

  factory LocationSuggestion.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('name') &&
        json.containsKey('admin1') &&
        json.containsKey('country') &&
        json.containsKey('latitude') &&
        json.containsKey('longitude')) {
      return LocationSuggestion(
          city: json['name'],
          region: json['admin1'],
          country: json['country'],
          latitude: json['latitude'],
          longitude: json['longitude']);
    } else {
      throw ('Miss one or more entries.');
    }
  }
  @override
  String toString() {
    return 'LocationSuggestion(city: $city, region: $region, '
        'country: $country, latitude: $latitude, longitude: $longitude)';
  }
}

Future<List<LocationSuggestion>> suggestLocation(String searchQuery) async {
  if (searchQuery.length < 2) {
    throw Exception('Avoiding useless API call.');
  }
  final response =
      await http.get(Uri.parse('https://geocoding-api.open-meteo.com/v1/'
          'search?name=$searchQuery&count=7'
          '&language=en&format=json'));
  if (response.statusCode == 200) {
    Map<String, dynamic> suggestions = jsonDecode(response.body);
    List<LocationSuggestion> result = [];
    if (suggestions['results'] == null) {
      return result;
    }
    for (dynamic suggestion in suggestions['results']) {
      try {
        result.add(LocationSuggestion.fromJson(suggestion));
      } catch (error) {
        continue;
      }
    }
    return result;
  } else {
    throw Exception('Failed to load location suggestions.');
  }
}
