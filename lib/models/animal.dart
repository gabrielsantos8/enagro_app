import 'package:enagro_app/models/animalType.dart';
import 'package:enagro_app/models/user_address.dart';

class Animal {
  final int animalId;
  final String description;
  final String name;
  final AnimalType animalType;
  final String imgUrl;
  final UserAddress userAddress;
  final DateTime birthDate;

  Animal(
      {required this.animalType,
      required this.imgUrl,
      required this.userAddress,
      required this.birthDate,
      required this.animalId,
      required this.description,
      required this.name});

  factory Animal.fromMap(Map<String, dynamic> anml) {
    return Animal(
        animalId: anml['id'] ?? 0,
        name: anml['name'] ?? '',
        description: anml['description'] ?? '',
        animalType: AnimalType.getAnimalType(
            anml['animal_type_id'] ?? 0, anml['animal_type'] ?? ''),
        imgUrl: (anml['img_url'] ?? '').toString().replaceAll('localhost', '10.0.2.2'),
        userAddress: UserAddress.getAddress(
            anml['user_address_id'] ?? 0,
            anml['complement'] ?? '',
            anml['city_id'] ?? 0,
            anml['city'] ?? '',
            anml['uf'] ?? '',
            anml['ibge'] ?? 0),
        birthDate: DateTime.parse(anml['birth_date'] ?? '1900-12-01'));
  }

  static List<Animal> getAnimals(List animals) {
    List<Animal> usrAnimals = [];
    for (var animal in animals) {
      usrAnimals.add(Animal.fromMap(animal));
    }
    return usrAnimals;
  }
}
