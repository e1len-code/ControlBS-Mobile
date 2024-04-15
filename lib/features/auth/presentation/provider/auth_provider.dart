import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:controlbs_mobile/features/auth/domain/useCase/auth_usecase.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthUseCase useCase;

  AuthProvider({required this.useCase});

  bool isLoading = false;
  AuthResponse authResponse = AuthResponse(id: 0);
  String error = '';

  Future<AuthResponse> authLogin(AuthRequest authRequest) async {
    isLoading = true;
    error = '';
    notifyListeners();

    final auth = await useCase.authLogin(authRequest);
    auth.fold(
        (failure) => error = failure.message, (auth) => authResponse = auth!);
    isLoading = false;
    notifyListeners();
    return authResponse;
  }

  Future<AuthResponse> authLoginLocal() async {
    isLoading = true;
    error = '';
    notifyListeners();

    final auth = await useCase.authLoginLocal();
    auth.fold(
        (failure) => error = failure.message, (auth) => authResponse = auth!);
    isLoading = false;
    notifyListeners();
    return authResponse;
  }

  Future<void> logOut() async {
    authResponse = AuthResponse(id: 0);
    notifyListeners();
  }
}
