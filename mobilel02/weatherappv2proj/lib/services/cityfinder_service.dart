import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:weather_proj/models/searchbar/suggestion_list.dart';

Future<SuggestionList> suggestLocation(String searchQuery) async {
  if (searchQuery.length < 2) throw Exception('Avoiding useless API call.');

  final response =
      await http.get(Uri.parse('https://geocoding-api.open-meteo.com/v1/'
          'search?name=$searchQuery&count=7'
          '&language=en&format=json'));
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body)['results'];
    if (result == null) throw('No suggestions found');
      return SuggestionList.fromJson(result);
  }
  throw Exception('Failed to load location suggestions.');
}
