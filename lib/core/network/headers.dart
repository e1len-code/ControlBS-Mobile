import 'package:controlbs_mobile/core/errors/exceptions.dart';
import 'package:controlbs_mobile/core/network/jwt.dart';

class Headers {
  String _accessToken = "";

  Map<String, String> get headers => _headers;

  String get accessToken => _accessToken;
  final Map<String, String> _headers = {
    "Content-Type": "application/json",
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "DELETE, POST, GET",
    "Access-Control-Allow-Headers":
        "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With"
  };
  void addHeader(String key, String value) {
    //if (!this._headers.containsKey(key)) {
    if (headers.containsKey(key)) deleteHeader(key);
    _headers[key] = value;
    if (key == "Authorization") {
      _accessToken = value;
    }
    //} else {

    //}
  }

  void deleteHeader(String key) {
    if (_headers.containsKey(key)) {
      _headers.removeWhere((k, v) => k == key);
      if (key == "Authorization") {
        _accessToken = "";
      }
    }
  }

  Future<void> validateToken() async {
    try {
      var a = Jwt.isExpired(accessToken, 'token');
      if (a) {
        //refreshToken
        deleteHeader('Authorization');
        //await getRefreshToken();
      }
    } catch (e) {
      throw ServerException(message: "refresh Token error");
    }
  }

  // Future<bool> _isRefreshTokenExpired() async {
  //   try {
  //     return Jwt.isExpired(_refreshToken, 'tokenRefresh');
  //   } catch (e) {
  //     return false;
  //   }
  // }
}
