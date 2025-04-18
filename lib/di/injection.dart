import 'dart:async';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:my_yojana/features/home/domain/use_cases/create_bookmark_usecase.dart';
import 'package:my_yojana/features/home/domain/use_cases/delete_bookmark_usecase.dart';
import 'package:my_yojana/features/home/domain/use_cases/get_scheme_id_usecase.dart';
import 'package:my_yojana/features/home/domain/use_cases/get_scheme_uecase.dart';
import 'package:my_yojana/features/home/domain/use_cases/get_top_rated_scheme_usecase.dart';
import 'package:my_yojana/features/home/presentation/manager/scheme_manger.dart';
import 'package:my_yojana/features/user/domain/repositories/user_repository.dart';
import 'package:my_yojana/features/user/domain/usecases/delete_user_usecase.dart';
import 'package:my_yojana/features/user/domain/usecases/get_user_usecase.dart';
import 'package:my_yojana/features/user/domain/usecases/update_user_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/services/firebase_auth_service.dart';
import '../core/services/storage_service.dart';
import '../core/utils/custom_interceptors.dart';
import '../core/utils/http_utils.dart';
import '../features/auth/data/data_source/auth_data_source.dart';
import '../features/auth/data/data_source/auth_data_source_implementation.dart';
import '../features/auth/data/repositories/auth_repository_implementation.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/use_cases/check_user_uecase.dart';
import '../features/auth/domain/use_cases/login_user_usecase.dart';
import '../features/auth/domain/use_cases/logout_usecase.dart';
import '../features/auth/domain/use_cases/register_user_usecase.dart';
import '../features/auth/presentation/manager/auth_manger.dart';
import '../features/home/data/data_source/scheme_data_source.dart';
import '../features/home/data/data_source/scheme_data_source_implementation.dart';
import '../features/home/data/repositories/scheme_repository_implementation.dart';
import '../features/home/domain/repositories/scheme_repository.dart';
import '../features/home/domain/use_cases/get_bookmark_usecase.dart';
import '../features/home/domain/use_cases/rate_scheme_usecase.dart';
import '../features/user/data/datasources/user_data_source.dart';
import '../features/user/data/datasources/user_data_source_implementation.dart';
import '../features/user/data/repositories/user_repository_implementation.dart';
import '../features/user/presentation/manager/user_manager.dart';
import '../firebase_options.dart';

final GetIt getIt = GetIt.instance;

class Injection {
  static _initSystemSettings() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  static Future<void> _registerFirebase() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    getIt.registerSingleton<FirebaseAuthService>(
        FirebaseAuthServiceImpl(firebaseAuth: FirebaseAuth.instance, googleSignIn: GoogleSignIn()));
  }

  static Future<void> _initServicesAndUtils() async {
    // SharedPreferences
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    getIt.registerSingleton<SharedPreferences>(preferences);

    // Local Storage
    getIt.registerSingleton<LocalStorage>(
        LocalStorageImpl(getIt<SharedPreferences>()));

    // REST API Call
    final Dio dio = Dio();
    dio.interceptors.add(CustomInterceptor());
    getIt.registerSingleton<Dio>(dio);

    // Temp
    // getIt.registerSingleton<http.Client>(http.Client());

    getIt.registerSingleton<AppHttp>(
        AppHttpImpl(getIt<Dio>(), getIt<LocalStorage>()));
  }

  static Future<void> _initialDependency() async {
    /// Auth
    // Data source
    getIt.registerLazySingleton<AuthDataSource>(
          () =>
          AuthDataSoruceImplementation(getIt<AppHttp>(), getIt<LocalStorage>()),
    );

    // Repository
    getIt.registerLazySingleton<AuthRepository>(
            () => AuthRepositoryImplementation(getIt<AuthDataSource>()));

    // UseCases
    getIt.registerLazySingleton<LoginUserUseCase>(
            () => LoginUserUseCase(authRepository: getIt<AuthRepository>()));

    getIt.registerLazySingleton<LogoutUseCase>(
            () => LogoutUseCase(authRepository: getIt<AuthRepository>()));

    getIt.registerLazySingleton<RegisterUserUseCase>(
            () => RegisterUserUseCase(getIt<AuthRepository>()));

    getIt.registerLazySingleton<CheckUserUseCase>(
            () => CheckUserUseCase(getIt<AuthRepository>()));

    /// Auth End

    ///User

    //Data Source
    getIt.registerLazySingleton<UserDataSource>(
            () => UserDataSourceImplementation(getIt<AppHttp>()));

    // Repository
    getIt.registerLazySingleton<UserRepository>(
            () => UserRepositoryImplementation(getIt<UserDataSource>()));

    //Use cases
    getIt.registerLazySingleton<GetUserUseCase>(
            () => GetUserUseCase(getIt<UserRepository>()));

    getIt.registerLazySingleton<DeleteUserUseCase>(
        () => DeleteUserUseCase(getIt<UserRepository>()));

    getIt.registerLazySingleton<UpdateUserUseCase>(
            () => UpdateUserUseCase(getIt<UserRepository>()));

    ///Scheme
    //Data Source
    getIt.registerLazySingleton<SchemeDataSource>(
            () => SchemeDataSourceImplementation(getIt<AppHttp>()));

    // Repository
    getIt.registerLazySingleton<SchemeRepository>(
            () => SchemeRepositoryImplementation(getIt<SchemeDataSource>()));

    //Use cases
    getIt.registerLazySingleton<GetSchemeUseCase>(
            () => GetSchemeUseCase(getIt<SchemeRepository>()));

    getIt.registerLazySingleton<GetSchemeIdUseCase>(
        () => GetSchemeIdUseCase(getIt<SchemeRepository>()));

    getIt.registerLazySingleton<RateSchemeUseCase>(
        () => RateSchemeUseCase(getIt<SchemeRepository>())
    );

    getIt.registerLazySingleton<CreateBookmarkUseCase>(
            () => CreateBookmarkUseCase(getIt<SchemeRepository>())
    );

    getIt.registerLazySingleton<DeleteBookmarkUseCase>(
            () => DeleteBookmarkUseCase(getIt<SchemeRepository>())
    );

    getIt.registerLazySingleton<GetBookmarkUseCase>(
            () => GetBookmarkUseCase(getIt<SchemeRepository>())
    );

    getIt.registerLazySingleton<GetTopRatedSchemeUseCase>(
            () => GetTopRatedSchemeUseCase(getIt<SchemeRepository>())
    );




  }

  static FirebaseAuthService get firebaseAuthService =>
      getIt<FirebaseAuthService>();

  static AuthManager get authManager => AuthManager(
    firebaseAuthService: firebaseAuthService,
    loginUserUseCase: getIt<LoginUserUseCase>(),
    localStorage: getIt<LocalStorage>(),
    logoutUseCase: getIt<LogoutUseCase>(),
    registerUserUseCase: getIt<RegisterUserUseCase>(),
    checkUserUseCase: getIt<CheckUserUseCase>(),
  );

  static UserManager get userManager =>
      UserManager(getUserUseCase: getIt<GetUserUseCase>(),
      deleteUserUseCase: getIt<DeleteUserUseCase>(),
      updateUserUseCase: getIt<UpdateUserUseCase>());

  static SchemeManager get schemeManager =>
      SchemeManager(getSchemeUseCase: getIt<GetSchemeUseCase>(),
      getBookmarkUseCase: getIt<GetBookmarkUseCase>(),
      deleteBookmarkUseCase: getIt<DeleteBookmarkUseCase>(),
      getTopRatedSchemeUseCase: getIt<GetTopRatedSchemeUseCase>(),
      getSchemeIdUseCase: getIt<GetSchemeIdUseCase>(),
        rateSchemeUseCase: getIt<RateSchemeUseCase>(),
        createBookmarkUseCase: getIt<CreateBookmarkUseCase>(),);



  static init() async {
    await _initSystemSettings();
    await _registerFirebase();
    await _initServicesAndUtils();
    await _initialDependency();
  }
}
