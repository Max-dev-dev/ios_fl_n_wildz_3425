import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _unit = 'km';
  String _selectedTempUnit = 'km';

  bool isNotificationEnabled = true;
  bool isVibrationEnabled = true;

  void _openUnitSelectionSheet() {
    showMaterialModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF5B2BBC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder:
          (context) => StatefulBuilder(
            builder:
                (context, setModalState) => Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, color: Colors.white),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() => _unit = _selectedTempUnit);
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(
                                color:
                                    _selectedTempUnit != _unit
                                        ? const Color(0xFFFFFF00)
                                        : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Selecting units of measurement',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildOption('Kilometers', 'km', setModalState),
                      const SizedBox(height: 16),
                      _buildOption('Miles', 'mi', setModalState),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
          ),
    );
  }

  Widget _buildOption(
    String label,
    String value,
    void Function(void Function()) setModalState,
  ) {
    final bool isSelected = _selectedTempUnit == value;
    return GestureDetector(
      onTap: () {
        setModalState(() => _selectedTempUnit = value);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFFF00) : Colors.transparent,
          border: Border.all(color: Colors.white, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF412786) : Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildSettingTile(String label, VoidCallback onTap, {String? value}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF6D42D8),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              children: [
                if (value != null)
                  Text(
                    value,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                const Icon(Icons.chevron_right, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6D42D8),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFFFF00),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white30,
          ),
        ],
      ),
    );
  }

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
                  'Settings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/forest.png',
                    width: 210,
                    height: 210,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(height: 20),
                _buildSettingTile(
                  'Units of measurement',
                  _openUnitSelectionSheet,
                  value: _unit,
                ),
                _buildSwitchTile(
                  'Notification',
                  isNotificationEnabled,
                  (val) => setState(() => isNotificationEnabled = val),
                ),
                _buildSwitchTile(
                  'Vibration',
                  isVibrationEnabled,
                  (val) => setState(() => isVibrationEnabled = val),
                ),
                _buildSettingTile(
                  'Privacy Policy',
                  () => _launchUrl('https://www.termsfeed.com/live/14f765e8-cb29-41a5-acf4-a69e6b8588b0'),
                ),
                _buildSettingTile(
                  'Terms of use',
                  () => _launchUrl('https://www.termsfeed.com/live/1c1589fd-6655-461a-90dd-c5b4c423bb8f'),
                ),
                SizedBox(height: 10.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
