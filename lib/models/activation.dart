import 'package:enagro_app/models/animal.dart';
import 'package:enagro_app/models/service.dart';
import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/models/user_phone.dart';

class Activation {
  final int activationId;
  final int contractId;
  final int veterinarianId;
  final String veterinarian;
  final int statusId;
  final String status;
  final int typeId;
  final num value;
  final String type;
  final String user;
  final DateTime scheduledDate;
  final DateTime activationDate;
  final String plan;
  final List<Service> services;
  final List<Animal> animals;
  final List<UserPhone> phones;
  final List<UserAddress> addresses;

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
      required this.animals,
      required this.user,
      required this.value,
      required this.phones,
      required this.addresses});

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
      activationDate:
          DateTime.parse(contract['activation_date'] ?? '1900-12-01'),
      plan: contract['plan'],
      services: Service.getServices(contract['services'] ?? []),
      animals: Animal.getAnimals(contract['animals'] ?? []),
      value: contract['valueToPay'] ?? 0.0,
      user: contract['user'] ?? '',
      phones: UserPhone.getPhones(contract['phones'] ?? []),
      addresses: UserAddress.getAddresses(contract['addresses'] ?? []),
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
