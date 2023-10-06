import 'package:enagro_app/models/service.dart';

class HealthPlan {
  final int healthPlanId;
  final String description;
  final String detailedDescription;
  final double value;
  final int minimalAnimals;
  final int maximumAnimals;
  final List<Service> services;
  final List<String> planColors;

  HealthPlan(
      {required this.healthPlanId,
      required this.description,
      required this.detailedDescription,
      required this.value,
      required this.minimalAnimals,
      required this.maximumAnimals,
      required this.services,
      required this.planColors});

  factory HealthPlan.fromMap(Map<String, dynamic> healthPlan) {
    return HealthPlan(
      healthPlanId: healthPlan['id'] ?? 0,
      description: healthPlan['description'] ?? '',
      detailedDescription: healthPlan['detailed_description'] ?? '',
      value: double.parse(healthPlan['value'] != null ? healthPlan['value'].toString() : 0.0.toString()),
      minimalAnimals: healthPlan['minimal_animals'] ?? 0,
      maximumAnimals: healthPlan['maximum_animals'] ?? 0,
      services: Service.getServices(healthPlan['services']),
      planColors: healthPlan['plan_colors'].split(',') ?? ['ff00b200','ff00b200'],
    );
  }

  static HealthPlan getHealthPlan(
      int id,
      String description,
      String detailedDescription,
      double value,
      int minimalAnimals,
      int maximumAnimals,
      List services,
      String planColors) {
    Map<String, dynamic> mp = {
      "id": id,
      "description": description,
      "detailed_description": detailedDescription,
      "value": value,
      "minimal_animals": minimalAnimals,
      "maximum_animals": maximumAnimals,
      "services": services,
      "plan_colors": planColors
    };
    HealthPlan healthPlan = HealthPlan.fromMap(mp);
    return healthPlan;
  }
}
