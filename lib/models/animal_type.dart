class AnimalType {
  final int animalTypeId;
  final String description;

  AnimalType({required this.animalTypeId, required this.description});

  factory AnimalType.fromMap(Map<String, dynamic> anml) {
    return AnimalType(
        animalTypeId: anml['id'] ?? 0, description: anml['description'] ?? '');
  }

  static AnimalType getAnimalType(int id, String description) {
    Map<String, dynamic> mp = {"id": id, "description": description};
    return AnimalType.fromMap(mp);
  }

   static List<AnimalType> fromArray(List anmTypes) {
    List<AnimalType> animalTypes = [];
    for (var animalType in anmTypes) {
      animalTypes.add(AnimalType.fromMap(animalType));
    }
    return animalTypes;
  }
}
