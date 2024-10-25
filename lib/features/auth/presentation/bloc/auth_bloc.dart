import 'package:controlbs_mobile/features/auth/domain/entities/acceso.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:controlbs_mobile/features/auth/domain/useCase/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase useCase;
  //variables bloc
  List<AuthAccess?> listAuthAccess = [];
  AuthResponse? authResponse = AuthResponse(id: 0, token: "");

  AuthBloc({required this.useCase}) : super(AuthInitial()) {
    on<AuthReqEvent>(_authLogin);
    on<AuthLoginEvent>(_authLoginLocal);
    on<LogOutEvent>(_logOut);
  }

  Future<void> _authLogin(AuthReqEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final response = await useCase.authLogin(event.authRequest);
    response.fold((l) => emit(ErrorState(message: l.message)), (r) {
      authResponse = r;
      emit(AuthenticatedState(authResponse: r));
    });
    final responseAuthAccess = await useCase.authAccess(authResponse?.id ?? 0);
    responseAuthAccess.fold(
        (l) => emit(ErrorState(message: l.message)), (r) => listAuthAccess = r);
  }

  Future<void> _authLoginLocal(
      AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final response = await useCase.authLoginLocal();
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => AuthenticatedState(authResponse: r));
  }

  Future<void> _logOut(LogOutEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    await useCase.delete();
    emit(LogOutState());
  }
}
