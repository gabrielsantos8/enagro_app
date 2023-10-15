import 'package:enagro_app/models/animal_subtype.dart';

class Service {
  final int serviceId;
  final int vetServiceId;
  final String description;
  final AnimalSubType animalSubType;
  final double value;

  Service(
      {required this.serviceId,
      required this.vetServiceId,
      required this.description,
      required this.animalSubType,
      required this.value});

  factory Service.fromMap(Map<String, dynamic> usr) {
    return Service(
        serviceId: usr['id'] ?? 0,
        vetServiceId: usr['vetservice_id'] ?? 0,
        description: usr['description'] ?? '',
        animalSubType: AnimalSubType.getAnimalSubType(
            usr['animal_subtype_id'] ?? 0,
            usr['animal_subtype'] ?? '',
            usr['animal_type_id'] ?? 0,
            usr['animal_type'] ?? ''),
        value: double.parse(usr['value'] != null ? usr['value'].toString() : 0.0.toString()));
  }

  static List<Service> getServices(List services) {
    List<Service> servicesList = [];
    for (var service in services) {
      servicesList.add(Service.fromMap(service));
    }
    return servicesList;
  }
}
