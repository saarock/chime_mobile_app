import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:chime/features/auth/data/model/user_api_model.dart';
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
  final UserVerifyUsecase _userVerifyUsecase;

  /// Flag to disable navigation during tests
  final bool shouldNavigate;

  LoginViewModel(
    this._userLoginWithGoogleUsecase,
    this._userVerifyUsecase, {
    this.shouldNavigate = true,
  }) : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithGoogle>(_loginWithGoogle);
    on<NavigateToHomeEvent>(_onNavigateToHomeView);
  }

  void updateUser(UserApiModel updatedUser) {
    emit(state.copyWith(userApiModel: updatedUser));
  }

  void _onNavigateToRegisterView(
    NavigateToRegisterViewEvent event,
    Emitter<LoginState> emit,
  ) {
    if (!shouldNavigate) return;

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
        await cacheUser(userData); // overrideable method
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            userApiModel: userData,
          ),
        );
        if (shouldNavigate && !emit.isDone) {
          add(NavigateToHomeEvent(context: event.context));
        }
      },
    );
  }

  void _onNavigateToHomeView(
    NavigateToHomeEvent event,
    Emitter<LoginState> emit,
  ) {
    if (!shouldNavigate) return;

    if (event.context.mounted) {
      Navigator.pushAndRemoveUntil(
        event.context,
        MaterialPageRoute(
          builder:
              (context) => BlocProvider<HomeViewModel>(
                create: (_) => HomeViewModel(loginViewModel: this),
                child: const HomeView(),
              ),
        ),
        (route) => false,
      );
    }
  }

  Future<void> verifyUser(BuildContext context) async {
    final result = await _userVerifyUsecase(const UserVerifyParams());

    await result.fold(
      (failure) async {
        if (!shouldNavigate) return;

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
        await cacheUser(userData);
        // ignore: invalid_use_of_visible_for_testing_member
        emit(
          state.copyWith(
            isLoading: false,
            isSuccess: true,
            userApiModel: userData,
          ),
        );
        if (!shouldNavigate) return;

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

  @protected
  Future<void> cacheUser(UserApiModel userData) async {
    await UserLocalDatasource().cacheUser(userData);
  }
}
