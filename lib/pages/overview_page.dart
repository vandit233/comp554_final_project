import 'package:flutter/material.dart';

import '../models/meal_record.dart';
import '../models/user_profile.dart';

class OverviewPage extends StatelessWidget {
  final UserProfile profile;
  final List<MealRecord> meals;

  const OverviewPage({
    super.key,
    required this.profile,
    required this.meals,
  });

  List<MealRecord> get _todayMeals {
    final now = DateTime.now();
    return meals.where((m) {
      return m.timestamp.year == now.year &&
          m.timestamp.month == now.month &&
          m.timestamp.day == now.day;
    }).toList();
  }

  Map<DateTime, double> get _weeklyCaloriesByDay {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    final Map<DateTime, double> map = {};
    for (var i = 0; i < 7; i++) {
      final day = DateTime(start.year, start.month, start.day + i);
      map[day] = 0;
    }
    for (final meal in meals) {
      final day = DateTime(meal.timestamp.year, meal.timestamp.month,
          meal.timestamp.day);
      if (!day.isBefore(start) && !day.isAfter(now)) {
        map[day] = (map[day] ?? 0) + meal.calories;
      }
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final todayCalories =
        _todayMeals.fold<double>(0, (sum, m) => sum + m.calories);
    final todayCarbs = _todayMeals.fold<double>(0, (sum, m) => sum + m.carbs);
    final todayProtein =
        _todayMeals.fold<double>(0, (sum, m) => sum + m.protein);
    final todayFat = _todayMeals.fold<double>(0, (sum, m) => sum + m.fat);

    final weeklyTotal =
      _weeklyCaloriesByDay.values.fold<double>(0, (sum, c) => sum + c);

    // Convert stored metric values to imperial for display.
    final currentWeightLbs = profile.currentWeightKg * 2.20462;
    final targetWeightLbs = profile.targetWeightKg * 2.20462;
    final weightDiffLbs = currentWeightLbs - targetWeightLbs;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Weight goal progress',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Current weight: ${currentWeightLbs.toStringAsFixed(1)} lb',
                ),
                Text(
                  'Target weight: ${targetWeightLbs.toStringAsFixed(1)} lb',
                ),
                Text('Weight to lose: ${weightDiffLbs.toStringAsFixed(1)} lb'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Today\'s nutrition summary',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Total calories: ${todayCalories.toStringAsFixed(0)} kcal'),
                Text('Carbs: ${todayCarbs.toStringAsFixed(1)} g'),
                Text('Protein: ${todayProtein.toStringAsFixed(1)} g'),
                Text('Fat: ${todayFat.toStringAsFixed(1)} g'),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Last 7 days calorie trend',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Total calories in last 7 days: ${weeklyTotal.toStringAsFixed(0)} kcal'),
                const SizedBox(height: 8),
                Column(
                  children: _weeklyCaloriesByDay.entries.map((entry) {
                    final date = entry.key;
                    final calories = entry.value;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: Text(
                              '${date.month}/${date.day}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: weeklyTotal == 0
                                  ? 0
                                  : (calories / (weeklyTotal / 2)).clamp(0.0, 1.0),
                            ),
                          ),
                          const SizedBox(width: 8),
                          SizedBox(
                            width: 60,
                            child: Text(
                              '${calories.toStringAsFixed(0)} kcal',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
