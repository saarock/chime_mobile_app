import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, UserApiModel>> loginUserWithGoogle(
    String credential,
    String clientId,
  );
}
