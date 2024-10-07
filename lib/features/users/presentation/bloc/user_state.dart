part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

final class UserInitial extends UserState {}

class LoadingState extends UserState {}

class ErrorState extends UserState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class GotListState extends UserState {
  final List<User?> userList;
  const GotListState({required this.userList});

  @override
  List<Object> get props => [userList!];
}

class GotUserState extends UserState {
  final User? user;
  const GotUserState({required this.user});

  @override
  List<Object> get props => [user!];
}

class SavedUserState extends UserState {
  final bool? saved;
  const SavedUserState({this.saved});

  @override
  List<Object> get props => [saved!];
}

class GotListBreakState extends UserState {
  final List<UserBreak?>? userList;
  const GotListBreakState({required this.userList});

  @override
  List<Object> get props => [userList!];
}
