import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:chime/features/auth/domain/use_case/update_user_info.usecase.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/core/error/failure.dart';

class MockUserRepository extends Mock implements IUserRepository {}

void main() {
  late MockUserRepository mockUserRepository;
  late UpdateUserInfoUseCase updateUserInfoUseCase;

  setUp(() {
    mockUserRepository = MockUserRepository();
    updateUserInfoUseCase = UpdateUserInfoUseCase(
      userRepository: mockUserRepository,
    );
  });

  const testUserId = '123';
  const testUserModel = UserApiModel(
    id: '123',
    fullName: 'Aayush Basnet',
    email: 'aayush@example.com',
    active: true,
    role: 'user',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    v: 0,
  );

  final params = UpdateUserInfoParams(
    userId: testUserId,
    existingUser: testUserModel,
    age: '23',
    userName: 'aayush_dev',
    phoneNumber: '9800000000',
    country: 'Nepal',
    gender: 'Male',
    relationshipStatus: 'Single',
  );

  test('should return updated user on success', () async {
    when(
      () => mockUserRepository.updateUserProfileInfo(
        userId: testUserId,
        existingUser: testUserModel,
        age: '23',
        userName: 'aayush_dev',
        phoneNumber: '9800000000',
        country: 'Nepal',
        gender: 'Male',
        relationshipStatus: 'Single',
      ),
    ).thenAnswer((_) async => const Right(testUserModel));

    final result = await updateUserInfoUseCase(params);

    expect(result, const Right(testUserModel));
    verify(
      () => mockUserRepository.updateUserProfileInfo(
        userId: testUserId,
        existingUser: testUserModel,
        age: '23',
        userName: 'aayush_dev',
        phoneNumber: '9800000000',
        country: 'Nepal',
        gender: 'Male',
        relationshipStatus: 'Single',
      ),
    ).called(1);
    verifyNoMoreInteractions(mockUserRepository);
  });

  test('should return RemoteDatabaseFailure on repository error', () async {
    const failure = RemoteDatabaseFailure(message: 'Update failed');

    when(
      () => mockUserRepository.updateUserProfileInfo(
        userId: testUserId,
        existingUser: testUserModel,
        age: '23',
        userName: 'aayush_dev',
        phoneNumber: '9800000000',
        country: 'Nepal',
        gender: 'Male',
        relationshipStatus: 'Single',
      ),
    ).thenAnswer((_) async => const Left(failure));

    final result = await updateUserInfoUseCase(params);

    expect(result, const Left(failure));
  });

  test('should return ApiFailure on API error with status code', () async {
    const failure = ApiFailure(message: 'Bad Request', statusCode: 400);

    when(
      () => mockUserRepository.updateUserProfileInfo(
        userId: testUserId,
        existingUser: testUserModel,
        age: '23',
        userName: 'aayush_dev',
        phoneNumber: '9800000000',
        country: 'Nepal',
        gender: 'Male',
        relationshipStatus: 'Single',
      ),
    ).thenAnswer((_) async => const Left(failure));

    final result = await updateUserInfoUseCase(params);

    expect(result, const Left(failure));
  });

  test('should return LocalDatabaseFailure on local DB issue', () async {
    const failure = LocalDatabaseFailure(message: 'Local write failed');

    when(
      () => mockUserRepository.updateUserProfileInfo(
        userId: testUserId,
        existingUser: testUserModel,
        age: '23',
        userName: 'aayush_dev',
        phoneNumber: '9800000000',
        country: 'Nepal',
        gender: 'Male',
        relationshipStatus: 'Single',
      ),
    ).thenAnswer((_) async => const Left(failure));

    final result = await updateUserInfoUseCase(params);

    expect(result, const Left(failure));
  });
}
