import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:controlbs_mobile/features/auth/domain/useCase/auth_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthUseCase useCase;
  AuthBloc({required this.useCase}) : super(AuthInitial()) {
    on<AuthLoginEvent>(authLogin);
  }
  Future<void> authLogin(AuthLoginEvent event, Emitter<AuthState> emit) async {
    emit(LoadingState());
    final response = await useCase.authLogin(event.authRequest);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => AuthenticatedState(authResponse: r));
  }
}
