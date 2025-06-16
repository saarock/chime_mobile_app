import 'package:equatable/equatable.dart';

enum Gender { male, female, other }

enum RelationshipStatus { single, mingle, notInterest }

class UserEntity extends Equatable {
  final String? userId;
  final String fullName;
  final String? userName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? age;
  final Gender? gender;
  final RelationshipStatus? relationShipStatus;
  final bool active;
  final String? country;
  final String role;
  final int version;
  final String createdAt;
  final String updatedAt;
  final String refreshToken;

  const UserEntity({
    this.userId,
    required this.fullName,
    this.userName,
    required this.email,
    this.phoneNumber,
    this.profilePicture,
    this.age,
    this.gender,
    this.relationShipStatus,
    required this.active,
    this.country,
    required this.role,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [
    userId,
    fullName,
    userName,
    email,
    phoneNumber,
    profilePicture,
    age,
    gender,
    relationShipStatus,
    active,
    country,
    role,
    version,
    createdAt,
    updatedAt,
    refreshToken,
  ];
}
