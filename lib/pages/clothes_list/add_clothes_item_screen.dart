import 'package:flutter/material.dart';

class AddClothesItemScreen extends StatefulWidget {
  final String category;
  final Function(String title, String description) onSave;

  const AddClothesItemScreen({
    super.key,
    required this.category,
    required this.onSave,
  });

  @override
  State<AddClothesItemScreen> createState() => _AddClothesItemScreenState();
}

class _AddClothesItemScreenState extends State<AddClothesItemScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool get isDoneEnabled => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white60),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.transparent),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.white),
      ),
      filled: true,
      fillColor: const Color(0xFF5E3DB8),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  GestureDetector(
                    onTap:
                        isDoneEnabled
                            ? () {
                              widget.onSave(
                                _titleController.text.trim(),
                                _descriptionController.text.trim(),
                              );
                              Navigator.pop(context);
                            }
                            : null,
                    child: Text(
                      'Done',
                      style: TextStyle(
                        color:
                            isDoneEnabled
                                ? const Color(0xFFFEFE00)
                                : Colors.white38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Add item',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              TextField(
                controller: _titleController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Name'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _descriptionController,
                cursorColor: Colors.white,
                style: const TextStyle(color: Colors.white),
                maxLines: 4,
                decoration: _inputDecoration('Description (optional)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
