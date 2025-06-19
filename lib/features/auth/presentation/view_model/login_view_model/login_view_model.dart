import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
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

  LoginViewModel(this._userLoginWithGoogleUsecase)
    : super(LoginState.initial()) {
    on<NavigateToRegisterViewEvent>(_onNavigateToRegisterView);
    on<LoginWithGoogle>(_loginWithGoogle);
    on<NavigateToHomeEvent>(_onNavigateToHomeView);
  }

  // ============ Navigate to  the register page =============== //
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
                  ), // Fixed missing parentheses here
                ],
                child: RegisterView(),
              ),
        ),
      );
    }
  }

  // Login with google
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
        print("Ok ok ");
        print(userData.toJson());
        // ignore: use_build_context_synchronously
        // Only add another event if the bloc is still active
        if (!emit.isDone) {
          add(NavigateToHomeEvent(context: event.context));
        }
      },
    );
  }

  // Navigate to home
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
        (route) => false, // This removes all previous routes
      );
    }
  }
}
