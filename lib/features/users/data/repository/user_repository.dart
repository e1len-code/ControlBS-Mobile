import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/features/users/data/datasource/user_remote_data.dart';
import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user_break.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class UserRepository {
  Future<Either<Failure, bool?>> save(User oUser);
  Future<Either<Failure, List<User?>>> list();
  Future<Either<Failure, User?>> get(int persIden);
  Future<Either<Failure, bool?>> updatePassword(PersUpdatePass persUpdatePass);
  Future<Either<Failure, List<UserBreak?>?>> getListBreak();
}

class UserRepositoryImple implements UserRepository {
  final UserRemoteData remoteData;

  UserRepositoryImple({required this.remoteData});

  @override
  Future<Either<Failure, List<User?>>> list() async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.list();
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, List<UserBreak?>?>> getListBreak() async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        //await getIt<Headers>().validateToken();
        final List<UserBreak?>? response = await remoteData.getListBreak();
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: ""));
    }
  }

  @override
  Future<Either<Failure, bool?>> save(User oUser) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.save(oUser);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: "Error intentelo mas tarde"));
    }
  }

  @override
  Future<Either<Failure, User?>> get(int oPersIden) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.get(oPersIden);
        return Right(response);
      } else {
        return Left(ConexionInternetFailure());
      }
    } on TimeOutException {
      return Left(TimeOutFailure());
    } on ApiResponseException catch (m) {
      return Left(ApiResponseFailure(message: m.firstMessageError));
    } catch (ex) {
      return Left(ServerFailure(message: "Error intentelo mas tarde"));
    }
  }

  @override
  Future<Either<Failure, bool?>> updatePassword(
      PersUpdatePass persUpdatePass) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        final response = await remoteData.updatePassword(persUpdatePass);
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
