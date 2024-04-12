import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/auth/data/repository/auth_repository.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:dartz/dartz.dart';

abstract class AuthUseCase {
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest);
}

class AuthUseCaseImpl implements AuthUseCase {
  final AuthRepository authRepository;
  AuthUseCaseImpl({required this.authRepository});
  @override
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest) async {
    if (authRequest.userName!.trim() == "" ||
        authRequest.password!.trim() == "") {
      return Left(DataFailure(message: "Usuario y/o contraseña esta vacío"));
    } else {
      final response = await authRepository.authLogin(authRequest);
      return response;
    }
  }
}
