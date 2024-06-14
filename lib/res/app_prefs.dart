import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const String preferencesKeyLang = "PREFS_KEY_LANG";
const String userTokenKey = "USER_TOKEN_KEY";
const String userEmailKey = "USER_EMAIL_KEY";
const String userPasswordKey = "USER_PASSWORD_KEY";
const String userIdKey = "USER_ID_KEY";
const String userId = "USER_ID";
const String userNameKey = "USER_NAME_KEY";
const String preferred_language = "PREFERRED_LANGUAGE";
const String userRole = "USER_ROLE";
const String userRoleKey = "USER_ROLE_KEY";
const String userAvatar = "USER_AVATAR";
const String cvId = "CV_ID";
const String SHARED_LOGGED = "USER_IS_LOGGED";
const String SHARED_USER = "USER";
const String SHARED_PASSWORD = "PASSWORD";
const String otpNumber = "OTP";
const String userIdTochangePassword = "userIdTochangePassword";
const String language = "LANGUAGE";
const String dblang = "DBLANG";
const String userRefreshToken = "REFRESH_TOKEN";
const String loginTime = '';
const String userTokenExpiry = "TOKEN EXPIRY";


class AppPreferences {
  save(
      {required String? key,
      required dynamic value,
      required bool? isModel}) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    if (isModel == true) {
      // Encode and store dataModel in SharedPreferences
      final String _value = json.encode(value);
      await instance.setString(key!, _value);
    } else {
      if (value is String) {
        instance.setString(key!, value);
      } else if (value is int) {
        instance.setInt(key!, value);
      } else if (value is double) {
        instance.setDouble(key!, value);
      } else if (value is bool) {
        instance.setBool(key!, value);
      } else if (value is List<String>) {
        instance.setStringList(key!, value);
      }
    }
  }

  dynamic get({required String? key, required bool? isModel}) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();

    if (isModel == true) {
      final String? _value = instance.getString(key!);
      return json.decode(_value.toString());
    } else {
      if (instance.getString(key!) != null) {
        return instance.getString(key);
      } else if (instance.getInt(key) != null) {
        return instance.getInt(key);
      } else if (instance.getDouble(key) != null) {
        return instance.getDouble(key);
      } else if (instance.getBool(key) != null) {
        return instance.getBool(key);
      } else if (instance.getStringList(key) != null) {
        return instance.getStringList(key);
      }
    }
  }

  void remove({required String? key}) async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    instance.remove(key!);
  }

  void clear() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    instance.clear();
  }
}
