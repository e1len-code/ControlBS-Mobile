import 'dart:convert';

import 'package:controlbs_mobile/core/constants/size_config.dart';
import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/network/headers.dart';
import 'package:controlbs_mobile/core/utils/response_model.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_request.dart';
import 'package:controlbs_mobile/features/auth/domain/entities/auth_response.dart';
import 'package:controlbs_mobile/features/users/domain/entities/pers_update_pass.dart';
import 'package:controlbs_mobile/injections.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteData {
  Future<Data<AuthResponse?>> auth(AuthRequest authRequest);
}

class AuthRemoteDataImple extends AuthRemoteData {
  late final http.Client client;

  AuthRemoteDataImple({required this.client});

  @override
  Future<Data<AuthResponse?>> auth(AuthRequest authRequest) async {
    final uri = Uri.parse('http://controlBS.somee.com/auth');
    var response = await client
        .post(uri,
            headers: getIt<Headers>().headers,
            body: jsonEncode(authRequest.toJson()))
        .timeout(
          const Duration(seconds: timeout),
          onTimeout: () => throw TimeOutException(),
        );
    final data = Data.fromJson(
        jsonDecode(response.body),
        (value) =>
            response.statusCode == 200 ? AuthResponse.fromJson(value) : null);
    if (response.statusCode == 200) {
      return data;
    } else {
      throw ApiResponseException(
          statusCode: response.statusCode,
          firstMessageError: data.errors.first.message);
    }
  }
}
