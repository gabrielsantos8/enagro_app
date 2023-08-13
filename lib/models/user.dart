import 'package:enagro_app/models/user_address.dart';
import 'package:enagro_app/models/user_type.dart';

class User {
  final int userId;
  final String name;
  final String email;
  final List<UserAddress> addresses;
  final UserType userType;

  User(
      {required this.userId,
      required this.name,
      required this.email,
      required this.userType,
      required this.addresses});

  factory User.fromMap(Map<String, dynamic> usr) {
    return User(
        userId: usr['id'] ?? 0,
        name: usr['name'] ?? '',
        email: usr['email'] ?? '',
        userType: UserType.getUserType(
            usr['user_type_id'] ?? 0, usr['user_type'] ?? ''),
        addresses: UserAddress.getAddresses(usr['addresses'] ?? []));
  }
}
