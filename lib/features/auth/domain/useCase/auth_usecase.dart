import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/utils/crypto.dart';
import 'package:controlbs_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/acceso.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:dartz/dartz.dart';

abstract class AuthUseCase {
  Future<Either<Failure, AuthResponse?>> authLogin(AuthRequest authRequest);
  Future<Either<Failure, AuthResponse?>> authLoginLocal();
  Future<Either<Failure, List<AuthAccess?>>> authAccess(int persIden);
  Future<void> delete();
}

class AuthUseCaseImpl implements AuthUseCase {
  final AuthRepository authRepository;
  AuthUseCaseImpl({required this.authRepository});
  @override
  Future<Either<Failure, AuthResponse?>> authLogin(
      AuthRequest authRequest) async {
    if (authRequest.userName!.trim() == "" ||
        authRequest.password!.trim() == "") {
      return Left(DataFailure(message: "Usuario y/o contraseña esta vacío"));
    } else {
      authRequest.password = encrypt(authRequest.password!).base16;
      final response = await authRepository.authLogin(authRequest);
      return response.fold(
          (failure) => Left(DataFailure(message: failure.message)), (response) {
        authRepository.saveAuth(authRequest);
        return Right(response.value);
      });
    }
  }

  @override
  Future<Either<Failure, List<AuthAccess?>>> authAccess(int persIden) async {
    final response = await authRepository.authAccess(persIden);
    return response.fold(
        (failure) => Left(DataFailure(message: failure.message)),
        (auth) => Right(auth));
  }

  @override
  Future<Either<Failure, AuthResponse?>> authLoginLocal() async {
    final response = await authRepository.verifyLogin();
    return response.fold(
        (failure) => Left(DataFailure(message: failure.message)),
        (auth) => Right(auth));
  }

  @override
  Future<void> delete() async {
    await authRepository.delete();
  }
}
