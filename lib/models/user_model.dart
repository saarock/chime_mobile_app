class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profilePicture;
  final bool active;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePicture,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profilePicture: json['profilePicture'] ?? '',
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profilePicture': profilePicture,
      'active': active,
    };
  }
}
