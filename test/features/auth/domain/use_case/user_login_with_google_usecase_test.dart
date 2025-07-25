import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';

import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/core/error/failure.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UserLoginWithGoogleUsecase userLoginWithGoogleUsecase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userLoginWithGoogleUsecase = UserLoginWithGoogleUsecase(
      userRepository: mockUserRepository,
    );
  });

  const credential = 'sample_google_credential';
  const clientId = 'client_abc123';

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

  final params = LoginParams(credential: credential, clientId: clientId);

  test('should return UserApiModel on successful login', () async {
    when(
      () => mockUserRepository.loginUserWithGoogle(credential, clientId),
    ).thenAnswer((_) async => const Right(testUser));

    final result = await userLoginWithGoogleUsecase(params);

    expect(result, const Right(testUser));
    verify(
      () => mockUserRepository.loginUserWithGoogle(credential, clientId),
    ).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return Failure on login error', () async {
    const failure = ApiFailure(message: 'Invalid credentials', statusCode: 401);

    when(
      () => mockUserRepository.loginUserWithGoogle(credential, clientId),
    ).thenAnswer((_) async => const Left(failure));

    final result = await userLoginWithGoogleUsecase(params);

    expect(result, const Left(failure));
  });
}
