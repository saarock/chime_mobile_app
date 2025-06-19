import 'package:chime/core/error/failure.dart';
import 'package:dartz/dartz.dart';

abstract interface class UserCaseWithParams<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params param);
}
