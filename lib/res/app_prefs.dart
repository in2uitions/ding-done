import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
const String language = "LANGUAGE";
const String currentPositionKey = "CURRENT_POSITION";
const String dblang = "DBLANG";
const String selectedCountryKey = "SELECTED_COUNTRY";
const String userRefreshToken = "REFRESH_TOKEN";
const String loginTime = '';
const String userTokenExpiry = "TOKEN EXPIRY";

class AppPreferences {
  static SharedPreferences? _prefs;
  static final Map<String, dynamic> _memory = {};
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static bool get _useAndroidSecureStorage =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static String _encodeValue(dynamic value) {
    if (value is List<String>) {
      return json.encode({'type': 'stringList', 'value': value});
    }
    if (value is bool) {
      return json.encode({'type': 'bool', 'value': value});
    }
    if (value is int) {
      return json.encode({'type': 'int', 'value': value});
    }
    if (value is double) {
      return json.encode({'type': 'double', 'value': value});
    }
    return value?.toString() ?? '';
  }

  static dynamic _decodeValue(String? raw, {required bool isModel}) {
    if (raw == null) return null;
    if (isModel) {
      return json.decode(raw);
    }

    try {
      final decoded = json.decode(raw);
      if (decoded is Map<String, dynamic> &&
          decoded.containsKey('type') &&
          decoded.containsKey('value')) {
        switch (decoded['type']) {
          case 'stringList':
            return (decoded['value'] as List<dynamic>).cast<String>();
          case 'bool':
            return decoded['value'] as bool;
          case 'int':
            return decoded['value'] as int;
          case 'double':
            return (decoded['value'] as num).toDouble();
        }
      }
    } catch (_) {
      // Fall back to raw strings for existing values.
    }

    return raw;
  }

  static Future<SharedPreferences?> instance() async {
    if (_useAndroidSecureStorage) return null;
    if (_prefs != null) return _prefs;
    for (var attempt = 0; attempt < 6; attempt++) {
      try {
        _prefs = await SharedPreferences.getInstance();
        return _prefs;
      } catch (error) {
        debugPrint('SharedPreferences getInstance failed: $error');
        await Future<void>.delayed(Duration(milliseconds: 120 * (attempt + 1)));
      }
    }
    return null;
  }

  save(
      {required String? key,
      required dynamic value,
      required bool? isModel}) async {
    if (key == null) return;
    final stored = isModel == true ? json.encode(value) : value;
    _memory[key] = stored;
    try {
      if (_useAndroidSecureStorage) {
        await _secureStorage.write(key: key, value: _encodeValue(stored));
        return;
      }
      final SharedPreferences? prefs = await AppPreferences.instance();
      if (prefs == null) return;
      if (isModel == true || stored is String) {
        await prefs.setString(key, stored.toString());
      } else if (stored is int) {
        await prefs.setInt(key, stored);
      } else if (stored is double) {
        await prefs.setDouble(key, stored);
      } else if (stored is bool) {
        await prefs.setBool(key, stored);
      } else if (stored is List<String>) {
        await prefs.setStringList(key, stored);
      }
    } catch (error) {
      debugPrint('AppPreferences.save failed: $error');
    }
  }

  dynamic get({required String? key, required bool? isModel}) async {
    if (key == null) return null;
    try {
      if (_useAndroidSecureStorage) {
        final raw = await _secureStorage.read(key: key);
        if (raw != null) {
          return _decodeValue(raw, isModel: isModel == true);
        }
      }
      final SharedPreferences? prefs = await AppPreferences.instance();
      if (prefs != null) {
        if (isModel == true) {
          final String? value = prefs.getString(key) ?? _memory[key] as String?;
          if (value == null) return null;
          return json.decode(value);
        }
        if (prefs.getString(key) != null) return prefs.getString(key);
        if (prefs.getInt(key) != null) return prefs.getInt(key);
        if (prefs.getDouble(key) != null) return prefs.getDouble(key);
        if (prefs.getBool(key) != null) return prefs.getBool(key);
        if (prefs.getStringList(key) != null) return prefs.getStringList(key);
      }
    } catch (error) {
      debugPrint('AppPreferences.get failed: $error');
    }
    final memoryValue = _memory[key];
    if (isModel == true && memoryValue is String) {
      return json.decode(memoryValue);
    }
    return memoryValue;
  }

  void remove({required String? key}) async {
    if (key == null) return;
    _memory.remove(key);
    try {
      if (_useAndroidSecureStorage) {
        await _secureStorage.delete(key: key);
        return;
      }
      final SharedPreferences? prefs = await AppPreferences.instance();
      await prefs?.remove(key);
    } catch (error) {
      debugPrint('AppPreferences.remove failed: $error');
    }
  }

  void clear() async {
    _memory.clear();
    try {
      if (_useAndroidSecureStorage) {
        await _secureStorage.deleteAll();
        return;
      }
      final SharedPreferences? prefs = await AppPreferences.instance();
      await prefs?.clear();
    } catch (error) {
      debugPrint('AppPreferences.clear failed: $error');
    }
  }
}
