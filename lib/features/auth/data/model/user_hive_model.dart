// // user_hive_model.dart
// import 'package:equatable/equatable.dart';
// import 'package:hive/hive.dart';
// import 'package:uuid/uuid.dart';

// import 'package:chime/features/auth/domain/entity/user_entity.dart';

// part 'user_hive_model.g.dart';

// @HiveType(typeId: 13)
// class UserHiveModel extends Equatable {
//   @HiveField(0)
//   final String userId;

//   @HiveField(1)
//   final String fullName;

//   @HiveField(2)
//   final String? userName;

//   @HiveField(3)
//   final String email;

//   @HiveField(4)
//   final String? phoneNumber;

//   @HiveField(5)
//   final String? profilePicture;

//   @HiveField(6)
//   final String? age;

//   @HiveField(7)
//   final Gender? gender;

//   @HiveField(8)
//   final RelationshipStatus? relationShipStatus;

//   @HiveField(9)
//   final bool active;

//   @HiveField(10)
//   final String? country;

//   @HiveField(11)
//   final String role;

//   @HiveField(12)
//   final int version;

//   @HiveField(13)
//   final String createdAt;

//   @HiveField(14)
//   final String updatedAt;

//   @HiveField(15)
//   final String refreshToken;

//   UserHiveModel({
//     String? userId,
//     required this.fullName,
//     this.userName,
//     required this.email,
//     this.phoneNumber,
//     this.profilePicture,
//     this.age,
//     this.gender,
//     this.relationShipStatus,
//     required this.active,
//     this.country,
//     required this.role,
//     required this.version,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.refreshToken,
//   }) : userId = userId ?? const Uuid().v4();

//   const UserHiveModel.initial()
//     : userId = '',
//       fullName = '',
//       userName = null,
//       email = '',
//       phoneNumber = null,
//       profilePicture = null,
//       age = null,
//       gender = null,
//       relationShipStatus = null,
//       active = false,
//       country = null,
//       role = '',
//       version = 0,
//       createdAt = '',
//       updatedAt = '',
//       refreshToken = '';

//   /// Convert from Entity to Hive Model
//   factory UserHiveModel.fromEntity(UserEntity entity) {
//     return UserHiveModel(
//       userId: entity.userId ?? const Uuid().v4(),
//       fullName: entity.fullName,
//       userName: entity.userName,
//       email: entity.email,
//       phoneNumber: entity.phoneNumber,
//       profilePicture: entity.profilePicture,
//       age: entity.age,
//       gender: entity.gender,
//       relationShipStatus: entity.relationShipStatus,
//       active: entity.active,
//       country: entity.country,
//       role: entity.role,
//       version: entity.version,
//       createdAt: entity.createdAt,
//       updatedAt: entity.updatedAt,
//       refreshToken: entity.refreshToken,
//     );
//   }

//   /// Convert from Hive Model to Entity
//   UserEntity toEntity() {
//     return UserEntity(
//       userId: userId,
//       fullName: fullName,
//       userName: userName,
//       email: email,
//       phoneNumber: phoneNumber,
//       profilePicture: profilePicture,
//       age: age,
//       gender: gender,
//       relationShipStatus: relationShipStatus,
//       active: active,
//       country: country,
//       role: role,
//       version: version,
//       createdAt: createdAt,
//       updatedAt: updatedAt,
//       refreshToken: refreshToken,
//     );
//   }

//   @override
//   List<Object?> get props => [
//     userId,
//     fullName,
//     userName,
//     email,
//     phoneNumber,
//     profilePicture,
//     age,
//     gender,
//     relationShipStatus,
//     active,
//     country,
//     role,
//     version,
//     createdAt,
//     updatedAt,
//     refreshToken,
//   ];
// }
