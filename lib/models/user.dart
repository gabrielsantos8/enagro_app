class User {
  final int userId;
  final String name;
  final String email;
  final int userTypeId;
  final String userType;

  User({
    required this.userId,
    required this.name,
    required this.email,
    required this.userTypeId,
    required this.userType,
  });

  factory User.fromArray(Map<String, dynamic> usr) {
    return User(
        userId: usr['id'] ?? 0,
        name: usr['name'] ?? '',
        email: usr['email'] ?? '',
        userTypeId: usr['user_type_id'] ?? 0,
        userType: usr['user_type'] ?? '');
  }
}
