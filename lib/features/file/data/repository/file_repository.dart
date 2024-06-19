import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/features/file/data/datasource/file_remote_data.dart';
import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:dartz/dartz.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class FileRepository {
  Future<Either<Failure, bool?>> save(File file);
  Future<Either<Failure, String?>> getPhoto(String filePath);
}

class FileRepositoryImple implements FileRepository {
  final FileRemoteData remoteData;

  FileRepositoryImple({required this.remoteData});

  @override
  Future<Either<Failure, bool?>> save(File file) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.save(file);
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
  Future<Either<Failure, String?>> getPhoto(String filePath) async {
    try {
      bool connected = await InternetConnection().hasInternetAccess;
      if (connected) {
        await getIt<Headers>().validateToken();
        final response = await remoteData.getPhoto(filePath);
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
}
