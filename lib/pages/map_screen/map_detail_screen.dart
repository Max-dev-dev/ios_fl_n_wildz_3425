// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/map_place_cubit/map_place_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/map_place_model.dart';
import 'package:carousel_slider/carousel_slider.dart';

class MapPlaceDetailScreen extends StatefulWidget {
  final MapPlaceModel place;

  const MapPlaceDetailScreen({super.key, required this.place});

  @override
  State<MapPlaceDetailScreen> createState() => _MapPlaceDetailScreenState();
}

class _MapPlaceDetailScreenState extends State<MapPlaceDetailScreen> {
  int _currentIndex = 0;

  final weatherOptions = [
    {'emoji': '🌤', 'label': 'Sunny'},
    {'emoji': '🌧', 'label': 'Rain'},
    {'emoji': '⚡', 'label': 'Lightning'},
    {'emoji': '🌫', 'label': 'Fog'},
    {'emoji': '🌬', 'label': 'Wind'},
    {'emoji': '❄️', 'label': 'Snow'},
    {'emoji': '🌪', 'label': 'Hurricane'},
  ];

  String _getWeatherLabel(String label) {
    final match = weatherOptions.firstWhere(
      (element) => element['label'] == label,
      orElse: () => {'emoji': '', 'label': label},
    );
    return '${match['emoji']} ${match['label']}';
  }

  @override
  Widget build(BuildContext context) {
    final place = widget.place;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Row(
                        children: [
                          Icon(Icons.arrow_back_ios, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Back',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                if (place.photos.isNotEmpty) ...[
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      viewportFraction: 0.988,
                      onPageChanged: (index, reason) {
                        setState(() => _currentIndex = index);
                      },
                    ),
                    items:
                        place.photos.map((url) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.file(
                                File(url.path),
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      place.photos.length,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              index == _currentIndex
                                  ? Colors.yellow
                                  : Colors.white30,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                Text(
                  place.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Description',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  place.description,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(height: 20),
                _buildLabelValue(
                  'Coordinates',
                  '${place.latitude}, ${place.longitude}',
                ),
                _buildLabelValue(
                  'Weather conditions',
                  _getWeatherLabel(place.weather),
                ),
                const SizedBox(height: 32),
                GestureDetector(
                  onTap: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            backgroundColor: const Color(0xFF412786),
                            title: const Text(
                              'Are you sure?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            content: const Text(
                              'Are you sure you want to go out and delete it?',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, false),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xFF412786),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFF4141),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Delete',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                    );
                    if (confirmed == true) {
                      context.read<MapPlaceCubit>().deletePlace(place);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF4141),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(width: 8),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabelValue(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF5F3DBB),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
