import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:gem_dubi/common/utils/dio_client.dart';
import 'package:gem_dubi/src/chat/entities/approved_users.dart';
import 'package:gem_dubi/src/chat/entities/girl_type_category.dart';

class MessageRepository {
  MessageRepository._();

  static MessageRepository? _instance;

  factory MessageRepository.instance() {
    _instance ??= MessageRepository._();

    return _instance!;
  }

  Future<List<GirlTypeCategory>> fetchCategories() async {
    try {
      final response = await dio.get('/wp/v2/tags');
      log(jsonEncode(response.data));
      final list = (response.data as List<dynamic>).map((e) {
        return GirlTypeCategory.fromJson(e);
      }).toList();
      return list;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ApprovedUsers>> fetchUsersListByGirlType({required int tagTypeId}) async {
    try {
      final response = await dio.get('/wp/v2/approved-users?type=$tagTypeId');
      log(jsonEncode(response.data));
      final list = (response.data as List<dynamic>).map((e) {
        return ApprovedUsers.fromJson(e);
      }).toList();
      return list;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<List<ApprovedUsers>> fetchAllUsers() async {
    try {
      final response = await dio.get('/wp/v2/all-approved-users');
      log(jsonEncode(response.data));
      final list = (response.data as List<dynamic>).map((e) {
        return ApprovedUsers.fromJson(e);
      }).toList();
      return list;
    } on DioException catch (e) {
      print(e);
      rethrow;
    }
  }
}
