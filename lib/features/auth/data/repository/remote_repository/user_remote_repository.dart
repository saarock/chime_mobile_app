import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/features/auth/domain/entity/user_google_entity.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class UserRemoteRepository implements IUserRepository {
  final UserRemoteDatasource _userRemoteDatasource;

  UserRemoteRepository({required UserRemoteDatasource userRemoteDatasource})
    : _userRemoteDatasource = userRemoteDatasource;

  @override
  Future<Either<Failure, UserApiModel>> loginUserWithGoogle(
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

  @override
  Future<Either<Failure, UserApiModel>> verifyUser() async {
    try {
      final response = await _userRemoteDatasource.verifyUser();
      return Right(response);
    } on DioException catch (e) {
      return Left(
        RemoteDatabaseFailure(
          message: e.response?.data['message'] ?? 'Verification failed',
        ),
      );
    } catch (e) {
      return Left(
        RemoteDatabaseFailure(message: 'Unexpected error: ${e.toString()}'),
      );
    }
  }
}
