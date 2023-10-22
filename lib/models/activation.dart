import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/service.dart';

class Activation {
  final int activationId;
  final int contractId;
  final int veterinarianId;
  final String veterinarian;
  final int statusId;
  final String status;
  final int typeId;
  final String type;
  final DateTime scheduledDate;
  final DateTime activationDate;
  final String plan;
  final List<Service> services;
  final List<Animal> animals;

  Activation(
      {required this.activationId,
      required this.contractId,
      required this.veterinarianId,
      required this.veterinarian,
      required this.statusId,
      required this.typeId,
      required this.status,
      required this.type,
      required this.scheduledDate,
      required this.activationDate,
      required this.plan,
      required this.services,
      required this.animals});

  factory Activation.fromMap(Map<String, dynamic> contract) {
    return Activation(
        activationId: contract['id'] ?? 0,
        contractId: contract['contract_id'] ?? 0,
        veterinarianId: contract['veterinarian_id'],
        veterinarian: contract['veterinarian'],
        statusId: contract['activation_status_id'],
        status: contract['status'],
        typeId: contract['activation_type_id'],
        type: contract['type'],
        scheduledDate: DateTime.parse(contract['scheduled_date'] ?? '1900-12-01'),
        activationDate: DateTime.parse(contract['activation_date'] ?? '1900-12-01'),
        plan: contract['plan'],
        services: Service.getServices(contract['services'] ?? []),
        animals: Animal.getAnimals(contract['animals'] ?? [])
        );
  }

  static List<Activation> fromArray(List activations) {
    List<Activation> activationList = [];
    for (var activation in activations) {
      activationList.add(Activation.fromMap(activation));
    }
    return activationList;
  }
}
