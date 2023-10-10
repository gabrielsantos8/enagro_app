import 'package:enagro_app/models/animal_subtype.dart';
import 'package:enagro_app/models/animal_type.dart';
import 'package:enagro_app/models/user_address.dart';

class Animal {
  final int animalId;
  final String description;
  final String name;
  final AnimalType animalType;
  final String imgUrl;
  final UserAddress userAddress;
  final DateTime birthDate;
  final double weight;
  final AnimalSubType animalSubType;
  final int amount;
  final int? healthPlanContractAnimalId;

  Animal(
      {required this.animalType,
      required this.imgUrl,
      required this.userAddress,
      required this.birthDate,
      required this.animalId,
      required this.description,
      required this.name,
      required this.weight,
      required this.animalSubType,
      required this.amount,
      this.healthPlanContractAnimalId});

  factory Animal.fromMap(Map<String, dynamic> anml) {
    return Animal(
        animalId: anml['id'] ?? 0,
        name: anml['name'] ?? '',
        description: anml['description'] ?? '',
        animalType: AnimalType.getAnimalType(
            anml['animal_type_id'] ?? 0, anml['animal_type'] ?? ''),
        imgUrl: (anml['img_url'] ??
                'https://static.thenounproject.com/png/1554486-200.png')
            .toString()
            .replaceAll('localhost', '10.0.2.2'),
        userAddress: UserAddress.getAddress(
            anml['user_address_id'] ?? 0,
            anml['complement'] ?? '',
            anml['city_id'] ?? 0,
            anml['city'] ?? '',
            anml['uf'] ?? '',
            anml['ibge'] ?? 0),
        birthDate: DateTime.parse(anml['birth_date'] ?? '1900-12-01'),
        weight: anml['weight'].toDouble() ?? 0.0,
        animalSubType: AnimalSubType.getAnimalSubType(
            anml['animal_subtype_id'] ?? 0,
            anml['animal_subtype'] ?? '',
            anml['animal_type_id'] ?? 0,
            anml['animal_type'] ?? ''),
        amount: anml['amount'] ?? 0,
        healthPlanContractAnimalId:
            anml['health_plan_contract_animals_id'] ?? 0);
  }

  static List<Animal> getAnimals(List animals) {
    List<Animal> usrAnimals = [];
    for (var animal in animals) {
      usrAnimals.add(Animal.fromMap(animal));
    }
    return usrAnimals;
  }
}
