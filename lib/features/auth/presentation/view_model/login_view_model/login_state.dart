import 'package:chime/features/auth/data/model/user_api_model.dart';
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final UserApiModel? userApiModel;

  const LoginState({
    required this.isLoading,
    required this.isSuccess,
    this.userApiModel,
  });

  const LoginState.initial()
    : isLoading = false,
      isSuccess = false,
      userApiModel = null;

  LoginState copyWith({
    bool? isLoading,
    bool? isSuccess,
    UserApiModel? userApiModel,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      userApiModel: userApiModel ?? this.userApiModel,
    );
  }

  @override
  List<Object?> get props => [isLoading, isSuccess, userApiModel];
}
