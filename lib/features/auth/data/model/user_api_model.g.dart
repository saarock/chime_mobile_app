// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
  id: json['_id'] as String?,
  fullName: json['fullName'] as String,
  userName: json['userName'] as String?,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  profilePicture: json['profilePicture'] as String?,
  age: const StringOrIntToIntConverter().fromJson(json['age']),
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  relationShipStatus: json['relationShipStatus'] as String?,
  active: json['active'] as bool,
  country: json['country'] as String?,
  role: json['role'] as String,
  v: const StringOrIntToIntConverter().fromJson(json['v']),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'fullName': instance.fullName,
      'userName': instance.userName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'profilePicture': instance.profilePicture,
      'age': const StringOrIntToIntConverter().toJson(instance.age),
      'gender': _$GenderEnumMap[instance.gender],
      'relationShipStatus': instance.relationShipStatus,
      'active': instance.active,
      'country': instance.country,
      'role': instance.role,
      'v': const StringOrIntToIntConverter().toJson(instance.v),
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$GenderEnumMap = {
  Gender.Male: 'Male',
  Gender.Female: 'Female',
  Gender.Other: 'Other',
};
