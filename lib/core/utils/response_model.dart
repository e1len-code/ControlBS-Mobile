import 'package:controlbs_mobile/core/utils/response_error_model.dart';

class Data<T> {
  final T value;
  final List<ResponseError> errors;
  final bool success;
  final int statusCode;

  Data(
      {required this.value,
      required this.errors,
      required this.success,
      required this.statusCode});

  factory Data.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return Data(
      value: fromJsonT(json['value']),
      errors: (json['errors'] as List<dynamic>)
          .map((errorJson) => ResponseError.fromJson(errorJson))
          .toList(),
      success: json['success'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'value': toJsonT(value),
      'errors': errors.map((error) => error.toJson()).toList(),
      'success': success,
      'statusCode': statusCode,
    };
  }
}
