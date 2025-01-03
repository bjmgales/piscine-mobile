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