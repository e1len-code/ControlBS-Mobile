part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

final class AuthInitial extends AuthState {}

class LoadingState extends AuthState {}

class ErrorState extends AuthState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class AuthenticatedState extends AuthState {
  final AuthResponse? authResponse;

  const AuthenticatedState({required this.authResponse});

  @override
  List<Object> get props => [authResponse!];
}
