import 'dart:ffi';
import 'dart:io';

class Position {
  final String? id;
  final String notes;
  final double longitude, latitude;
  Position(
      {required this.notes,
      required this.latitude,
      required this.longitude,
      this.id});
  Position.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        latitude = double.parse(json['latitude']),
        longitude = double.parse(json['longitude']),
        notes = json['description'];
  Map<String, dynamic> toJSON() {
    Map<String, dynamic> map = {};
    map.addAll({
      'description': notes,
      'longitude': longitude,
      'latitude': latitude,
    });
    return map;
  }
}
