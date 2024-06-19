import 'dart:convert';

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/features/users/domain/entities/user.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:http/http.dart' as http;

abstract class UserRemoteData {
  Future<bool?> save(User oUser);
  Future<List<User?>> list();
  Future<User?> get(int persIden);
  Future<bool?> updatePassword(PersUpdatePass oPersUpdatePass);
}

class UserRemoteDataImple implements UserRemoteData {
  late final http.Client client;
  UserRemoteDataImple({required this.client});

  @override
  Future<bool?> save(User oUser) async {
    final uri = Uri.parse('http://controlBS.somee.com/person');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers, body: jsonEncode(oUser.toJson()))
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

  @override
  Future<List<User?>> list() async {
    final uri = Uri.parse('http://controlBS.somee.com/person');
    var response = await client
        .get(
          uri,
          headers: getIt<Headers>().headers,
        )
        .timeout(const Duration(seconds: timeout),
            onTimeout: () => throw TimeOutException());

    final data = Data.fromJson(jsonDecode(response.body),
        (value) => response.statusCode == 200 ? User.fromJson(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }

  @override
  Future<User?> get(int persIden) async {
    final uri = Uri.parse('http://controlBS.somee.com/person/$persIden');
    var response = await client
        .get(
          uri,
          headers: getIt<Headers>().headers,
        )
        .timeout(const Duration(seconds: timeout),
            onTimeout: () => throw TimeOutException());

    final data = Data.fromJson(jsonDecode(response.body),
        (value) => response.statusCode == 200 ? User.fromJson(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }

  @override
  Future<bool?> updatePassword(PersUpdatePass oPersUpdatePass) async {
    final uri = Uri.parse('http://controlBS.somee.com/person/updatePassword');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers,
            body: jsonEncode(oPersUpdatePass.toJson()))
        .timeout(
          const Duration(seconds: timeout),
          onTimeout: () => throw TimeOutException(),
        );
    final data = Data.fromJson(jsonDecode(response.body),
        (value) => response.statusCode == 200 ? bool.parse(value) : null);
    if (response.statusCode == 200) {
      return data.value;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }
}
