import 'package:enagro_app/models/health_plan.dart';
import 'package:enagro_app/models/health_plan_contract_status.dart';
import 'package:enagro_app/models/health_plan_contract_type.dart';

class HealthPlanContract {
  final int healthPlanContractId;
  final int userId;
  final HealthPlan healthPlan;
  final HealthPlanContractType healthPlanContractType;
  final double value;
  final HealthPlanContractStatus healthPlanContractStatus;

  HealthPlanContract(
      {required this.healthPlanContractId,
      required this.userId,
      required this.healthPlan,
      required this.healthPlanContractType,
      required this.value,
      required this.healthPlanContractStatus});

  factory HealthPlanContract.fromMap(Map<String, dynamic> contract) {
    return HealthPlanContract(
        healthPlanContractId: contract['id'] ?? 0,
        userId: contract['user_id'] ?? 0,
        healthPlan: HealthPlan.getHealthPlan(
            contract['health_plan_id'] ?? 0,
            contract['plan'] ?? '',
            contract['plan_detailed_description'] ?? '',
            contract['plan_value'] ?? 0.0,
            contract['plan_minimal_animals'] ?? 0,
            contract['plan_maximum_animals'] ?? 0,
            contract['plan_colors'] ?? ''),
        healthPlanContractType:
            HealthPlanContractType.getHealthPlanContractType(
                contract['health_plan_contract_type_id'] ?? 0,
                contract['type'] ?? ''),
        value: double.parse(contract['value'] != null ? contract['value'].toString() : 0.0.toString()),
        healthPlanContractStatus:
            HealthPlanContractStatus.getHealthPlanContractStatus(
                contract['health_plan_contract_status_id'] ?? 0,
                contract['status'] ?? ''));
  }

  static List<HealthPlanContract> fromArray(List contracts) {
    List<HealthPlanContract> userContracts = [];
    for (var contract in contracts) {
      userContracts.add(HealthPlanContract.fromMap(contract));
    }
    return userContracts;
  }
}
