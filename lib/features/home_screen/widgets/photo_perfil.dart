import 'dart:convert';

import 'package:controlbs_mobile/features/auth/presentation/provider/auth_provider.dart';
import 'package:controlbs_mobile/features/file/presentation/provider/file_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhotoPerfilWidget extends StatelessWidget {
  const PhotoPerfilWidget({
    super.key,
    required this.authProvider,
  });

  final AuthProvider authProvider;

  @override
  Widget build(BuildContext context) {
    return Consumer<FileProvider>(builder: (context, fileProvider, child) {
      return fileProvider.photoImg != null &&
              fileProvider.photoImg!.isNotEmpty &&
              authProvider.authResponse.id != 0
          ? CircleAvatar(
              backgroundImage:
                  MemoryImage(base64Decode(fileProvider.photoImg!)))
          : Container();
    });
  }
}
