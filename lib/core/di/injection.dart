import 'package:auth_app/core/network/dio_client.dart';
import 'package:auth_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:auth_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:auth_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:auth_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:auth_app/features/auth/domain/usecases/register_usecase.dart';
import 'package:auth_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:auth_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

void setupDependencies() {
  sl.registerLazySingleton<DioClient>(DioClient.new);

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(sl()),
  );
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  sl.registerLazySingleton<LoginUseCase>(() => LoginUseCase(sl()));
  sl.registerLazySingleton<RegisterUseCase>(() => RegisterUseCase(sl()));
  sl.registerLazySingleton<VerifyOtpUseCase>(() => VerifyOtpUseCase(sl()));

  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyOtpUseCase: sl(),
    ),
  );
}
