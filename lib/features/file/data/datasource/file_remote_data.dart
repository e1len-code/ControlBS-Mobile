import 'dart:convert';

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/file/domain/entities/file.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:http/http.dart' as http;

abstract class FileRemoteData {
  Future<bool?> save(File attendance);
}

class FileRemoteDataImple implements FileRemoteData {
  late final http.Client client;
  FileRemoteDataImple({required this.client});

  @override
  Future<bool?> save(File attendance) async {
    final uri = Uri.parse('http://controlBS.somee.com/file');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers,
            body: jsonEncode(attendance.toJson()))
        .timeout(const Duration(seconds: timeout),
            onTimeout: () => throw TimeOutException());
    final data = Data.fromJson(jsonDecode(response.body),
        (value) => response.statusCode == 200 ? valueBool(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }

  bool valueBool(bool value) {
    return value;
  }
}
