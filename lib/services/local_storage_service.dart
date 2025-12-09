import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_profile.dart';
import '../models/meal_record.dart';

class LocalStorageService {
  static const _keyUserProfile = 'user_profile';
  static const _keyMeals = 'meals';

  Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  Future<UserProfile?> loadUserProfile() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_keyUserProfile);
    if (jsonString == null) return null;
    final Map<String, dynamic> map = json.decode(jsonString);
    return UserProfile.fromJson(map);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await _prefs;
    final jsonString = json.encode(profile.toJson());
    await prefs.setString(_keyUserProfile, jsonString);
  }

  Future<List<MealRecord>> loadMeals() async {
    final prefs = await _prefs;
    final jsonString = prefs.getString(_keyMeals);
    if (jsonString == null) return [];
    final List<dynamic> list = json.decode(jsonString) as List<dynamic>;
    return list
        .map((e) => MealRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMeals(List<MealRecord> meals) async {
    final prefs = await _prefs;
    final list = meals.map((e) => e.toJson()).toList();
    final jsonString = json.encode(list);
    await prefs.setString(_keyMeals, jsonString);
  }
}
