import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class MessageException implements Exception {
  final String message;

  MessageException(this.message);

  factory MessageException.fromDio(DioException error, [StackTrace? stackTrace]) {
    try {
      debugPrint(
        '--------------------- server error response -------------------',
      );
      debugPrint('GET ${error.requestOptions.uri}');
      debugPrint(error.response?.data);

      final data = error.response?.data ?? {};
      if (error.response?.statusCode == 500) {
        // CrashlyticsWrapper.recordError(error.message, stackTrace);

        return MessageException('Server Error');
      }

      String? message;

      if (data is String) {
        message = data;
      } else if (data is List) {
        message = data.first;
      } else if (data is Map) {
        final value = data.values.first;

        if (value is String) {
          message = value;
        } else if (value is List) {
          message = value.first;
        }
      }

      return MessageException(message ?? error.message ?? 'Unknown Error');
    } catch (e) {
      return MessageException(error.message ?? 'Unknown Error');
    }
  }

  @override
  String toString() => '[MessageException] $message';
}
