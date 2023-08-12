class UserType {
  final int userTypeId;
  final String description;

  UserType({
    required this.userTypeId,
    required this.description
  });

  factory UserType.fromMap(Map<String, dynamic> city) {
    return UserType(
        userTypeId: city['id'] ?? city['user_type_id'] ?? 0,
        description: city['description'] ?? city['userType'] ?? ''
      );
  }

  static UserType getUserType(int id, String description) {
    Map<String, dynamic> mp = {"id": id, "description": description};
    UserType userType = UserType.fromMap(mp);
    return userType;
  }
}
