import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/features/auth/domain/useCase/auth_usecase.dart';
import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:http/http.dart' as client;
import 'package:controlbs_mobile/features/auth/data/datasource/auth_remote_data.dart';
import 'package:controlbs_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  getIt.registerFactory(() => AuthProvider(useCase: getIt()));

  getIt.registerLazySingleton<AuthUseCase>(
      () => AuthUseCaseImpl(authRepository: getIt()));

  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRespositoryImple(remoteData: getIt()));

  getIt.registerLazySingleton<AuthRemoteData>(
      () => AuthRemoteDataImple(client: getIt()));

  getIt.registerLazySingleton(() => client.Client());
  getIt.registerLazySingleton(() => Headers());
}
