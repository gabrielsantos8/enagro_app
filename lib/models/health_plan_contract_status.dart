class HealthPlanContractStatus {
  final int healthPlanContractStatusId;
  final String description;

  HealthPlanContractStatus(
      {required this.healthPlanContractStatusId, required this.description});

  factory HealthPlanContractStatus.fromMap(Map<String, dynamic> anml) {
    return HealthPlanContractStatus(
        healthPlanContractStatusId: anml['id'] ?? 0,
        description: anml['description'] ?? '');
  }

  static HealthPlanContractStatus getHealthPlanContractStatus(
      int id, String description) {
    Map<String, dynamic> mp = {"id": id, "description": description};
    return HealthPlanContractStatus.fromMap(mp);
  }
}
