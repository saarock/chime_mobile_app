class UserInfo {
  final String? id;
  final String? age;
  final String? userName;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? relationshipStatus;

  UserInfo({
    this.id,
    this.age,
    this.userName,
    this.phoneNumber,
    this.country,
    this.gender,
    this.relationshipStatus,
  });

  UserInfo copyWith({
    String? age,
    String? userName,
    String? phoneNumber,
    String? country,
    String? gender,
    String? relationshipStatus,
  }) {
    return UserInfo(
      id: id,
      age: age ?? this.age,
      userName: userName ?? this.userName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      country: country ?? this.country,
      gender: gender ?? this.gender,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
    );
  }
}
