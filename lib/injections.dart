import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/features/attendance/data/datasource/attendance_remote_data.dart';
import 'package:controlbs_mobile/features/attendance/data/repository/attendance_repository.dart';
import 'package:controlbs_mobile/features/attendance/domain/useCase/attendance_usecase.dart';
import 'package:controlbs_mobile/features/attendance/presentation/provider/attendance_provider.dart';
import 'package:controlbs_mobile/features/auth/data/datasource/auth_local_data.dart';
import 'package:controlbs_mobile/features/auth/domain/useCase/auth_usecase.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/file/data/datasource/file_remote_data.dart';
import 'package:controlbs_mobile/features/file/data/repository/file_repository.dart';
import 'package:controlbs_mobile/features/file/domain/useCase/file_usecase.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:controlbs_mobile/features/users/data/datasource/user_remote_data.dart';
import 'package:controlbs_mobile/features/users/data/repository/user_repository.dart';
import 'package:controlbs_mobile/features/users/domain/useCase/user_usecase.dart';
import 'package:controlbs_mobile/features/users/presentation/provider/user_provider.dart';
import 'package:http/http.dart' as client;
import 'package:controlbs_mobile/features/auth/data/datasource/auth_remote_data.dart';
import 'package:controlbs_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => AuthProvider(useCase: getIt()));
  getIt.registerFactory(() => AttendanceProvider(useCase: getIt()));
  getIt.registerFactory(() => FileProvider(useCase: getIt()));
  getIt.registerFactory(() => UserProvider(useCase: getIt()));

  getIt.registerLazySingleton<AuthUseCase>(
      () => AuthUseCaseImpl(authRepository: getIt()));
  getIt.registerLazySingleton<AttendanceUseCase>(
      () => AttendanceUseCaseImple(repository: getIt()));
  getIt.registerLazySingleton<FileUseCase>(
      () => FileUseCaseImple(repository: getIt()));
  getIt.registerLazySingleton<UserUseCase>(
      () => UserUseCaseImple(repository: getIt()));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRespositoryImple(remoteData: getIt(), localData: getIt()));
  getIt.registerLazySingleton<AttendanceRepository>(
      () => AttendanceRepositoryImple(remoteData: getIt()));
  getIt.registerLazySingleton<FileRepository>(
      () => FileRepositoryImple(remoteData: getIt()));
  getIt.registerLazySingleton<UserRepository>(
      () => UserRepositoryImple(remoteData: getIt()));

  getIt.registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImple(client: getIt()));
  getIt.registerLazySingleton<AttendanceRemoteData>(
      () => AttendanceRemoteDataImple(client: getIt()));
  getIt.registerLazySingleton<FileRemoteData>(
      () => FileRemoteDataImple(client: getIt()));
  getIt.registerLazySingleton<UserRemoteData>(
      () => UserRemoteDataImple(client: getIt()));

  getIt.registerLazySingleton<AuthLocalData>(() => AuthLocalDataImple());
  getIt.registerLazySingleton(() => client.Client());
  getIt.registerLazySingleton(() => Headers());
}
