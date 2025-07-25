import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:chime/features/auth/domain/use_case/user_verify_usecase.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/core/error/failure.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserVerifyUsecase userVerifyUsecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userVerifyUsecase = UserVerifyUsecase(userRepository: mockUserRepository);
  });

  const testUser = UserApiModel(
    id: 'u1',
    fullName: 'Aayush Basnet',
    email: 'aayush@example.com',
    active: true,
    role: 'user',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    v: 0,
  );

  const params = UserVerifyParams();

  test('should return UserApiModel on success', () async {
    when(
      () => mockUserRepository.verifyUser(),
    ).thenAnswer((_) async => const Right(testUser));

    final result = await userVerifyUsecase(params);

    expect(result, const Right(testUser));
    verify(() => mockUserRepository.verifyUser()).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure on error', () async {
    const failure = RemoteDatabaseFailure(message: 'Verification failed');

    when(
      () => mockUserRepository.verifyUser(),
    ).thenAnswer((_) async => const Left(failure));

    final result = await userVerifyUsecase(params);

    expect(result, const Left(failure));
  });
}
