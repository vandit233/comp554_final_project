enum MealType { breakfast, lunch, dinner, snack }

class MealRecord {
  final String id;
  final String description;
  final MealType mealType;
  final DateTime timestamp;
  final double calories;
  final double carbs;
  final double protein;
  final double fat;
  final String? photoPath; // local file path from image picker

  MealRecord({
    required this.id,
    required this.description,
    required this.mealType,
    required this.timestamp,
    required this.calories,
    required this.carbs,
    required this.protein,
    required this.fat,
    this.photoPath,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'description': description,
        'mealType': mealType.name,
        'timestamp': timestamp.toIso8601String(),
        'calories': calories,
        'carbs': carbs,
        'protein': protein,
        'fat': fat,
        'photoPath': photoPath,
      };

  factory MealRecord.fromJson(Map<String, dynamic> json) => MealRecord(
        id: json['id'] as String,
        description: json['description'] as String,
        mealType: MealType.values.firstWhere(
          (m) => m.name == (json['mealType'] as String),
          orElse: () => MealType.breakfast,
        ),
        timestamp: DateTime.parse(json['timestamp'] as String),
        calories: (json['calories'] as num).toDouble(),
        carbs: (json['carbs'] as num).toDouble(),
        protein: (json['protein'] as num).toDouble(),
        fat: (json['fat'] as num).toDouble(),
        photoPath: json['photoPath'] as String?,
      );
}
