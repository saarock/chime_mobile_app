import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_api_model.g.dart';

enum Gender { Male, Female, Other }

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

  @JsonKey(name: 'relationshipStatus')
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

  // Add copyWith method
  UserApiModel copyWith({
    String? id,
    String? fullName,
    String? userName,
    String? email,
    String? phoneNumber,
    String? profilePicture,
    int? age,
    Gender? gender,
    String? relationShipStatus,
    bool? active,
    String? country,
    String? role,
    int? v,
    String? createdAt,
    String? updatedAt,
  }) {
    return UserApiModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      userName: userName ?? this.userName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      relationShipStatus: relationShipStatus ?? this.relationShipStatus,
      active: active ?? this.active,
      country: country ?? this.country,
      role: role ?? this.role,
      v: v ?? this.v,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
