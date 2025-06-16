import 'package:chime/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class IUserRepository {
  Future<Either<Failure, String>> loginUserWithGoogle(
    String credential,
    String clientId,
  );
}
