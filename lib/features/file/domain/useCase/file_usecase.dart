import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/features/file/data/repository/file_repository.dart';
import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:dartz/dartz.dart';

abstract class FileUseCase {
  Future<Either<Failure, bool?>> save(File file);
  Future<Either<Failure, String?>> getPhoto(String filePath);
}

class FileUseCaseImple implements FileUseCase {
  final FileRepository repository;

  FileUseCaseImple({required this.repository});

  @override
  Future<Either<Failure, bool?>> save(File file) async {
    return repository.save(file);
  }

  @override
  Future<Either<Failure, String?>> getPhoto(String filePath) async {
    return repository.getPhoto(filePath);
  }
}
