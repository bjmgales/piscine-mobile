import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/searchbar/suggestion_list.dart';

Future<SuggestionList> suggestLocation(String searchQuery) async {
  if (searchQuery.length < 2) throw Exception('Avoiding useless API call.');

  final response =
      await http.get(Uri.parse('https://geocoding-api.open-meteo.com/v1/'
          'search?name=$searchQuery&count=5'
          '&language=en&format=json')).timeout(Duration(seconds: 10), onTimeout: () {
      throw TimeoutException('The connection has timed out, please try again later.');
    });
  if (response.statusCode == 200) {
    final result = jsonDecode(response.body)['results'];
    if (result == null) throw('No suggestions found');
      return SuggestionList.fromJson(result);
  }
  debugPrint('${response.statusCode}');

  throw Exception('Failed to load location suggestions.');
}
