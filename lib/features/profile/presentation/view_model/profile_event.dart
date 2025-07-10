import 'package:equatable/equatable.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class SubmitProfileEvent extends ProfileEvent {
  final String userId;
  final String? age;
  final String? userName;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? relationshipStatus;
  final UserApiModel existingUser;

  const SubmitProfileEvent({
    required this.userId,
    this.age,
    this.userName,
    this.phoneNumber,
    this.country,
    this.gender,
    this.relationshipStatus,
    required this.existingUser,
  });

  @override
  List<Object?> get props => [
    userId,
    age,
    userName,
    phoneNumber,
    country,
    gender,
    relationshipStatus,
    existingUser,
  ];
}
