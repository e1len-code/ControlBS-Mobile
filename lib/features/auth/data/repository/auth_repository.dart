import 'dart:async';

import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/auth/data/datasource/auth_local_data.dart';
import 'package:controlbs_mobile/features/auth/data/datasource/auth_remote_data.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class AuthRepository {
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest);
  Future<Either<Failure, AuthResponse?>> verifyLogin();
  Future<void> saveAuth(AuthRequest authRequest);
}

class AuthRespositoryImple implements AuthRepository {
  final AuthRemoteData remoteData;
  final AuthLocalData localData;

  AuthRespositoryImple({required this.remoteData, required this.localData});

  @override
  Future<Either<Failure, Data<AuthResponse?>>> authLogin(
      AuthRequest authRequest) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        final response = await remoteData.auth(authRequest);
        getIt<Headers>()
            .addHeader('Authorization', 'bearer ${response.value.token}');

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

  @override
  Future<Either<Failure, AuthResponse?>> verifyLogin() async {
    try {
      final response = await localData.getAuth();

      if (response.userName == '') {
        return Right(AuthResponse(id: 0));
      } else {
        bool connected = await InternetConnection().hasInternetAccess;
        if (connected) {
          final authEntity = await remoteData.auth(AuthRequest(
            userName: response.userName,
            password: response.password,
          ));
          getIt<Headers>()
              .addHeader('Authorization', 'bearer ${authEntity.value.token}');

          return Right(authEntity.value);
        } else {
          return Right(AuthResponse(id: 0));
        }
      }
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } on TimeOutException {
      return Left(
          TimeOutFailure(/* message: 'aqui el mensaje que quieras cambiar' */));
    } catch (ex) {
      return Left(ServerFailure(message: "Error al recuperar datos locales"));
    }
  }

  @override
  Future<void> saveAuth(AuthRequest authRequest) async {
    await localData.saveAuth(authRequest);
  }
}
