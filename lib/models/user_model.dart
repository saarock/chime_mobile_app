class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String profilePic;
  final bool active;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.profilePic,
    required this.active,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      email: json['email'],
      profilePic: json['profilePicture'] ?? '',
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'profilePic': profilePic,
      'active': active,
    };
  }
}
