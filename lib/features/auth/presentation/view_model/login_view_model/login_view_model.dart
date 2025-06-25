import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/domain/use_case/user_verify_usecase.dart';
import 'package:chime/features/auth/presentation/view/login_view.dart';
import 'package:chime/features/auth/presentation/view/register_view.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_event.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_state.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/home/presentation/view/home_view.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewModel extends Bloc<LoginEvent, LoginState> {
  final UserLoginWithGoogleUsecase _userLoginWithGoogleUsecase;
  final UserVerifyUsecase _userVerifyUsecase; // Use this to verify user
  final IUserRepository
  _userRepository; // You referenced _userRepository in verifyUser but never defined it here

  LoginViewModel(
    this._userLoginWithGoogleUsecase,
    this._userVerifyUsecase,
    this._userRepository, // Inject repository here if you want to call verifyUser directly
  ) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithGoogle>(_loginWithGoogle);
    on<NavigateToHomeEvent>(_onNavigateToHomeView);
  }

  // Navigate to register page
  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.push(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: serviceLocator<RegsiterViewModel>(),
                  ),
                ],
                child: RegisterView(),
              ),
        ),
      );
    }
  }

  // Login with Google
  void _loginWithGoogle(LoginWithGoogle event, Emitter<LoginState> emit) async {
    emit(state.copyWith(isLoading: true, isSuccess: false));

    final result = await _userLoginWithGoogleUsecase(
      LoginParams(clientId: event.clientId, credential: event.credential),
    );

    await result.fold(
      (failure) {
        emit(state.copyWith(isLoading: false, isSuccess: false));
      },
      (userData) async {
        await UserLocalDatasource().cacheUser(userData);
        print('Emitting logged in state with user: $userData');
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            userApiModel: userData,
          ),
        );
        if (!emit.isDone) {
          add(NavigateToHomeEvent(context: event.context));
        }
      },
    );
  }

  // Navigate to home
  void _onNavigateToHomeView(
    NavigateToHomeEvent event,
    Emitter<LoginState> emit,
  ) {
    if (event.context.mounted) {
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider<HomeViewModel>(
                create: (context) => HomeViewModel(loginViewModel: this),
                child: const HomeView(),
              ),
        ),
        (route) => false,
      );
    }
  }

  // Verify user using the usecase
  Future<void> verifyUser(BuildContext context) async {
    final result = await _userVerifyUsecase(const UserVerifyParams());

    await result.fold(
      (failure) async {
        // Verification failed → go to Login screen
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider.value(
                    value: serviceLocator<LoginViewModel>(),
                    child: const LoginView(),
                  ),
            ),
          );
        }
      },
      (userData) async {
        print("User verified:");
        print(userData);
        // Cache user locally
        await UserLocalDatasource().cacheUser(userData);
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            userApiModel: userData,
          ),
        );

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (_) => BlocProvider<HomeViewModel>(
                    create: (_) => HomeViewModel(loginViewModel: this),
                    child: const HomeView(),
                  ),
            ),
          );
        }
      },
    );
  }
}
