class UserProfile {
  final double currentWeightKg;
  final double targetWeightKg;
  final int age;
  final double heightCm;
  final String gender; // 'male', 'female', or other description

  UserProfile({
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.age,
    required this.heightCm,
    required this.gender,
  });

  Map<String, dynamic> toJson() => {
        'currentWeightKg': currentWeightKg,
        'targetWeightKg': targetWeightKg,
        'age': age,
        'heightCm': heightCm,
        'gender': gender,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        currentWeightKg: (json['currentWeightKg'] as num).toDouble(),
        targetWeightKg: (json['targetWeightKg'] as num).toDouble(),
        age: json['age'] as int,
        heightCm: (json['heightCm'] as num).toDouble(),
        gender: json['gender'] as String,
      );
}
