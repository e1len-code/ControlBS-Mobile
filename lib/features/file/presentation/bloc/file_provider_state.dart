part of 'file_provider_bloc.dart';

sealed class FileProviderState extends Equatable {
  const FileProviderState();

  @override
  List<Object> get props => [];
}

final class FileProviderInitial extends FileProviderState {}

class LoadingState extends FileProviderState {}

class ErrorState extends FileProviderState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SavedState extends FileProviderState {
  final bool? saved;
  const SavedState({this.saved});

  @override
  List<Object> get props => [saved!];
}

class GotPhotoState extends FileProviderState {
  final String? photoImg;
  const GotPhotoState({this.photoImg});

  @override
  List<Object> get props => [photoImg!];
}
