import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:controlbs_mobile/features/file/domain/useCase/file_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'file_provider_event.dart';
part 'file_provider_state.dart';

class FileProviderBloc extends Bloc<FileProviderEvent, FileProviderState> {
  final FileUseCase useCase;
  FileProviderBloc({required this.useCase}) : super(FileProviderInitial()) {
    on<SaveFileEvent>(save);
    on<GetFileEvent>(getPhoto);
  }
  Future<void> save(
      SaveFileEvent event, Emitter<FileProviderState> emit) async {
    emit(LoadingState());
    final response = await useCase.save(event.file);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(SavedState(saved: r)));
  }

  Future<void> getPhoto(
      GetFileEvent event, Emitter<FileProviderState> emit) async {
    emit(LoadingState());
    final response = await useCase.getPhoto(event.filePath);
    response.fold((l) => emit(ErrorState(message: l.message)),
        (r) => emit(GotPhotoState(photoImg: r)));
  }
}
