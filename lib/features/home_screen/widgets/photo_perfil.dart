import 'dart:convert';
import 'package:controlbs_mobile/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:controlbs_mobile/features/file/presentation/bloc/file_provider_bloc.dart'
    as filebloc;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PhotoPerfilWidget extends StatelessWidget {
  const PhotoPerfilWidget({
    super.key,
    required this.authBloc,
  });

  final AuthBloc authBloc;

  @override
  Widget build(BuildContext context) {
    filebloc.FileBloc fileBloc = context.read<filebloc.FileBloc>();
    return BlocBuilder<filebloc.FileBloc, filebloc.FileState>(
        bloc: fileBloc,
        builder: (context, state) {
          return fileBloc.photoImg != null &&
                  fileBloc.photoImg!.isNotEmpty &&
                  authBloc.authResponse!.id != 0
              ? CircleAvatar(
                  backgroundImage:
                      MemoryImage(base64Decode(fileBloc.photoImg!)))
              : Container();
        });
  }
}
