class ServerException implements Exception {
  final String message;
  ServerException(
      {this.message = 'Servidor no disponible... Inténtelo más tarde'});
}

class TimeOutException implements Exception {
  final String message;
  TimeOutException(
      {this.message = 'El tiempo de espera se agotó... Inténtelo más tarde'});
}

class ApiResponseException implements Exception {
  final int statusCode;
  final String firstMessageError;
  ApiResponseException(
      {required this.firstMessageError, this.statusCode = 500});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'Error en el cache del móvil...'});
}
