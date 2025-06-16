import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:chime/features/auth/domain/entity/user_google_entity.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:dartz/dartz.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, String>> loginUserWithGoogle(
    String credential,
    String clientId,
  ) async {
    final googleLoginCredential = GoogleLoginCredential(
      clientId: clientId,
      credential: credential,
    );
    final response = await _userRemoteDatasource.loginUser(
      googleLoginCredential,
    );
    return Right(response);
  }
}
