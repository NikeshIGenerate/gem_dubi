import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:gem_dubi/common/converter/converter.dart';
import 'package:gem_dubi/common/utils/dio_client.dart';
import 'package:gem_dubi/common/utils/share_preferences.dart';
import 'package:gem_dubi/src/login/user.dart';

const _kTokenKey = 'LoginRepository.user_token';

class LoginRepository {
  LoginRepository._();

  static final instance = LoginRepository._();

  static const kEmailKey = 'LoginRepository.user_email';
  static const kPasswordKey = 'LoginRepository.user_password';

  Future<User?> initUser() async {
    try {
      final token = await LocalStorageRepo.instance().getString(_kTokenKey);

      if (token == null) return null;

      final response = await dio.get<Map>('/simple-jwt-login/v1/auth/validate',
          options: Options(headers: {
            'authorization': 'Bearer $token',
            'accepts': 'application/json',
          }));

      print(token);
      if (response.data?['success'] != true) return null;

      String jwt = response.data!.from('data.jwt.0.token');
      log('JWT : $jwt');
      final userData = response.data!.from<dynamic>('data.user') as Map;
      userData['jwt'] = jwt;

      setToken(token);
      log(jsonEncode(response.data));
      return userData.to();
    } on DioException catch (e) {
      print(e.response?.data);
      return null;
    }
  }

  Future<void> updateDeviceToken(String userId, String deviceToken) async {
    try {
      final response = await dio.post(
        '/wp/v2/device_token',
        data: ({
          'user_id': userId,
          'device_token': deviceToken,
        }),
      );
      log(jsonEncode(response.data));
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<User> login(String email, String password) async {
    final response =
        await dio.post<Map>('/simple-jwt-login/v1/auth', queryParameters: {
      'email': email,
      'password': password,
    });

    setToken(response.data?['jwt']);
    log(jsonEncode(response.data));
    return await response.data!.to();
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
    String? phone,
    String? instagram,
  }) async {
    try {
      final response = await dio.post(
        '/custom-plugin/usermanage',
        data: {
          'email': email,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'phone': phone,
          if (instagram != null) 'social': {'instagram': instagram},
        },
      );
      log(jsonEncode(response.data));
      return response.data as Map<String, dynamic>;
    } on DioException catch (e) {
      print(e.response?.data);
      rethrow;
    }
  }

  Future<User> updateProfile({
    required String id,
    required int tagTypeId,
    String? email,
    String? password,
    String? firstName,
    String? lastName,
    String? phone,
    String? instagram,
    File? image,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://gemdubai.app/wp-json/custom-plugin/usermanage'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'ID': id,
          if (email != null) 'email': email,
          if (password != null) 'password': password,
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (phone != null) 'phone': phone,
          'tag_type_id' : tagTypeId,
          if (instagram != null) 'social': {'instagram': instagram},
          if (image != null) 'avatar': base64.encode(image.readAsBytesSync()),
        }),
      );
      print(response.body);
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return User.fromMap(data['data']);
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> requestResetPassword(String email) async {
    try {
      final response = await dio.post<Map>(
        '/simple-jwt-login/v1/user/reset_password',
        data: {'email': email, 'AUTH_KEY': 'gemdubairesetauth@2022'},
      );

      print(response.data);
    } on DioException catch (e) {
      print(e.response?.data);
      rethrow;
    }
  }

  Future<void> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      final response = await dio.put<Map>(
        '/simple-jwt-login/v1/user/reset_password',
        data: {
          'email': email,
          'code': code,
          'new_password': newPassword,
          'AUTH_KEY': 'gemdubairesetauth@2022',
        },
      );
      print(dio.options.headers);

      print(response.data);
    } on DioException catch (e) {
      print(e.response?.data);
      rethrow;
    }
  }

  Future<void> logout() => setToken(null);

  Future<void> delete() async {
    try {
      // String token = (dio.options.headers['authorization'] as String)
      //     .replaceFirst('Bearer ', '');

      final response = await dio.delete('/wp/v2/users/me', queryParameters: {
        'reassign': 33,
        'force': true,
      });
      print(response.data);
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  Future<void> setToken(String? value) async {
    if (value != null) {
      await LocalStorageRepo.instance().setString(
        _kTokenKey,
        value,
      );
      DioClient.instance.setToken(value);
    } else {
      await LocalStorageRepo.instance().remove(_kTokenKey);
      DioClient.instance.removeToken();
    }
  }
}
