import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewModel extends Cubit<void> {
  final LoginViewModel _loginViewModel;

  SplashViewModel(this._loginViewModel) : super(null);

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    await _loginViewModel.verifyUser(context);
  }
}
