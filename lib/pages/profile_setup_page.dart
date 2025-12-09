import 'package:flutter/material.dart';

import '../models/user_profile.dart';

class ProfileSetupPage extends StatefulWidget {
  final void Function(UserProfile) onProfileSaved;

  const ProfileSetupPage({super.key, required this.onProfileSaved});

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final _formKey = GlobalKey<FormState>();

  final _currentWeightController = TextEditingController();
  final _targetWeightController = TextEditingController();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();

  String _gender = 'male';

  @override
  void dispose() {
    _currentWeightController.dispose();
    _targetWeightController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    // The UI uses imperial units (lb and inches). Convert to metric
    // before storing in the UserProfile model.
    final currentWeightLbs = double.parse(_currentWeightController.text);
    final targetWeightLbs = double.parse(_targetWeightController.text);
    final heightInches = double.parse(_heightController.text);

    if (targetWeightLbs >= currentWeightLbs) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Target weight must be lower than current weight.',
          ),
        ),
      );
      return;
    }

    final currentWeightKg = currentWeightLbs * 0.453592;
    final targetWeightKg = targetWeightLbs * 0.453592;
    final heightCm = heightInches * 2.54;

    final profile = UserProfile(
      currentWeightKg: currentWeightKg,
      targetWeightKg: targetWeightKg,
      age: int.parse(_ageController.text),
      heightCm: heightCm,
      gender: _gender,
    );

    widget.onProfileSaved(profile);
  }

  String? _validateNumber(String? value, {bool isInt = false}) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a value';
    }
    try {
      if (isInt) {
        int.parse(value);
      } else {
        double.parse(value);
      }
    } catch (_) {
      return 'Invalid number format';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Up Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fill in your basic info for personalized analysis.',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _currentWeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Current weight (lb)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _validateNumber(v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _targetWeightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Target weight (lb)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _validateNumber(v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _validateNumber(v, isInt: true),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _heightController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Height (inches)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => _validateNumber(v),
                ),
                const SizedBox(height: 12),
                InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _gender,
                      items: const [
                        DropdownMenuItem(
                          value: 'male',
                          child: Text('Male'),
                        ),
                        DropdownMenuItem(
                          value: 'female',
                          child: Text('Female'),
                        ),
                        DropdownMenuItem(
                          value: 'other',
                          child: Text('Other'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _gender = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Save and continue'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
