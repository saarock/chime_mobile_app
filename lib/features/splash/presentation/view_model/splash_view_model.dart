import 'package:chime/app/service_locator/service_locator.dart';
import 'package:chime/features/auth/data/data_source/local_datasource/user_local_datasource.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:chime/features/auth/presentation/view/login_view.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/home/presentation/view/home_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashViewModel extends Cubit<void> {
  SplashViewModel() : super(null);

  final IUserRepository _userRepository = serviceLocator<IUserRepository>();

  Future<void> init(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2));
    // ignore: use_build_context_synchronously
    await verifyUser(context);
  }

  Future<void> verifyUser(BuildContext context) async {
    final result = await _userRepository.verifyUser();

    await result.fold(
      (failure) async {
        // ❌ Verification failed → go to Login
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
      (user) async {
        // ✅ Verified → cache and navigate to Home
        await UserLocalDatasource().cacheUser(user); // ✅ FIXED: pass user

        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeView()),
          );
        }
      },
    );
  }
}
