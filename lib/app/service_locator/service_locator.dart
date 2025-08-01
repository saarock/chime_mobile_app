import 'package:chime/core/network/api_service.dart';
import 'package:chime/core/network/hive_service.dart';
import 'package:chime/features/auth/data/data_source/remote_datasource/user_remote_datasource.dart';
import 'package:chime/features/auth/data/repository/remote_repository/user_remote_repository.dart';
import 'package:chime/features/auth/domain/repository/user_repository.dart';
import 'package:chime/features/auth/domain/use_case/update_user_info.usecase.dart';
import 'package:chime/features/auth/domain/use_case/user_login_with_google_usecase.dart';
import 'package:chime/features/auth/domain/use_case/user_verify_usecase.dart';
import 'package:chime/features/auth/presentation/view_model/login_view_model/login_view_model.dart';
import 'package:chime/features/auth/presentation/view_model/register_view_model/regsiter_view_model.dart';
import 'package:chime/features/home/presentation/view_model/home_view_model.dart';
import 'package:chime/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:chime/features/splash/presentation/view_model/splash_view_model.dart';
import 'package:chime/features/video-call/data/data_source/remote_datasource/video_call_datasource.dart';
import 'package:chime/features/video-call/data/data_source/video_call_datasource.dart';
import 'package:chime/features/video-call/data/repository/remote_repository/user_video_remote_repository.dart';
import 'package:chime/features/video-call/data/sensors/sensor_service.dart';
import 'package:chime/features/video-call/domain/repository/video_call_repository.dart';
import 'package:chime/features/video-call/domain/use_case/create_peer_connection_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/end_call_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/get_localstream_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_answer_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_ice_candidate_usecase.dart';
import 'package:chime/features/video-call/domain/use_case/send_offer_usecase.dart';
import 'package:chime/features/video-call/presentation/view_model/video_view_model.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

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
  await _notificationServiceInit();
}

// Notification
Future<void> _notificationServiceInit() async {
  // await NotificationService.init();
  // serviceLocator.registerLazySingleton<NotificationService>(
  //   () => NotificationService(),
  // );
}

// Home
Future<void> _initHomeModule() async {
  serviceLocator.registerFactory(
    () => HomeViewModel(loginViewModel: serviceLocator<LoginViewModel>()),
  );
}

// Profile
Future<void> _initProfileModule() async {
  // Make sure the IUserRepository is already registered in _initAuthModule
  if (!serviceLocator.isRegistered<IUserRepository>()) {
    throw Exception(
      "IUserRepository is not registered. Please check _initAuthModule.",
    );
  }

  // Register the use case: UpdateUserInfoUseCase
  if (!serviceLocator.isRegistered<UpdateUserInfoUseCase>()) {
    serviceLocator.registerLazySingleton<UpdateUserInfoUseCase>(
      () => UpdateUserInfoUseCase(
        userRepository: serviceLocator<IUserRepository>(),
      ),
    );
  }

  // Register the ProfileBloc
  serviceLocator.registerFactory<ProfileBloc>(
    () => ProfileBloc(
      updateUserInfoUseCase: serviceLocator<UpdateUserInfoUseCase>(),
    ),
  );
}

// Video (register your VideoBloc here here)
Future<void> _initVideoModule() async {
  // Register SensorService
  if (!serviceLocator.isRegistered<SensorService>()) {
    serviceLocator.registerLazySingleton<SensorService>(() => SensorService());
  }

  // Register the data source first
  if (!serviceLocator.isRegistered<IVideoCallDataSource>()) {
    serviceLocator.registerLazySingleton<IVideoCallDataSource>(
      () => VideoCallDataSourceImpl(), // your concrete implementation here
    );
  }
  // Register the repository if not registered yet
  if (!serviceLocator.isRegistered<IVideoCallRepository>()) {
    serviceLocator.registerLazySingleton<IVideoCallRepository>(
      () => VideoCallRepositoryImpl(
        serviceLocator<
          IVideoCallDataSource
        >(), // <-- inject the data source here
      ),
    );
  }

  // Make sure all the use cases are registered before VideoBloc
  if (!serviceLocator.isRegistered<SendOfferUseCase>()) {
    serviceLocator.registerLazySingleton<SendOfferUseCase>(
      () => SendOfferUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<SendAnswerUseCase>()) {
    serviceLocator.registerLazySingleton<SendAnswerUseCase>(
      () => SendAnswerUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<SendIceCandidateUseCase>()) {
    serviceLocator.registerLazySingleton<SendIceCandidateUseCase>(
      () => SendIceCandidateUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<EndCallUseCase>()) {
    serviceLocator.registerLazySingleton<EndCallUseCase>(
      () => EndCallUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<GetLocalStreamUseCase>()) {
    serviceLocator.registerLazySingleton<GetLocalStreamUseCase>(
      () => GetLocalStreamUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }
  if (!serviceLocator.isRegistered<CreatePeerConnectionUseCase>()) {
    serviceLocator.registerLazySingleton<CreatePeerConnectionUseCase>(
      () => CreatePeerConnectionUseCase(serviceLocator<IVideoCallRepository>()),
    );
  }

  // Finally, register the VideoBloc with all dependencies injected
  serviceLocator.registerFactory<VideoBloc>(
    () => VideoBloc(
      repository: serviceLocator<IVideoCallRepository>(),
      sendOfferUseCase: serviceLocator<SendOfferUseCase>(),
      sendAnswerUseCase: serviceLocator<SendAnswerUseCase>(),
      sendIceCandidateUseCase: serviceLocator<SendIceCandidateUseCase>(),
      endCallUseCase: serviceLocator<EndCallUseCase>(),
      getLocalStreamUseCase: serviceLocator<GetLocalStreamUseCase>(),
      sensorService: serviceLocator<SensorService>(),
      createPeerConnectionUseCase:
          serviceLocator<CreatePeerConnectionUseCase>(),
    ),
  );
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
  serviceLocator.registerFactory(
    () => SplashViewModel(serviceLocator<LoginViewModel>()),
  );
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

  serviceLocator.registerFactory<UserVerifyUsecase>(
    () => UserVerifyUsecase(userRepository: serviceLocator<IUserRepository>()),
  );

  // ViewModels
  serviceLocator.registerFactory<LoginViewModel>(
    () => LoginViewModel(
      serviceLocator<UserLoginWithGoogleUsecase>(),
      serviceLocator<UserVerifyUsecase>(),
    ),
  );

  serviceLocator.registerFactory<RegsiterViewModel>(() => RegsiterViewModel());
}
