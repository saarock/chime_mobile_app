import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

// ==================== Init dependencies ====================== //
Future initDependencies() async {
  await _initSplashModule();
  await _initLoginModule();
  await _initRegisterModule();
}

// =============== Splash module init method ==================== //
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

// ============== login module init method =============== //
Future<void> _initLoginModule() async {
  serviceLocator.registerFactory(() => LoginViewModel());
}

// ============== register module init method =============== //
Future<void> _initRegisterModule() async {
  serviceLocator.registerFactory(() => RegsiterViewModel());
}
