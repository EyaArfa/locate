import 'package:geolocator/geolocator.dart';

Future<Position> determinePosition() async {
  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  var result = await Geolocator.getCurrentPosition().then((value) => value);
  return result;
}