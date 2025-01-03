import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../models/geolocation/city.dart';

Future<City> reverseGeocoder(Position position) async {
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