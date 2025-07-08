import 'package:chime/app/shared_pref/cooki_cache.dart';
import 'package:chime/features/auth/presentation/view/login_view.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/home/presentation/view_model/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<HomeState> {
  final LoginViewModel loginViewModel;

  HomeViewModel({required this.loginViewModel})
    : super(HomeState.initial(loginViewModel));

  void onTabTapped(int index) {
    emit(state.copyWith(selectedIndex: index));
  }

  void logout(BuildContext context) {
    // Wait for 2 seconds before navigating
    Future.delayed(const Duration(seconds: 2), () async {
      await CookieCache.clearAll();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => BlocProvider.value(
                  value: loginViewModel,
                  child: LoginView(),
                ),
          ),
        );
      }
    });
  }
}
