import 'package:flutter/material.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/clothes_list/add_clothes_item_screen.dart';

class ClothesItem {
  final String category;
  final String title;
  final String description;

  ClothesItem({
    required this.category,
    required this.title,
    required this.description,
  });
}

class ClothesListScreen extends StatefulWidget {
  const ClothesListScreen({super.key});

  @override
  State<ClothesListScreen> createState() => _ClothesListScreenState();
}

class _ClothesListScreenState extends State<ClothesListScreen> {
  String? selectedType;

  final Map<String, List<ClothesItem>> clothesByNature = {
    'Forest': [
      ClothesItem(
        category: 'Clothes',
        title: 'Windproof jacket (khaki/green shades)',
        description: 'Provides camouflage and protection from wind.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Replacement socks (2–3 pairs)',
        description:
            'Wet moss underfoot – take socks with silver for antibacterial protection.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Long-sleeve shirt',
        description: 'For insect protection and layering.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Mosquito net hat',
        description: 'Protection from insects in humid woods.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Thermal undershirt',
        description: 'Useful in cooler forest climates.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Gaiters',
        description: 'To keep debris out of your shoes.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Fingerless gloves',
        description: 'Protection while climbing or navigating branches.',
      ),
    ],
    'Coast': [
      ClothesItem(
        category: 'Clothes',
        title: 'UV-protective hat',
        description: 'Protects head and face from sunburn.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Light hoodie or windbreaker',
        description: 'Shields from sea wind and sun.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Quick-dry shorts',
        description: 'Comfortable and dries fast after sea breeze.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Flip-flops or water shoes',
        description: 'Protect feet from sharp shells or rocks.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Cotton T-shirt',
        description: 'Breathable and perfect for coastal weather.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Swimwear',
        description: 'Ideal for spontaneous dips in the sea.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Light scarf or buff',
        description: 'Shields neck from wind or sun.',
      ),
    ],
    'Ridge': [
      ClothesItem(
        category: 'Clothes',
        title: 'Insulated jacket',
        description: 'Protects from cold at higher altitudes.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Thermal base layer',
        description: 'Essential for warmth during hikes.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'High-ankle boots',
        description: 'Support and grip on rocky ridges.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Beanie',
        description: 'Prevents heat loss through head.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Convertible hiking pants',
        description: 'Versatile for changing ridge temperatures.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Windproof gloves',
        description: 'Protects hands from cold gusts.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Neck gaiter',
        description: 'Keeps neck warm during rapid weather shifts.',
      ),
    ],
    'Steppe': [
      ClothesItem(
        category: 'Clothes',
        title: 'Wide-brimmed hat',
        description: 'Shields from sun in open landscapes.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Loose cotton shirt',
        description: 'Breathable protection in dry heat.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Sunglasses with UV protection',
        description: 'Eyeshield against intense steppe sunlight.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Light trousers',
        description: 'Prevents scratches from grasses and shrubs.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Light scarf or shemagh',
        description: 'Protects from dust and sun.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Trail shoes',
        description: 'Comfortable for long distances on flat land.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Wristband with sweat absorption',
        description: 'Useful in hot, arid climates.',
      ),
    ],
    'Rainy Zone': [
      ClothesItem(
        category: 'Clothes',
        title: 'Rain poncho or raincoat',
        description: 'Essential in persistent wet weather.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Waterproof pants',
        description: 'Keeps your legs dry in constant rain.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Rubber boots',
        description: 'Helps walk through puddles and muddy paths.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Quick-dry underwear',
        description: 'Comfort during damp conditions.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Synthetic fleece',
        description: 'Warm even when damp.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Waterproof hat',
        description: 'Keeps rain off your face and glasses.',
      ),
      ClothesItem(
        category: 'Clothes',
        title: 'Dry bag for clothes',
        description: 'To store dry layers in heavy rain.',
      ),
    ],
  };

  final Map<String, String> icons = {
    'Forest': '🌲',
    'Coast': '🏖️',
    'Ridge': '⛰️',
    'Steppe': '🌾',
    'Rainy Zone': '🌧️',
  };

  void _openAddItemScreen() {
    if (selectedType == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => AddClothesItemScreen(
              category: 'Clothes',
              onSave: (title, description) {
                setState(() {
                  clothesByNature[selectedType!]!.add(
                    ClothesItem(
                      category: 'Clothes',
                      title: title,
                      description: description,
                    ),
                  );
                });
              },
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> types = clothesByNature.keys.toList();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'List',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: selectedType != null ? _openAddItemScreen : null,
                    child: Container(
                      padding: EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        color: Color(0xFF6F47DF),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Icon(Icons.add, color: Color(0xFFFEFE00)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Landscape type',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children:
                    types.map((type) {
                      final isSelected = type == selectedType;
                      return GestureDetector(
                        onTap: () => setState(() => selectedType = type),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFFFEFE00)
                                    : const Color(0xFF5E3DB8),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${icons[type]} $type',
                            style: TextStyle(
                              fontSize: 14.0,
                              color:
                                  isSelected
                                      ? const Color(0xFF5F3DBB)
                                      : Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
              ),
              const SizedBox(height: 20),
              Expanded(
                child:
                    selectedType == null
                        ? Center(
                          child: Image.asset(
                            'assets/images/forest.png',
                            width: 240,
                          ),
                        )
                        : ListView(
                          children:
                              clothesByNature[selectedType]!.map((item) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6F47DF),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF7C57F4),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          item.category,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (item.description.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: Text(
                                            item.description,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
