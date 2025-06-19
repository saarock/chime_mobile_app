import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

enum Gender { male, female, other }

@JsonSerializable()
class UserApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  final String fullName;
  final String? userName;
  final String email;
  final String? phoneNumber;
  final String? profilePicture;

  @StringOrIntToIntConverter()
  final int? age;

  final Gender? gender;

  @JsonKey(name: 'relationShipStatus')
  final String? relationShipStatus;

  final bool active;
  final String? country;
  final String role;

  @StringOrIntToIntConverter()
  final int? v;

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

/// Handles cases where backend sends either a string or an int for numeric fields
class StringOrIntToIntConverter implements JsonConverter<int?, dynamic> {
  const StringOrIntToIntConverter();

  @override
  int? fromJson(dynamic json) {
    if (json == null) return null;
    if (json is int) return json;
    if (json is String) return int.tryParse(json);
    return null;
  }

  @override
  dynamic toJson(int? object) => object;
}
