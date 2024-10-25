part of 'file_provider_bloc.dart';

sealed class FileEvent extends Equatable {
  const FileEvent();

  @override
  List<Object> get props => [];
}

class SaveFileEvent extends FileEvent {
  final File file;

  const SaveFileEvent(this.file);

  @override
  List<Object> get props => [file];
}

class GetFileEvent extends FileEvent {
  final String filePath;

  const GetFileEvent({required this.filePath});

  @override
  List<Object> get props => [filePath];
}
