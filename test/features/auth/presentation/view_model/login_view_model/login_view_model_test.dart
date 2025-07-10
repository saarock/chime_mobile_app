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

/// Fake context since real BuildContext isn't needed in logic-only tests.
class FakeBuildContext extends Fake implements BuildContext {}

/// Mocks for use cases
class MockUserLoginWithGoogleUsecase extends Mock
    implements UserLoginWithGoogleUsecase {}

class MockUserVerifyUsecase extends Mock implements UserVerifyUsecase {}

void main() {
  late MockUserLoginWithGoogleUsecase mockLoginUsecase;
  late MockUserVerifyUsecase mockVerifyUsecase;

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
    registerFallbackValue(FakeBuildContext());
  });

  setUp(() {
    mockLoginUsecase = MockUserLoginWithGoogleUsecase();
    mockVerifyUsecase = MockUserVerifyUsecase();
  });

  blocTest<LoginViewModel, LoginState>(
    'emits [loading, success] when LoginWithGoogle succeeds',
    build: () {
      when(
        () => mockLoginUsecase(any()),
      ).thenAnswer((_) async => const Right(user));
      return LoginViewModel(mockLoginUsecase, mockVerifyUsecase);
    },
    act: (bloc) {
      bloc.add(
        LoginWithGoogle(
          credential: 'valid_credential',
          clientId: 'mock_client_id',
          context: FakeBuildContext(),
        ),
      );
    },
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
      return LoginViewModel(mockLoginUsecase, mockVerifyUsecase);
    },
    act:
        (bloc) => bloc.add(
          LoginWithGoogle(
            credential: 'invalid_credential',
            clientId: 'mock_client_id',
            context: FakeBuildContext(),
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
    },
  );
}
