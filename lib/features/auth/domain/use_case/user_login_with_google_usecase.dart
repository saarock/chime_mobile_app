import 'package:chime/app/use_case/usercase.dart';
import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  final String credential;
  final String clientId;

  const LoginParams({required this.clientId, required this.credential});

  // Initial constructor
  const LoginParams.initial() : clientId = '', credential = '';

  @override
  List<Object?> get props => [credential, clientId];
}

class UserLoginWithGoogleUsecase
    implements UserCaseWithParams<String, LoginParams> {
  final IUserRepository _userRepository;

  UserLoginWithGoogleUsecase({required IUserRepository userRepository})
    : _userRepository = userRepository;

  @override
  Future<Either<Failure, String>> call(LoginParams param) async {
    return await _userRepository.loginUserWithGoogle(
      param.credential,
      param.clientId,
    );
  }
}
