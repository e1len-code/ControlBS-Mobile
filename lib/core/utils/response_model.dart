import 'package:controlbs_mobile/core/utils/response_error_model.dart';

// class Data<T> {
//   final T value;
//   final List<ResponseError> errors;
//   final bool success;
//   final int statusCode;

//   Data(
//       {required this.value,
//       required this.errors,
//       required this.success,
//       required this.statusCode});

//   factory Data.fromJson(
//       Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
//     return Data(
//       value: fromJsonT(json['value']),
//       errors: (json['errors'] as List<dynamic>)
//           .map((errorJson) => ResponseError.fromJson(errorJson))
//           .toList(),
//       success: json['success'],
//       statusCode: json['statusCode'],
//     );
//   }

//   Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
//     return {
//       'value': toJsonT(value),
//       'errors': errors.map((error) => error.toJson()).toList(),
//       'success': success,
//       'statusCode': statusCode,
//     };
//   }
// }

class Data<T> {
  final dynamic value;
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
      value: json['value'] != null
          ? json['value'] is List
              ? (json['value'] as List)
                  .map((value) => fromJsonT(value))
                  .toList()
              : fromJsonT(json['value'])
          : null,
      errors: (json['errors'] as List<dynamic>)
          .map((errorJson) => ResponseError.fromJson(errorJson))
          .toList(),
      success: json['success'],
      statusCode: json['statusCode'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'value': value != null
          ? (value is List
              ? value.map((v) => toJsonT(v)).toList()
              : toJsonT(value))
          : null,
      'errors': errors.map((error) => error.toJson()).toList(),
      'success': success,
      'statusCode': statusCode,
    };
  }
}
