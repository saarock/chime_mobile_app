import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

enum Gender { male, female, other }

enum RelationshipStatus { single, mingle, notInterest }

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String fullName;
  final String? userName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;
  final String? age;
  final Gender? gender;

  @JsonKey(name: 'relationShipStatus')
  final RelationshipStatus? relationShipStatus;

  final bool active;
  final String? country;
  final String role;

  final int v;
  final String createdAt;
  final String updatedAt;

  const UserApiModel({
    this.id,
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
    required this.v,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserApiModelToJson(this);

  @override
  List<Object?> get props => [
    id,
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
    v,
    createdAt,
    updatedAt,
  ];
}
