import 'package:enagro_app/models/city.dart';

class ServiceCity {
  final int serviceCityId;
  final City city;
  final int veterinarianId;

  ServiceCity(
      {required this.serviceCityId,
      required this.city,
      required this.veterinarianId});

  factory ServiceCity.fromMap(Map<String, dynamic> usr) {
    return ServiceCity(
        serviceCityId: usr['id'] ?? 0,
        city: City.getCity(usr['city_id'] ?? 0, usr['city'] ?? '',
            usr['uf'] ?? '', usr['ibge'] ?? 0),
        veterinarianId: usr['veterinarian_id'] ?? 0);
  }

  static List<ServiceCity> getServiceCities(List serviceCities) {
    List<ServiceCity> vetServiceCities = [];
    for (var serviceCity in serviceCities) {
      vetServiceCities.add(ServiceCity.fromMap(serviceCity));
    }
    return vetServiceCities;
  }
}
