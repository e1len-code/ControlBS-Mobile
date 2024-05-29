import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:controlbs_mobile/features/file/domain/useCase/file_usecase.dart';
import 'package:flutter/material.dart';

class FileProvider with ChangeNotifier {
  final FileUseCase useCase;
  FileProvider({required this.useCase});

  bool isLoading = false;
  String error = '';
  bool saved = false;

  Future<bool> save(File attendance) async {
    isLoading = true;
    notifyListeners();
    final result = await useCase.save(attendance);
    result.fold(
        (failure) => error = failure.message, (saved) => this.saved = saved!);
    isLoading = false;
    notifyListeners();
    return saved;
  }
}
