part of 'file_provider_bloc.dart';

sealed class FileState extends Equatable {
  const FileState();

  @override
  List<Object> get props => [];
}

final class FileInitial extends FileState {}

class LoadingState extends FileState {}

class ErrorState extends FileState {
  final String message;

  const ErrorState({required this.message});

  @override
  List<Object> get props => [message];
}

class SavedState extends FileState {
  final bool? saved;
  const SavedState({this.saved});

  @override
  List<Object> get props => [saved!];
}

class GotPhotoState extends FileState {
  final String? photoImg;
  const GotPhotoState({this.photoImg});

  @override
  List<Object> get props => [photoImg!];
}
