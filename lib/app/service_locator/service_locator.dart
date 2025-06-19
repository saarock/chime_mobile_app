import 'package:chime/core/network/api_service.dart';
import 'package:chime/core/network/cookie_interceptor.dart';
import 'package:chime/core/network/hive_service.dart';
import 'package:chime/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:chime/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:chime/features/auth/domain/repository/student_repository.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

// ==================== Init dependencies ====================== //
Future<void> initDependencies() async {
  await _initApiModule();
  await _initSplashModule();
  await _initAuthModule(); // Login & Register both here
  await _initLocalStorageModule();
  await _initVideoModule(); // Register VideoCubit here
  await _initHomeModule();
  await _initProfileModule();
}

// Home
Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

// Profile
Future<void> _initProfileModule() async {}

// Video (register your VideoCubit here)
Future<void> _initVideoModule() async {
  serviceLocator.registerFactory(() => VideoCubit());
}

// ========== Local Storage Module ==========
Future<void> _initLocalStorageModule() async {
  final hiveService = HiveService();
  await hiveService.init();
  serviceLocator.registerSingleton<HiveService>(hiveService);
}

// ========== API Module ==========
Future<void> _initApiModule() async {
  serviceLocator.registerLazySingleton<Dio>(() => Dio());
  serviceLocator.registerLazySingleton(() => ApiService(serviceLocator<Dio>()));
}

// ========== Splash ViewModel ==========
Future<void> _initSplashModule() async {
  serviceLocator.registerFactory(() => SplashViewModel());
}

// ========== Auth Module: Login + Register ==========
Future<void> _initAuthModule() async {
  // Data Source
  serviceLocator.registerFactory<UserRemoteDatasource>(
    () => UserRemoteDatasource(apiService: serviceLocator<ApiService>()),
  );

  // Repository registered as interface IUserRepository
  serviceLocator.registerFactory<IUserRepository>(
    () => UserRemoteRepository(
      userRemoteDatasource: serviceLocator<UserRemoteDatasource>(),
    ),
  );

  // Use Case
  serviceLocator.registerFactory<UserLoginWithGoogleUsecase>(
    () => UserLoginWithGoogleUsecase(
      userRepository: serviceLocator<IUserRepository>(),
    ),
  );

  // ViewModels
  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(serviceLocator<UserLoginWithGoogleUsecase>()),
  );

  serviceLocator.registerFactory<RegsiterViewModel>(() => RegsiterViewModel());
}
