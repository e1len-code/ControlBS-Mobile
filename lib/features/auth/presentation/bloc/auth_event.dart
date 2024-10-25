part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthReqEvent extends AuthEvent {
  final AuthRequest authRequest;

  AuthReqEvent(this.authRequest);

  @override
  List<Object> get props => [authRequest];
}

class AuthLoginEvent extends AuthEvent {}

class LogOutEvent extends AuthEvent {}
