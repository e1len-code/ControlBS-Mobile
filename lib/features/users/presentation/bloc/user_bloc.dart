import 'package:bloc/bloc.dart';
import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user_break.dart';
import 'package:controlbs_mobile/features/users/domain/useCase/user_usecase.dart';
import 'package:equatable/equatable.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserUseCase useCase;
  //variablesBloc
  List<UserBreak?>? listBreak = [];
  UserBloc({required this.useCase}) : super(UserInitial()) {
    on<UserListEvent>(getList);
    on<GetUserEvent>(getUser);
    on<SaveUserEvent>(save);
    on<GetBreakListEvent>(gestListBreak);
    on<UpdateUserPassword>(updatePassword);
  }
  Future<void> getList(UserListEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final response = await useCase.list();
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(GotListState(userList: r)));
  }

  Future<void> getUser(GetUserEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final response = await useCase.get(event.userIden);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(GotUserState(user: r)));
  }

  Future<void> save(SaveUserEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final response = await useCase.save(event.user);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(SavedUserState(saved: r)));
  }

  Future<void> gestListBreak(UserEvent event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final response = await useCase.getBreakList();
    response.fold((l) => emit(ErrorState(message: l.message)), (r) {
      listBreak = r;
      emit(GotListBreakState(userList: r));
    });
  }

  Future<void> updatePassword(
      UpdateUserPassword event, Emitter<UserState> emit) async {
    emit(LoadingState());
    final response = await useCase.updatePassword(event.user);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(SavedUserState(saved: r)));
  }
}
