import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/clothes_list/clothes_list_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/game/game_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/map_screen/map_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/places/places_screen.dart';
import 'package:ios_fl_n_wildatlas_3425/pages/settings/settings_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    MapScreen(),
    PlacesScreen(),
    GameScreen(),
    ClothesListScreen(),
    SettingsScreen(),
  ];

  final List<IconData> _icons = [
    FontAwesomeIcons.map,
    FontAwesomeIcons.locationDot,
    FontAwesomeIcons.gamepad,
    FontAwesomeIcons.list,
    FontAwesomeIcons.gear,
  ];

  final List<String> _labels = ['Map', 'Places', 'Game', 'List', 'Settings'];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        height: 90,
        decoration: const BoxDecoration(
          color: Color(0xFF5B2BBC),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (index) {
            final bool isSelected = _selectedIndex == index;
            return GestureDetector(
              onTap: () => _onTabTapped(index),
              behavior: HitTestBehavior.translucent,
              child: SizedBox(
                width: 60,
                height: 90,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      _icons[index],
                      color: isSelected ? Colors.white : Colors.white54,
                      size: 24,
                    ),
                    const SizedBox(height: 6),
                    if (isSelected)
                      Text(
                        _labels[index],
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white54,
                          fontSize: 12,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (isSelected)
                      Container(
                        height: 4,
                        width: 24,
                        margin: const EdgeInsets.only(bottom: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
