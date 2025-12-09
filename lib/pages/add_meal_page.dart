import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/meal_record.dart';

class AddMealPage extends StatefulWidget {
  final void Function(MealRecord) onMealSaved;

  const AddMealPage({super.key, required this.onMealSaved});

  @override
  State<AddMealPage> createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _carbsController = TextEditingController();
  final _proteinController = TextEditingController();
  final _fatController = TextEditingController();

  MealType _mealType = MealType.breakfast;
  DateTime _timestamp = DateTime.now();
  String? _photoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _descriptionController.dispose();
    _caloriesController.dispose();
    _carbsController.dispose();
    _proteinController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source, imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _photoPath = pickedFile.path;
      });
    }
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _timestamp,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_timestamp),
    );
    if (time == null) return;
    setState(() {
      _timestamp = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String? _validateNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    try {
      double.parse(value);
    } catch (_) {
      return 'Invalid number format';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final meal = MealRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      description: _descriptionController.text.trim(),
      mealType: _mealType,
      timestamp: _timestamp,
      calories: double.parse(_caloriesController.text),
      carbs: double.parse(_carbsController.text),
      protein: double.parse(_proteinController.text),
      fat: double.parse(_fatController.text),
      photoPath: _photoPath,
    );

    widget.onMealSaved(meal);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Meal record saved')),
    );

    _formKey.currentState!.reset();
    setState(() {
      _mealType = MealType.breakfast;
      _timestamp = DateTime.now();
      _photoPath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _photoPath == null
                      ? const Icon(Icons.fastfood, size: 40)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            File(_photoPath!),
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => _pickImage(ImageSource.camera),
                            icon: const Icon(Icons.camera_alt),
                            label: const Text('Camera'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () => _pickImage(ImageSource.gallery),
                            icon: const Icon(Icons.photo_library),
                            label: const Text('Gallery'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Optional: take a photo or upload a food image',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Meal description',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Meal type',
                border: OutlineInputBorder(),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<MealType>(
                  value: _mealType,
                  items: const [
                    DropdownMenuItem(
                      value: MealType.breakfast,
                      child: Text('Breakfast'),
                    ),
                    DropdownMenuItem(
                      value: MealType.lunch,
                      child: Text('Lunch'),
                    ),
                    DropdownMenuItem(
                      value: MealType.dinner,
                      child: Text('Dinner'),
                    ),
                    DropdownMenuItem(
                      value: MealType.snack,
                      child: Text('Snack'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _mealType = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Time: ${_timestamp.year}-${_timestamp.month.toString().padLeft(2, '0')}-${_timestamp.day.toString().padLeft(2, '0')} '
                    '${_timestamp.hour.toString().padLeft(2, '0')}:${_timestamp.minute.toString().padLeft(2, '0')}',
                  ),
                ),
                TextButton.icon(
                  onPressed: _pickDateTime,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Change time'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _caloriesController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Calories (kcal)',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNumber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _carbsController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Carbs (g)',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _proteinController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Protein (g)',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNumber,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _fatController,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Fat (g)',
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text('Save this meal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
