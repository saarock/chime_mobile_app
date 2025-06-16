import 'package:chime/core/network/api_service.dart';
import 'package:chime/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:chime/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

final serviceLocator = GetIt.instance;

// ==================== Init dependencies ====================== //
Future initDependencies() async {
  await _initApiModule();
  await _initSplashModule();
  await _initLoginModule();
  await _initAuthModule();
}

// Api module init
Future<void> _initApiModule() async {
  // Dio instance
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

// =============== Splash module init method ==================== //
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

// ============== login module init method =============== //
Future<void> _initLoginModule() async {
  serviceLocator.registerFactory(
    () => LoginViewModel(serviceLocator<UserLoginWithGoogleUsecase>()),
  );
}

// ============== register module init method =============== //
Future<void> _initAuthModule() async {
  // Register data source
  serviceLocator.registerFactory(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  //  Register repo
  serviceLocator.registerFactory(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // Regsiter user case
  serviceLocator.registerFactory(
    () => UserLoginWithGoogleUsecase(
      userRepository: serviceLocator<UserRemoteRepository>(),
    ),
  );

  serviceLocator.registerFactory(() => RegsiterViewModel());
}
