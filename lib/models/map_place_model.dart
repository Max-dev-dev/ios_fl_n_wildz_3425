import 'dart:io';

class MapPlaceModel {
  final String name;
  final String description;
  final String latitude;
  final String longitude;
  final String weather;
  final List<File> photos;

  MapPlaceModel({
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.weather,
    required this.photos,
  });
}
