class ResponseError {
  late final String message;
  late final String source;
  late final String stackTrace;

  ResponseError({this.message = "", this.source = "", this.stackTrace = ""});

  factory ResponseError.fromJson(Map<String, dynamic> json) {
    return ResponseError(
        message: json['message'],
        source: json['source'],
        stackTrace: json['stackTrace']);
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'source': source, 'stackTrace': stackTrace};
  }
}
