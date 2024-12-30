import 'package:geolocator/geolocator.dart';

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