import 'dart:async';

import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/auth/data/datasource/auth_remote_data.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class AuthRepository {
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest);
}

class AuthRespositoryImple implements AuthRepository {
  final AuthRemoteData remoteData;

  AuthRespositoryImple({required this.remoteData});

  @override
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        final response = await remoteData.auth(authRequest);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure());
    }
  }
}
