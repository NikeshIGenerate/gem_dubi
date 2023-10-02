import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gem_dubi/common/converter/converter.dart';
import 'package:gem_dubi/common/utils/app_router.dart';
import 'package:gem_dubi/common/utils/dio_client.dart';
import 'package:gem_dubi/common/utils/share_preferences.dart';
import 'package:gem_dubi/src/login/controller/login_reposiotry.dart';
import 'package:gem_dubi/src/login/guest_user.dart';
import 'package:gem_dubi/src/login/screens/login_screen.dart';

final loginProviderRef = ChangeNotifierProvider((ref) => LoginProvider());
const _kTokenKey = 'LoginRepository.user_token';

class LoginProvider extends ChangeNotifier {
  GuestUser? _user;

  GuestUser get user => _user!;

  GuestUser? get userNullable => _user;

  bool get isLoggedIn => _user != null;

  Future<GuestUser?> init() async {
    //fetch initial user if there are any
    try {
      final email = await LocalStorageRepo.instance().getString(LoginRepository.kEmailKey);
      final password = await LocalStorageRepo.instance().getString(LoginRepository.kPasswordKey);
      if (email != null && password != null) {
        _user = await LoginRepository.instance.login(email, password);
        // updateOneSignalUser();
        return _user;
      }
      return null;
    } on DioException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> setDeviceToken(GuestUser user) async {
    try {
      final deviceToken = await FirebaseMessaging.instance.getToken();
      await LoginRepository.instance.updateDeviceToken(user.id, deviceToken ?? '');
      FirebaseFirestore.instance.collection('users-availability').doc(user.id).get();
      await FirebaseFirestore.instance.collection('users-availability').doc(user.id).set({
        'deviceToken': deviceToken,
      });
      FirebaseFirestore.instance.collection('users-availability').doc(user.id).collection('availability').doc('status').set({
        'status': true,
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  Future<void> resetDeviceToken(GuestUser user) async {
    try {
      await LoginRepository.instance.updateDeviceToken(user.id, '');
      FirebaseFirestore.instance.collection('users-availability').doc(user.id).collection('availability').doc('status').set({
        'status': false,
      });
      await FirebaseFirestore.instance.collection('users-availability').doc(user.id).set({
        'deviceToken': '',
      });
    } on DioException catch (e) {
      print(e);
    }
  }

  //return string in case of error
  Future<String?> login(String email, String password) async {
    try {
      _user = await LoginRepository.instance.login(email, password);
      if (_user != null) {
        await LocalStorageRepo.instance().setString(
          LoginRepository.kEmailKey,
          email,
        );
        await LocalStorageRepo.instance().setString(
          LoginRepository.kPasswordKey,
          password,
        );
      }
      if (_user != null && _user?.status == UserState.approved) {
        // updateOneSignalUser();
        setDeviceToken(_user!);
      }
      return null;
    } on DioException catch (e) {
      print(e);
      return 'Invalid username or password';
    }
  }

  Future<String?> signup({
    required String email,
    required String firstName,
    required String lastName,
    required String phone,
    required String password,
    required String instagram,
  }) async {
    try {
      final userData = await LoginRepository.instance.register(
        email: email,
        firstName: firstName,
        password: password,
        lastName: lastName,
        phone: phone,
        instagram: instagram,
      );
      if (userData != null) {
        if (userData.containsKey("msg")) {
          return userData['msg'] as String;
        }
        _user = userData.from('data');
        if (_user != null) {
          setToken(userData.from('data.jwt'));
          await LocalStorageRepo.instance().setString(
            LoginRepository.kEmailKey,
            email,
          );
          await LocalStorageRepo.instance().setString(
            LoginRepository.kPasswordKey,
            password,
          );
          if (_user!.status == UserState.approved) {
            // updateOneSignalUser();
            setDeviceToken(_user!);
          }
        }
      }
      return null;
    } on DioException catch (e) {
      print(e);
      return 'Invalid username or password';
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

  Future<void> updateProfile({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? instagram,
    String? password,
    File? image,
  }) async {
    // print(_user!.tagTypeId!);
    final tempUser = await LoginRepository.instance.updateProfile(
      id: user.id,
      email: user.email,
      phone: phone,
      firstName: firstName,
      password: password,
      lastName: lastName,
      instagram: instagram,
      image: image,
      tagTypeId: _user!.tagTypeId!,
    );
    _user = GuestUser(
      id: user.id,
      email: user.email,
      displayName: tempUser.displayName,
      userLogin: tempUser.userLogin,
      token: user.token,
      phone: tempUser.phone,
      image: tempUser.image,
      status: tempUser.status,
      tagTypeId: user.tagTypeId,
      tagTypeName: user.tagTypeName,
    );
    // updateOneSignalUser();
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    await LoginRepository.instance.requestResetPassword(email);
  }

  Future<void> updatePassword({
    required String email,
    required String newPassword,
    required String code,
  }) =>
      LoginRepository.instance.resetPassword(
        email: email,
        code: code,
        newPassword: newPassword,
      );

  // updateOneSignalUser() {
  //   RemoteNotificationWrapper.instance.setUser(_user);
  // }

  Future<void> logout() async {
    unawaited(resetDeviceToken(_user!));
    await LocalStorageRepo.instance().remove(LoginRepository.kEmailKey);
    await LocalStorageRepo.instance().remove(LoginRepository.kPasswordKey);
    LoginRepository.instance.logout();
    _user = null;
    router.replaceAllWith(const LoginScreen());
  }

  Future<void> deleteAccount() async {
    await LoginRepository.instance.delete();
    unawaited(resetDeviceToken(_user!));
    await LocalStorageRepo.instance().remove(LoginRepository.kEmailKey);
    await LocalStorageRepo.instance().remove(LoginRepository.kPasswordKey);
    LoginRepository.instance.logout();
    _user = null;
    router.replaceAllWith(const LoginScreen());
  }
}
