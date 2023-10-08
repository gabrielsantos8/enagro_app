class HealthPlanContractType {
  final int healthPlanContractTypeId;
  final String description;

  HealthPlanContractType(
      {required this.healthPlanContractTypeId, required this.description});

  factory HealthPlanContractType.fromMap(Map<String, dynamic> anml) {
    return HealthPlanContractType(
        healthPlanContractTypeId: anml['id'] ?? 0,
        description: anml['description'] ?? '');
  }

  static HealthPlanContractType getHealthPlanContractType(int id, String description) {
    Map<String, dynamic> mp = {"id": id, "description": description};
    return HealthPlanContractType.fromMap(mp);
  }
}
