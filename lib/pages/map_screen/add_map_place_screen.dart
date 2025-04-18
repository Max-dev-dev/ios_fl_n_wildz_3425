import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/map_place_cubit/map_place_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/map_place_model.dart';

class AddMapPlaceScreen extends StatefulWidget {
  const AddMapPlaceScreen({super.key});

  @override
  State<AddMapPlaceScreen> createState() => _AddMapPlaceScreenState();
}

class _AddMapPlaceScreenState extends State<AddMapPlaceScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final latController = TextEditingController();
  final lngController = TextEditingController();
  String? selectedWeather;
  final List<File> photos = [];

  final weatherOptions = [
    {'emoji': '🌤', 'label': 'Sunny'},
    {'emoji': '🌧', 'label': 'Rain'},
    {'emoji': '⚡', 'label': 'Lightning'},
    {'emoji': '🌫', 'label': 'Fog'},
    {'emoji': '🌬', 'label': 'Wind'},
    {'emoji': '❄️', 'label': 'Snow'},
    {'emoji': '🌪', 'label': 'Hurricane'},
  ];

  Future<void> _pickFile() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && photos.length < 3) {
      setState(() => photos.add(File(picked.path)));
    }
  }

  bool get isValid =>
      nameController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      latController.text.isNotEmpty &&
      lngController.text.isNotEmpty;

  void _submit() {
    if (isValid) {
      final place = MapPlaceModel(
        name: nameController.text,
        description: descriptionController.text,
        latitude: latController.text,
        longitude: lngController.text,
        weather: selectedWeather ?? '',
        photos: photos,
      );
      context.read<MapPlaceCubit>().addPlace(place);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SafeArea(
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
                  TextButton(
                    onPressed: isValid ? _submit : null,
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color: isValid ? const Color(0xFFFEFE00) : Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Text(
                'Add place',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Center(
                child: Image.asset('assets/images/forest.png', width: 200),
              ),
              const SizedBox(height: 20),
              _buildTextField(nameController, 'Point name'),
              const SizedBox(height: 12),
              _buildTextField(
                descriptionController,
                'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildTextField(latController, 'Latitude'),
              const SizedBox(height: 12),
              _buildTextField(lngController, 'Longitude'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              const SizedBox(height: 12),
              const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ...photos
                      .map(
                        (f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.file(
                              f,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  if (photos.length < 3)
                    GestureDetector(
                      onTap: _pickFile,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFEFE00),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Color(0xFF412786)),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Weather conditions',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children:
                    weatherOptions.map((weather) {
                      final label = weather['label']!;
                      final emoji = weather['emoji']!;
                      final selected = selectedWeather == label;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedWeather = selected ? null : label;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                selected
                                    ? const Color(0xFFFEFE00)
                                    : const Color(0xFF5F3DBB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$emoji $label',
                            style: TextStyle(
                              color: selected ? Colors.black : Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: const Color(0xFF5F3DBB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 2),
        ),
      ),
    );
  }
}
