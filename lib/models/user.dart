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

  factory User.fromArray(Map<String, dynamic> mapa) {
    return User(
        userId: mapa['id'] ?? 0,
        name: mapa['name'] ?? '',
        email: mapa['email'] ?? '',
        userTypeId: mapa['user_type_id'] ?? 0,
        userType: mapa['user_type'] ?? '');
  }
}
