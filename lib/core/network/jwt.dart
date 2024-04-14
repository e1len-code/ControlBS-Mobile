import 'dart:convert';

class Jwt {
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw FormatException('Invalid token.');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw FormatException('Invalid payload.');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += "==";
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64 string.');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static bool isExpired(String token, String typeToken) {
    final DateTime? expirationDate = getExpiryDate(token);
    /* print('Token Hora:' + expirationDate.toString());
    print('Ahora:' + DateTime.now().toString()); */
    /* int minute = 0;
    (typeToken == 'tokenRefresh') ? minute = 10080 : minute = 1; */
    if (expirationDate != null) {
      bool isAfter =
          DateTime.now().add(Duration(seconds: 2)).isAfter(expirationDate);
      /* bool isAfter =
          expirationDate.isAfter(DateTime.now().add(Duration(minutes: minute))); */
      /* print(typeToken + ' : ' + isAfter.toString()); */
      return isAfter;
    } else {
      return true /* false */;
    }
  }

  static DateTime? getExpiryDate(String token) {
    final Map<String, dynamic> payload = parseJwt(token);
    if (payload['exp'] != null) {
      return DateTime.fromMillisecondsSinceEpoch(0)
          .add(Duration(seconds: payload["exp"]));
    }
    return null;
  }
}
