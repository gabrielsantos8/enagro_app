import 'package:enagro_app/models/city.dart';

class UserAddress {
  final int userAddressId;
  final String complement;
  final City city;
  final int userId;
  final bool? isNotDeletable;

  UserAddress(
      {this.isNotDeletable,
      required this.userAddressId,
      required this.complement,
      required this.city,
      required this.userId});

  factory UserAddress.fromMap(Map<String, dynamic> usr) {
    return UserAddress(
        userAddressId: usr['id'] ?? 0,
        complement: usr['complement'] ?? '',
        isNotDeletable: usr['is_not_deletable'] ?? false,
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

  static UserAddress getAddress(int id, String complement, int cityId,
      String city, String uf, int ibge) {
    Map<String, dynamic> mp = {
      "id": id,
      "complement": complement,
      "city_id": cityId,
      "city": city,
      "uf": uf,
      "ibge": ibge
    };
    return UserAddress.fromMap(mp);
  }
}
