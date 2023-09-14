import 'package:enagro_app/models/animal_type.dart';

class AnimalSubType {
  final int animalSubTypeId;
  final String description;
  final AnimalType animalType;

  AnimalSubType(
      {required this.animalType,
      required this.animalSubTypeId,
      required this.description});

  factory AnimalSubType.fromMap(Map<String, dynamic> anml) {
    return AnimalSubType(
        animalSubTypeId: anml['id'] ?? 0,
        description: anml['description'] ?? '',
        animalType: AnimalType.getAnimalType(
            anml['animal_type_id'] ?? 0, anml['animal_type'] ?? ''));
  }

  static AnimalSubType getAnimalSubType(
      int id, String description, int animalTypeId, String animalType) {
    Map<String, dynamic> mp = {
      "id": id,
      "description": description,
      "animal_type_id": animalTypeId,
      "animal_type": animalType
    };
    return AnimalSubType.fromMap(mp);
  }

  static List<AnimalSubType> fromArray(List anmTypes) {
    List<AnimalSubType> animalTypes = [];
    for (var animalType in anmTypes) {
      animalTypes.add(AnimalSubType.fromMap(animalType));
    }
    return animalTypes;
  }
}
