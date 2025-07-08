import 'package:equatable/equatable.dart';

class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// Triggered when user submits profile update
class SubmitProfileEvent extends ProfileEvent {
  final String userId;
  final String? age;
  final String? userName;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? relationshipStatus;

  SubmitProfileEvent({
    required this.userId,
    this.age,
    this.userName,
    this.phoneNumber,
    this.country,
    this.gender,
    this.relationshipStatus,
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
  ];
}
