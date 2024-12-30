import 'package:weather_proj/models/searchbar/coordinates.dart';
import 'package:weather_proj/models/searchbar/suggestion.dart';

class SuggestionList {
  final List<Suggestion> suggestion;
  const SuggestionList({required this.suggestion});

  factory SuggestionList.fromJson(List locationsJson) {
    final validLocations = locationsJson
        .where((location) =>
            location['name'] != null &&
            location['admin1'] != null &&
            location['country'] != null &&
            location['latitude'] != null &&
            location['longitude'] != null)
        .toList();
    final List<Suggestion> result = [];
    for (var i = 0; i < validLocations.length; i++) {
      final city = validLocations[i]['name'];
      final region = validLocations[i]['admin1'];
      final country = validLocations[i]['country'];
      final latitude = validLocations[i]['latitude'];
      final longitude = validLocations[i]['longitude'];
      result.add(Suggestion(
          city: city,
          region: region,
          country: country,
          coordinates: Coordinates(latitude: latitude, longitude: longitude)));
    }
    return SuggestionList(suggestion: result);
  }
}
