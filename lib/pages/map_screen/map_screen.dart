import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/map_screen/map_detail_screen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/map_place_cubit/map_place_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/map_place_model.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/map_screen/add_map_place_screen.dart';
import 'package:latlong2/latlong.dart';

final List<String> naturePromos = [
  'From serene forest trails to breathtaking ridge views, we invite you to explore the best nature spots. Tap on the markers to learn more and add your own hidden gems!',
  '🌲 Wander through the whispering pines of America\'s hidden forests and reconnect with nature\'s quiet magic.',
  '🏞️ Discover winding rivers, misty hills, and untouched valleys — the soul of wilderness awaits your steps.',
  '🍂 Whether chasing waterfalls or soaking in autumn foliage, these natural sanctuaries are made for wandering hearts.',
  '🌄 Let the sunrise greet you over the peaks of the Rockies and fill your lungs with the freedom of open air.',
  '🌾 Hear the wind sing across the Great Plains — vast, golden, and timelessly beautiful.',
  '🌊 From rugged coastlines to quiet lakeshores, each place on the map tells a story only nature could write.',
  '🦌 Follow the paths where deer tread lightly and the only sounds are birdsong and breeze.',
  '🌿 Escape into shaded glades and mossy trails where time slows and wonder grows.',
  '⛰️ America’s wild landscapes are calling — hike, breathe, and belong.',
  '🗻 Venture into Yosemite National Park and stand before towering granite cliffs and ancient sequoias.',
  '🦅 Lose yourself in the vast canyons of Zion and feel the power of nature carved over centuries.',
  '🍃 Explore Shenandoah’s Skyline Drive and witness the rolling blue ridges stretching to the horizon.',
  '🏜️ Walk the orange sands of Bryce Canyon and marvel at its cathedral-like hoodoos.',
  '🌋 Discover the mystic geysers and wildlife of Yellowstone — America’s first and wildest national park.',
  '🌲 Roam Olympic National Park where rainforest, mountain, and coast converge in magical harmony.',
  '🏖️ Relax along the sea-carved cliffs of Acadia National Park in coastal Maine.',
  '🌌 Camp beneath the darkest skies in Great Basin National Park and count stars by the thousands.',
  '🌅 Hike through the red rocks of Sedona, where desert energy meets ancient beauty.',
  '🌉 Explore Muir Woods near San Francisco — a peaceful sanctuary of towering redwoods just minutes from the city.',
  '🌴 Stroll through Everglades National Park and spot herons, alligators, and endless sawgrass wetlands.',
  '🧭 Let the serenity of the Blue Ridge Parkway guide your way through Appalachian beauty.',
];

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapPlaceModel? selected;

  void _showPlaceSheet(MapPlaceModel place) {
    showCupertinoModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBottomSheet(place),
    );
  }

  final random = (naturePromos..shuffle()).first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Trail map',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    height: 320,
                    width: double.infinity,
                    child: BlocBuilder<MapPlaceCubit, List<MapPlaceModel>>(
                      builder: (context, places) {
                        return FlutterMap(
                          options: MapOptions(
                            initialCenter: LatLng(
                              double.tryParse(places.first.latitude) ?? 0.0,
                              double.tryParse(places.first.longitude) ?? 0.0,
                            ),
                            initialZoom: 8,
                            onTap: (_, __) => setState(() => selected = null),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                              subdomains: const ['a', 'b', 'c'],
                              tileBuilder:
                                  (context, tileWidget, tile) => ColorFiltered(
                                    colorFilter: const ColorFilter.mode(
                                      Colors.deepPurpleAccent,
                                      BlendMode.modulate,
                                    ),
                                    child: tileWidget,
                                  ),
                            ),
                            MarkerLayer(
                              markers:
                                  places.map((place) {
                                    return Marker(
                                      point: LatLng(
                                        double.tryParse(place.latitude) ?? 0.0,
                                        double.tryParse(place.longitude) ?? 0.0,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: GestureDetector(
                                        onTap: () => _showPlaceSheet(place),
                                        child: const Icon(
                                          Icons.location_pin,
                                          size: 40,
                                          color: Colors.red,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6D42D8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '🌿 Discover Natural Wonders',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        random,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddMapPlaceScreen(),
                      ),
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
      ),
    );
  }

  Widget _buildBottomSheet(MapPlaceModel place) {
    return Material(
      color: const Color(0xFF5F3DBB),
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close, color: Colors.white),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MapPlaceDetailScreen(place: place),
                        ),
                      );
                    },
                    child: const Text(
                      'Go to card',
                      style: TextStyle(
                        color: Color(0xFFFEFE00),
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              place.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children:
                  place.photos
                      .map(
                        (url) => ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(url.path),
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 12),
            const Text(
              'Coordinates',
              style: TextStyle(color: Color(0xFFC8C9C7)),
            ),
            Text(
              '${place.latitude}, ${place.longitude}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Description',
              style: TextStyle(color: Color(0xFFC8C9C7)),
            ),
            Text(
              place.description,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
