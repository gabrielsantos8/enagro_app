import 'package:enagro_app/models/city.dart';

class UserAddress {
  final int userAddressId;
  final String complement;
  final City city;
  final int userId;

  UserAddress(
      {required this.userAddressId,
      required this.complement,
      required this.city,
      required this.userId});

  factory UserAddress.fromMap(Map<String, dynamic> usr) {
    return UserAddress(
        userAddressId: usr['id'] ?? 0,
        complement: usr['complement'] ?? '',
        city: City.getCity(usr['city_id'] ?? 0, usr['city'] ?? '',
            usr['uf'] ?? '', usr['ibge'] ?? 0),
        userId: usr['user_id'] ?? 0);
  }

  static List<UserAddress> getAddresses(List addresses) {
    List<UserAddress> userAddresses = [];
    for (var address in addresses) {
      userAddresses.add(UserAddress.fromMap(address));
    }
    return userAddresses;
  }

  static UserAddress getAddress(int id, String complement, int city_id,
      String city, String uf, int ibge) {
    Map<String, dynamic> mp = {
      "id": id,
      "complement": complement,
      "city_id": city_id,
      "city": city,
      "uf": uf,
      "ibge": ibge
    };
    return UserAddress.fromMap(mp);
  }
}
