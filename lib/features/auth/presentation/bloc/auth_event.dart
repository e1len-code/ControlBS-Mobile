part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthLoginEvent extends AuthEvent {
  final AuthRequest authRequest;

  AuthLoginEvent(this.authRequest);

  @override
  List<Object> get props => [authRequest];
}
