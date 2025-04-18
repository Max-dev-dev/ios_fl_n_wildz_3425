import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/places_cubit/places_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/place_model.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/places/add_place_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/places/place_detail_screen.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  final weatherOptions = const [
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
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Atmospheric profiles of locations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<PlaceCubit, List<PlaceModel>>(
                  builder: (context, places) {
                    if (places.isEmpty) {
                      return _buildEmpty();
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8,
                          ),
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => PlaceDetailScreen(place: place),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Stack(
                                  children: [
                                    Image.file(
                                      place.photos.first,
                                      width: double.infinity,
                                      height: 140,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C57F4),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Text(
                                          _getWeatherLabel(place.weather),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                place.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AddPlaceScreen()),
                  );
                },
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEFE00),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF5F3DBB),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'Add place',
                          style: TextStyle(
                            color: Color(0xFF412786),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
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
    );
  }

  Widget _buildEmpty() {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/forest_line.png', width: 250, height: 250),
          const SizedBox(height: 20),
          const Text(
            "You don't have any seats added yet",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
