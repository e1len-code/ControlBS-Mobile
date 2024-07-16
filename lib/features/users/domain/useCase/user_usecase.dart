import 'package:controlbs_mobile/core/errors/failures.dart';
import 'package:controlbs_mobile/core/utils/crypto.dart';
import 'package:controlbs_mobile/features/users/data/repository/user_repository.dart';
import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user_break.dart';
import 'package:dartz/dartz.dart';

abstract class UserUseCase {
  Future<Either<Failure, bool?>> save(User oUser);
  Future<Either<Failure, List<User?>>> list();
  Future<Either<Failure, User?>> get(int persIden);
  Future<Either<Failure, bool?>> updatePassword(PersUpdatePass persUpdatePass);
  Future<Either<Failure, List<UserBreak?>?>> getBreakList();
}

class UserUseCaseImple implements UserUseCase {
  final UserRepository repository;

  UserUseCaseImple({required this.repository});
  @override
  Future<Either<Failure, List<User?>>> list() {
    return repository.list();
  }

  @override
  Future<Either<Failure, bool?>> save(User oUser) async {
    if (oUser.persPass?.trim() != "") {
      oUser.persPass = encrypt(oUser.persPass!).base16;
    } else {
      var user = await get(oUser.persIden);
      if (user.isRight()) {
        oUser.persPass = user.getOrElse(() => null)!.persPass;
      } else {
        return Left(DataFailure(message: "Error al obtener la contraseña"));
      }
    }

    return repository.save(oUser);
  }

  @override
  Future<Either<Failure, User?>> get(int persIden) {
    return repository.get(persIden);
  }

  @override
  Future<Either<Failure, List<UserBreak?>?>> getBreakList() {
    return repository.getListBreak();
  }

  @override
  Future<Either<Failure, bool?>> updatePassword(PersUpdatePass persUpdatePass) {
    persUpdatePass.persPass = encrypt(persUpdatePass.persPass).base16;
    return repository.updatePassword(persUpdatePass);
  }
}
