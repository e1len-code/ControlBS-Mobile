import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/domain/useCase/user_usecase.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  final UserUseCase useCase;
  UserProvider({required this.useCase});

  List<User?> listUsers = [];
  User? user;

  bool isLoading = false;
  String error = '';
  bool saved = false;

  Future<int> list() async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.list();
    result.fold(
        (failure) => error = failure.message, (list) => listUsers = list);
    isLoading = false;
    notifyListeners();
    return listUsers.length;
  }

  Future<User?> getUser(int oUserIden) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.get(oUserIden);
    result.fold((failure) => error = failure.message, (value) => user = value);
    isLoading = false;
    notifyListeners();
    return user;
  }

  Future<bool> save(User oUser) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.save(oUser);
    result.fold(
        (failure) => error = failure.message, (saved) => this.saved = saved!);
    final result2 = await useCase.list();
    result2.fold(
        (failure) => error = failure.message, (list) => listUsers = list);
    isLoading = false;
    notifyListeners();
    return saved;
  }

  Future<bool> updatePassword(PersUpdatePass persUpdatePass) async {
    isLoading = true;
    error = '';
    notifyListeners();
    final result = await useCase.updatePassword(persUpdatePass);
    result.fold(
        (failure) => error = failure.message, (saved) => this.saved = saved!);
    isLoading = false;
    notifyListeners();
    return saved;
  }
}
