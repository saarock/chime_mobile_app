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
  age: json['age'] as String?,
  gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
  relationShipStatus: $enumDecodeNullable(
    _$RelationshipStatusEnumMap,
    json['relationShipStatus'],
  ),
  active: json['active'] as bool,
  country: json['country'] as String?,
  role: json['role'] as String,
  v: (json['v'] as num).toInt(),
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
      'age': instance.age,
      'gender': _$GenderEnumMap[instance.gender],
      'relationShipStatus':
          _$RelationshipStatusEnumMap[instance.relationShipStatus],
      'active': instance.active,
      'country': instance.country,
      'role': instance.role,
      'v': instance.v,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.other: 'other',
};

const _$RelationshipStatusEnumMap = {
  RelationshipStatus.single: 'single',
  RelationshipStatus.mingle: 'mingle',
  RelationshipStatus.notInterest: 'notInterest',
};
