import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:chime/core/error/failure.dart';
import 'package:chime/app/use_case/usercase.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';

/// Parameters for updating user info.
class UpdateUserInfoParams extends Equatable {
  final String? userId;
  final String? age;
  final String? userName;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? relationshipStatus;
  final UserApiModel existingUser; // ✅ Required for merging

  const UpdateUserInfoParams({
    required this.userId,
    required this.existingUser,

    this.age,
    this.userName,
    this.phoneNumber,
    this.country,
    this.gender,
    this.relationshipStatus,
  });

  /// Optional: Initial state (can be used for form defaults)
  const UpdateUserInfoParams.initial()
    : userId = '',
      existingUser = const UserApiModel(
        id: '',
        fullName: '',
        email: '',
        active: false,
        role: '',
        createdAt: '',
        updatedAt: '',
        v: 0,
      ),
      age = '',
      userName = '',
      phoneNumber = '',
      country = '',
      gender = '',
      relationshipStatus = '';

  @override
  List<Object?> get props => [
    userId,
    existingUser,
    age,
    userName,
    phoneNumber,
    country,
    gender,
    relationshipStatus,
  ];
}

/// UseCase class to call repository and update only changed user fields.
class UpdateUserInfoUseCase
    implements UserCaseWithParams<UserApiModel, UpdateUserInfoParams> {
  final IUserRepository _userRepository;

  /// Constructor with named parameter
  UpdateUserInfoUseCase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserApiModel>> call(
    UpdateUserInfoParams params,
  ) async {
    return await _userRepository.updateUserProfileInfo(
      userId: params.userId!,
      existingUser: params.existingUser, // ✅ use current data to merge
      age: params.age,
      userName: params.userName,
      phoneNumber: params.phoneNumber,
      country: params.country,
      gender: params.gender,
      relationshipStatus: params.relationshipStatus,
    );
  }
}
