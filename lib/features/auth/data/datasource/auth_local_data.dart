import 'package:controlbs_mobile/core/utils/store_manager.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';

abstract class AuthLocalData {
  Future<AuthRequest> getAuth();
  Future<void> saveAuth(AuthRequest auth);
}

class AuthLocalDataImple implements AuthLocalData {
  @override
  Future<AuthRequest> getAuth() async {
    final String userName = await StorageManager.readData('userName');
    final String password = await StorageManager.readData('password');
    return AuthRequest(userName: userName, password: password);
  }

  @override
  Future<void> saveAuth(AuthRequest auth) async {
    await StorageManager.saveData('userName', auth.userName);
    await StorageManager.saveData('password', auth.password);
  }
}
