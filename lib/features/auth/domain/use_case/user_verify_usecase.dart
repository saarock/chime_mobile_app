import 'package:chime/app/use_case/usercase.dart';
import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class UserVerifyParams extends Equatable {
  const UserVerifyParams();

  @override
  List<Object?> get props => [];
}

class UserVerifyUsecase
    implements UserCaseWithParams<UserApiModel, UserVerifyParams> {
  final IUserRepository _userRepository;

  UserVerifyUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, UserApiModel>> call(UserVerifyParams params) async {
    // Call the repository method that verifies the user
    return await _userRepository.verifyUser();
  }
}
