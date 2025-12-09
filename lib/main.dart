import 'package:flutter/material.dart';

import 'models/meal_record.dart';
import 'models/user_profile.dart';
import 'pages/add_meal_page.dart';
import 'pages/learning_page.dart';
import 'pages/overview_page.dart';
import 'pages/profile_setup_page.dart';
import 'services/local_storage_service.dart';

void main() {
  runApp(const HealthDietApp());
}

class HealthDietApp extends StatefulWidget {
  const HealthDietApp({super.key});

  @override
  State<HealthDietApp> createState() => _HealthDietAppState();
}

class _HealthDietAppState extends State<HealthDietApp> {
  final LocalStorageService _storage = LocalStorageService();

  bool _isLoading = true;
  UserProfile? _profile;
  List<MealRecord> _meals = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await _storage.loadUserProfile();
    final meals = await _storage.loadMeals();
    setState(() {
      _profile = profile;
      _meals = meals;
      _isLoading = false;
    });
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _storage.saveUserProfile(profile);
    setState(() {
      _profile = profile;
    });
  }

  Future<void> _addMeal(MealRecord meal) async {
    final updated = [..._meals, meal];
    await _storage.saveMeals(updated);
    setState(() {
      _meals = updated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Healthy Weight Loss Coach',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: _isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : _profile == null
              ? ProfileSetupPage(onProfileSaved: _saveProfile)
              : MainHomeShell(
                  profile: _profile!,
                  meals: _meals,
                  onAddMeal: _addMeal,
                ),
    );
  }
}

class MainHomeShell extends StatefulWidget {
  final UserProfile profile;
  final List<MealRecord> meals;
  final Future<void> Function(MealRecord) onAddMeal;

  const MainHomeShell({
    super.key,
    required this.profile,
    required this.meals,
    required this.onAddMeal,
  });

  @override
  State<MainHomeShell> createState() => _MainHomeShellState();
}

class _MainHomeShellState extends State<MainHomeShell> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      OverviewPage(profile: widget.profile, meals: widget.meals),
      AddMealPage(onMealSaved: (meal) async {
        await widget.onAddMeal(meal);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Meal record added')),
          );
        }
      }),
      LearningPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Weight Loss Coach'),
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.insights),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Log meal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
        ],
      ),
    );
  }
}
