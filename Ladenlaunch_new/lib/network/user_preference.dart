import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ladenlaunch/network/model/user_model.dart';

class DefaultKeys {
  static const authKey = 'authKey';
  static const deviceToken = 'deviceToken';
  static const userDetails = 'userDetails';
  static const appLanguage = 'appLanguage';
}

class DbHelper {
  static GetStorage box = GetStorage();
  static bool isGuest = false;

  static Future<void> saveIsGuest(bool value) async {
    isGuest = value;
    await box.write('isGuest', value);
  }

  static bool getIsGuest() {
    final guestStatus = box.read('isGuest') ?? false;
    isGuest = guestStatus;
    return guestStatus;
  }

  static writeData(String key, dynamic value) async {
    await box.write(key, value);
  }

  static readData(String key) {
    return box.read(key);
  }

  static deleteData(String key) async {
    await box.remove(key);
  }

  static eraseData() async {
    await box.erase();
  }

  static Future<void> saveUserLoggedIn(bool value) async {
    await box.write('saveLoggedIn', value);
  }

  static Future<void> saveNotificationStatus(bool value) async {
    await box.write('saveNotificationStatus', value);
  }

  static Future<void> saveUserIntro(bool value) async {
    await box.write('saveUserIntro', value);
  }

  static Future<void> saveUserEmail(String value) async {
    await box.write('loginUserEmail', value);
  }

  static String? getUserEmail() {
    final email = box.read('loginUserEmail') ?? '';
    return email;
  }

  static Future<void> saveUserPassword(String value) async {
    await box.write('loginUserPassword', value);
  }

  static String? getUserPassword() {
    final password = box.read('loginUserPassword') ?? '';
    return password;
  }

  static Future<void> saveUser(UserModel? user) async {
    await box.write('user', user?.body?.toJson());
  }

  static Future<void> saveUserBody(UserModelBody? user) async {
    await box.write('user', user?.toJson());
  }

  static UserModelBody? getUser() {
    final user = box.read('user');
    return user != null ? UserModelBody.fromJson(user) : null;
  }

  static bool? getUserIntro() {
    final subStatus = box.read('saveUserIntro') ?? false;
    return subStatus;
  }


  static Future<void> saveUserToken(String value) async {
    await box.write('loginUserToken', value);
  }

  static String? getUserToken() {
    final password = box.read('loginUserToken') ?? '';
    return password;
  }

  static Future<void> saveUserType(bool value) async {
    await box.write('loginUsertype', value);
  }

  static bool? getUserType() {
    final password = box.read('loginUsertype') ?? '';
    return password;
  }

  static bool? getLoginDone() {
    final subStatus = box.read('saveLoginDone') ?? false;
    return subStatus;
  }


  static Future<void> saveLoginDone(bool value) async {
    await box.write('saveLoginDone', value);
  }

  static Future<void> saveAppLanguage(Locale locale) async {
    await box.write(
      DefaultKeys.appLanguage,
      '${locale.languageCode}_${locale.countryCode}',
    );
  }

  static Locale getAppLanguage() {
    final lang = box.read(DefaultKeys.appLanguage);

    if (lang == null) {
      return const Locale('en', 'US'); // default
    }

    final parts = lang.split('_');
    return Locale(parts[0], parts[1]);
  }
}