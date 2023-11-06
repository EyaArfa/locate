import 'dart:io';

class Position {
  final int? id;
  final String notes;
  final double longitude, latitude;
  Position(
      {required this.notes,
      required this.latitude,
      required this.longitude,
      this.id});
  Position.fromMap(Map<String, dynamic> json)
      : id = json['id'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        notes = json['description'];
}
