class HealthPlan {
  final int healthPlanId;
  final String description;
  final String detailedDescription;
  final double value;
  final int minimalAnimals;
  final int maximumAnimals;
  final List planColors;

  HealthPlan(
      {required this.healthPlanId,
      required this.description,
      required this.detailedDescription,
      required this.value,
      required this.minimalAnimals,
      required this.maximumAnimals,
      required this.planColors});

  factory HealthPlan.fromMap(Map<String, dynamic> healthPlan) {
    return HealthPlan(
      healthPlanId: healthPlan['id'] ?? 0,
      description: healthPlan['description'] ?? '',
      detailedDescription: healthPlan['detailed_description'] ?? '',
      value: double.parse(healthPlan['value'] != null ? healthPlan['value'].toString() : 0.0.toString()),
      minimalAnimals: healthPlan['minimal_animals'] ?? 0,
      maximumAnimals: healthPlan['maximum_animals'] ?? 0,
      planColors: healthPlan['plan_colors'].split(',') ?? ['ff004400','ff00FF00'],
    );
  }

  static HealthPlan getHealthPlan(
      int id,
      String description,
      String detailedDescription,
      double value,
      int minimalAnimals,
      int maximumAnimals,
      String planColors) {
    Map<String, dynamic> mp = {
      "id": id,
      "description": description,
      "detailed_description": detailedDescription,
      "value": value,
      "minimal_animals": minimalAnimals,
      "maximum_animals": maximumAnimals,
      "plan_colors": planColors
    };
    HealthPlan healthPlan = HealthPlan.fromMap(mp);
    return healthPlan;
  }
}
