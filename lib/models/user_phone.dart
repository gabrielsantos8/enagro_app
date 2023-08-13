class UserPhone {
  final int userPhoneId;
  final int ddd;
  final int number;
  final int userId;

  UserPhone(
      {required this.userPhoneId,
      required this.ddd,
      required this.number,
      required this.userId});

  factory UserPhone.fromMap(Map<String, dynamic> usr) {
    return UserPhone(
        userPhoneId: usr['id'] ?? 0,
        ddd: usr['ddd'] ?? '',
        number: usr['number'] ?? '',
        userId: usr['user_id'] ?? 0);
  }
}
