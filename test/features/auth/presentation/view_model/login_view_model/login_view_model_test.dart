import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/domain/use_case/user_verify_usecase.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:chime/core/error/failure.dart';
import 'package:chime/features/auth/data/data_source/local_datasource/user_local_datasource.dart';

/// ----------------- Fakes -----------------
class FakeLoginParams extends Fake implements LoginParams {}

class FakeUserApiModel extends Fake implements UserApiModel {}

/// ----------------- Mock BuildContext with `.mounted` -----------------
class MockBuildContext extends Mock implements BuildContext {
  @override
  bool get mounted => true;
}

/// ----------------- Mocks -----------------
class MockUserLoginWithGoogleUsecase extends Mock
    implements UserLoginWithGoogleUsecase {}

class MockUserVerifyUsecase extends Mock implements UserVerifyUsecase {}

class MockUserLocalDatasource extends Mock implements UserLocalDatasource {}

/// ----------------- Testable ViewModel -----------------
class TestableLoginViewModel extends LoginViewModel {
  final UserLocalDatasource mockLocalDatasource;

  TestableLoginViewModel(
    UserLoginWithGoogleUsecase loginUsecase,
    UserVerifyUsecase verifyUsecase,
    this.mockLocalDatasource,
  ) : super(
        loginUsecase,
        verifyUsecase,
        shouldNavigate: false, // disable navigation in tests
      );

  @override
  Future<void> cacheUser(UserApiModel userData) async {
    await mockLocalDatasource.cacheUser(userData);
  }
}

void main() {
  late MockUserLoginWithGoogleUsecase mockLoginUsecase;
  late MockUserVerifyUsecase mockVerifyUsecase;
  late MockUserLocalDatasource mockLocalDatasource;

  const user = UserApiModel(
    id: 'u1',
    fullName: 'Aayush',
    email: 'aayush@example.com',
    active: true,
    role: 'user',
    createdAt: '2024-01-01T00:00:00Z',
    updatedAt: '2024-01-01T00:00:00Z',
    v: 0,
  );

  setUpAll(() {
    registerFallbackValue(MockBuildContext());
    registerFallbackValue(FakeLoginParams());
    registerFallbackValue(FakeUserApiModel());
  });

  setUp(() {
    mockLoginUsecase = MockUserLoginWithGoogleUsecase();
    mockVerifyUsecase = MockUserVerifyUsecase();
    mockLocalDatasource = MockUserLocalDatasource();
  });

  TestableLoginViewModel createViewModel() {
    return TestableLoginViewModel(
      mockLoginUsecase,
      mockVerifyUsecase,
      mockLocalDatasource,
    );
  }

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, success] when LoginWithGoogle succeeds',
    build: () {
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => const Right(user));

      when(
        () => mockLocalDatasource.cacheUser(any()),
      ).thenAnswer((_) async => Future.value());

      return createViewModel();
    },
    act:
        (bloc) => bloc.add(
          LoginWithGoogle(
            credential: 'valid_credential',
            clientId: 'mock_client_id',
            context: MockBuildContext(),
          ),
        ),
    wait: const Duration(milliseconds: 100),
    expect:
        () => [
          LoginState.initial().copyWith(isLoading: true, isSuccess: false),
          LoginState.initial().copyWith(
            isLoading: false,
            isSuccess: true,
            userApiModel: user,
          ),
        ],
    verify: (_) {
      verify(() => mockLoginUsecase(any())).called(1);
      verify(() => mockLocalDatasource.cacheUser(user)).called(1);
    },
  );

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, failure] when LoginWithGoogle fails',
    build: () {
      when(() => mockLoginUsecase(any())).thenAnswer(
        (_) async => const Left(
          ApiFailure(message: 'Invalid credentials', statusCode: 401),
        ),
      );
      return createViewModel();
    },
    act:
        (bloc) => bloc.add(
          LoginWithGoogle(
            credential: 'invalid_credential',
            clientId: 'mock_client_id',
            context: MockBuildContext(),
          ),
        ),
    wait: const Duration(milliseconds: 100),
    expect:
        () => [
          LoginState.initial().copyWith(isLoading: true, isSuccess: false),
          LoginState.initial().copyWith(isLoading: false, isSuccess: false),
        ],
    verify: (_) {
      verify(() => mockLoginUsecase(any())).called(1);
      verifyNever(() => mockLocalDatasource.cacheUser(any()));
    },
  );
}
