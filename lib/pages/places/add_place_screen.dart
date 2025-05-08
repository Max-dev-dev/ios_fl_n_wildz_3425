// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ios_fl_n_wildatlas_3425/cubit/places_cubit/places_cubit.dart';
import 'package:ios_fl_n_wildatlas_3425/models/place_model.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final coordController = TextEditingController();
  String? selectedWeather;
  final List<File> photos = [];
  final List<File> colors = [];
  final List<File> textures = [];
  final List<File> naturalObjects = [];
  String? selectedLandscape;

  final weatherOptions = [
    {'emoji': '🌤', 'label': 'Sunny'},
    {'emoji': '🌧', 'label': 'Rain'},
    {'emoji': '⚡', 'label': 'Lightning'},
    {'emoji': '🌫', 'label': 'Fog'},
    {'emoji': '🌬', 'label': 'Wind'},
    {'emoji': '❄️', 'label': 'Snow'},
    {'emoji': '🌪', 'label': 'Hurricane'},
  ];

  final Map<String, String> landscapeIcons = {
    'Forest': '🌳',
    'Plain': '🌾',
    'Shore': '🏖️',
    'Ridge': '⛰️',
    'Open terrain': '🏞️',
  };

  Future<void> _pickFile(List<File> targetList) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null && targetList.length < 3) {
      setState(() => targetList.add(File(picked.path)));
    }
  }

  bool get isValid =>
      nameController.text.isNotEmpty &&
      descriptionController.text.isNotEmpty &&
      coordController.text.isNotEmpty;

  void _submit() {
    if (isValid) {
      final place = PlaceModel(
        name: nameController.text,
        description: descriptionController.text,
        coordinates: coordController.text,
        weather: selectedWeather ?? '',
        photos: photos,
        colors: colors,
        textures: textures,
        naturalObjects: naturalObjects,
        landscapeType: selectedLandscape!,
      );
      context.read<PlaceCubit>().addPlace(place);
      Navigator.pop(context);
    }
  }

  Widget _buildImageRow(List<File> list, String label) {
    return Row(
      children: [
        ...list
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
        if (list.length < 3)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () => _pickFile(list),
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
          ),
      ],
    );
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
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Row(
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
                          color:
                              isValid ? const Color(0xFFFEFE00) : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
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
              _buildTextField(nameController, 'Location Name'),
              const SizedBox(height: 12),
              _buildTextField(
                descriptionController,
                'Description',
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              _buildTextField(coordController, 'Coordinates'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              SizedBox(height: 12.0),
              const Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              _buildImageRow(photos, 'Photo'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
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
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              SizedBox(height: 12.0),
              const Text(
                'Color Palette (optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildImageRow(colors, 'Color'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              SizedBox(height: 12.0),
              const Text(
                'Texture (optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildImageRow(textures, 'Texture'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              SizedBox(height: 12.0),
              const Text(
                'Natural Object (optional)',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildImageRow(naturalObjects, 'Object'),
              const SizedBox(height: 12),
              Divider(color: Colors.white.withOpacity(0.20), height: 2),
              SizedBox(height: 12.0),
              const Text(
                'Landscape type',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12.0),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    landscapeIcons.entries.map((entry) {
                      final selected = selectedLandscape == entry.key;
                      return GestureDetector(
                        onTap:
                            () => setState(() => selectedLandscape = entry.key),
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
                            '${entry.value} ${entry.key}',
                            style: TextStyle(
                              color:
                                  selected
                                      ? const Color(0xFF412786)
                                      : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 12),
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
