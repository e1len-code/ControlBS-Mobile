part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class SaveUserEvent extends UserEvent {
  final User user;

  const SaveUserEvent(this.user);

  @override
  List<Object> get props => [user];
}

class GetUserEvent extends UserEvent {
  final int userIden;

  const GetUserEvent(this.userIden);

  @override
  List<Object> get props => [userIden];
}

class UpdateUserPassword extends UserEvent {
  final PersUpdatePass user;

  const UpdateUserPassword(this.user);
}
