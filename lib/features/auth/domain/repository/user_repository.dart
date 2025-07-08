import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, UserApiModel>> loginUserWithGoogle(
    String credential,
    String clientId,
  );
  Future<Either<Failure, UserApiModel>> verifyUser();

  Future<Either<Failure, UserApiModel>> updateUserProfileInfo({
    required String userId,
    String? age,
    String? userName,
    String? phoneNumber,
    String? country,
    String? gender,
    String? relationshipStatus,
  });
}
