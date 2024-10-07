part of 'file_provider_bloc.dart';

sealed class FileProviderEvent extends Equatable {
  const FileProviderEvent();

  @override
  List<Object> get props => [];
}

class SaveFileEvent extends FileProviderEvent {
  final File file;

  const SaveFileEvent(this.file);

  @override
  List<Object> get props => [file];
}

class GetFileEvent extends FileProviderEvent {
  final String filePath;

  const GetFileEvent(this.filePath);

  @override
  List<Object> get props => [filePath];
}
