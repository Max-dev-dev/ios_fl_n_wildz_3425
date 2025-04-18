import 'dart:io';

class PlaceModel {
  final String name;
  final String description;
  final String coordinates;
  final String weather;
  final List<File> photos;
  final List<File> colors;
  final List<File> textures;
  final List<File> naturalObjects;
  final String landscapeType;

  PlaceModel({
    required this.name,
    required this.description,
    required this.coordinates,
    required this.weather,
    required this.photos,
    required this.colors,
    required this.textures,
    required this.naturalObjects,
    required this.landscapeType,
  });
}