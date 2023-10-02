import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

Dio get dio => DioClient.instance.dio;

class DioClient {
  static final instance = DioClient._();

  DioClient._() {
    dio.interceptors.add(
      InterceptorsWrapper(
        onResponse: (e, handler) {
          if (kDebugMode) {
            print(
              '${e.requestOptions.method} ${e.statusCode} ${e.requestOptions.uri}',
            );
          }
          handler.next(e);
        },
      ),
    );
  }

  final Dio dio = Dio(
    BaseOptions(
      // baseUrl: 'https://igeneratedev.com/gemdubai/wp-json',
      baseUrl: 'https://gemdubai.app/wp-json',
      headers: {'accept': 'application/json'},
    ),
  );

  void setToken(String token) {
    dio.options.headers['authorization'] = "Bearer $token";
  }

  void removeToken() {
    dio.options.headers.remove('authorization');
  }
}
