import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import 'package:chime/core/error/failure.dart';
import 'package:chime/app/use_case/usercase.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';

class UpdateUserInfoParams extends Equatable {
  final String? userId;
  final String? age;
  final String? userName;
  final String? phoneNumber;
  final String? country;
  final String? gender;
  final String? relationshipStatus;

  const UpdateUserInfoParams({
    required this.userId,
    this.age,
    this.userName,
    this.phoneNumber,
    this.country,
    this.gender,
    this.relationshipStatus,
  });

  const UpdateUserInfoParams.initial()
    : userId = '',
      age = '',
      userName = '',
      phoneNumber = '',
      country = '',
      gender = '',
      relationshipStatus = '';

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

class UpdateUserInfoUseCase
    implements UserCaseWithParams<UserApiModel, UpdateUserInfoParams> {
  final IUserRepository _userRepository;

  UpdateUserInfoUseCase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserApiModel>> call(
    UpdateUserInfoParams params,
  ) async {
    return await _userRepository.updateUserProfileInfo(
      userId: params.userId!,
      age: params.age,
      userName: params.userName,
      phoneNumber: params.phoneNumber,
      country: params.country,
      gender: params.gender,
      relationshipStatus: params.relationshipStatus,
    );
  }
}
