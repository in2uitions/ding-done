import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dingdone/models/login_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/repository/login/login_repo.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/data/remote/response/Status.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/app_validation.dart';
import 'package:dingdone/res/strings/english_strings.dart';
import 'package:dingdone/utils/navigation_service.dart';
import 'package:dingdone/view/on_boarding/on_boarding.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:dingdone/services/onesignal_service.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LoginViewModel with ChangeNotifier {
  final LoginRepository _loginRepository = LoginRepository();
  // final ProfileRepository _profileRepository = ProfileRepository();
  ApiResponse<LoginModel> _loginResponse = ApiResponse.loading();
  ApiResponse<UserModel> _userModelResponse = ApiResponse.loading();
  final Map<String, dynamic> _loginCredentials = {};
  Map<String, dynamic> _loginErrors = {};
  String? _userRole = "";
  String? _userEmail = "";
  String? _userPass = "";
  String? _language="";
  String _pendingResetEmail = '';


  LoginViewModel() {
    readJson();

  }
  Future<void> readJson() async {
    // AppPreferences().clear();
  }

  Future<void> checkAndRefreshToken() async {
    if (await isTokenExpired) {
      bool refreshSuccess = await refreshAccessToken();
      print('refreshing token from check and refresh');
      if (!refreshSuccess) {
        print('token didnt refresh check and refresh');
      }
    }
  }
  Future<void> setLanguage(String lang) async {
    debugPrint('setting language ${lang}');
   _language=lang;
   debugPrint('$_language');
   notifyListeners();
  }

  Future<void> splashLogin() async {
    await checkAndRefreshToken();

    if (await isTokenNotEmpty() && !isTokenExpired) {
      if (await isTokenExpired) {
        bool refreshSuccess = await refreshAccessToken();
        print('refreshed access token from splash login');
        if (!refreshSuccess) {
          FlutterNativeSplash.remove();
          return;
        }
      }
      if (!await isActiveUser()) {
        await loginSharedPreference();
      } else {
        NavigationService().navigateToScreen(BottomBar(userRole: userRole, currentTab: 0,));
      }
    } else {
      FlutterNativeSplash.remove();
      return;
    }
    FlutterNativeSplash.remove();
  }
  Future<bool> refreshAccessToken() async {
    debugPrint("Attempting to refresh access token");
    final String? refreshToken =
        await AppPreferences().get(key: userRefreshToken, isModel: false);

    try {
      LoginModel? newTokenData = await _loginRepository.refreshAccessToken();
      if (newTokenData != null) {
        await AppPreferences().save(
            key: userTokenKey, value: newTokenData.accessToken, isModel: false);
        //fix the token expiry to epoch similar to login
        await AppPreferences().save(
            key: userTokenExpiry,
            value: DateTime.now().millisecondsSinceEpoch.toInt() +
                (newTokenData.expires ?? 0).toInt(),
            isModel: false);
        await AppPreferences().save(
            key: userRefreshToken,
            value: newTokenData.refreshToken,
            isModel: false);
        return true;
      }
    } catch (error) {
      debugPrint('Error refreshing access token: $error');
    }
    return false;
  }

  Future<void> loginSharedPreference() async {
    _loginCredentials['email'] =
        await AppPreferences().get(key: userEmailKey, isModel: false);
    _loginCredentials['password'] =
        await AppPreferences().get(key: userPasswordKey, isModel: false);
    if (_loginCredentials['email'] != null &&
        _loginCredentials['email'] != '' &&
        _loginCredentials['password'] != null &&
        _loginCredentials['password'] != '') {
      if (await login()) {
        if (await isActiveUser()) {
          NavigationService().navigateToScreen(BottomBar(userRole: userRole, currentTab: 0,));
        }
      }
    }
  }

  void setInputValues({required String index, dynamic value}) {
    debugPrint('value $value');
    _loginCredentials[index] = value;
  }

  Future<void> setPref(String index, dynamic value) async {
    await AppPreferences().save(key: index, value: value, isModel: false);
  }

  void setLoginResponseData(ApiResponse<LoginModel> response) async {
    _loginResponse = response;
    if (response.status == Status.COMPLETED) {
      await AppPreferences().save(
          key: userTokenKey, value: response.data?.accessToken, isModel: false);
      await setPref('userTokenKey', response.data?.accessToken);
      await AppPreferences().save(
          key: userEmailKey,
          value: _loginCredentials[EnglishStrings().formKeys['email']!],
          isModel: false);
      await setPref('userEmailKey',
          _loginCredentials[EnglishStrings().formKeys['email']!]);
      await AppPreferences().save(
          key: userPasswordKey,
          value: _loginCredentials[EnglishStrings().formKeys['password']!],
          isModel: false);
      await setPref('userPasswordKey',
          _loginCredentials[EnglishStrings().formKeys['password']!]);
      final dynamic tokenExpiryValue =
          await AppPreferences().get(key: userTokenExpiry, isModel: false);
      final int? tokenExpiryTime = tokenExpiryValue is int
          ? tokenExpiryValue
          : int.tryParse('${tokenExpiryValue ?? ''}');
      print("is token expired" + tokenExpiryTime.toString());
      int currentTime = DateTime.now().millisecondsSinceEpoch;

    }
    notifyListeners();
  }

  Future<void> setCredentials() async {
    await AppPreferences().save(
        key: userEmailKey, value: _loginCredentials['email'], isModel: false);
    await AppPreferences().save(
        key: userPasswordKey,
        value: _loginCredentials['password'],
        isModel: false);
    await AppPreferences().save(
        key: SHARED_LOGGED, value: true, isModel: false);

    notifyListeners();
  }

  Future<void> getCredentials() async {
    _userEmail = await AppPreferences().get(key: userEmailKey, isModel: false);
    _userPass =
        await AppPreferences().get(key: userPasswordKey, isModel: false);
    notifyListeners();
  }

  void removePasswordCredential() async {
    AppPreferences().remove(key: userPasswordKey);

    notifyListeners();
  }

  Future<bool> isActiveUser() async {
    try {
      dynamic result = await _loginRepository.getUserDetails();
      _userModelResponse = ApiResponse.completed(result);
      // await loginUserToCometChat(userId: _userModelResponse.data?.id ?? '');
      await AppPreferences().save(
          key: userIdKey, value: _userModelResponse.data?.id, isModel: false);

      _userRole = _userModelResponse.data?.role;
      debugPrint('user role is $_userRole');
      await AppPreferences().save(
          key: userRoleKey,
          value: _userModelResponse.data?.role,
          isModel: false);
      // await AppPreferences().save(
      //     key: userRoleKey,
      //     value: _userModelResponse.data?.role,
      //     isModel: false);
      await AppPreferences().save(
          key: userNameKey,
          value: '${_userModelResponse.data?.first_name}',
          isModel: false);
      await OneSignalService.identifyUser(
        userId: _userModelResponse.data?.id,
        email: _userModelResponse.data?.email,
        phone: _userModelResponse.data?.phone,
      );

      notifyListeners();

      return true;
    } catch (error) {
      _userModelResponse = ApiResponse.error(error.toString());
      return false;
    }
  }

  Future<bool> login() async {
    try {
      LoginModel? response =
          await _loginRepository.postLoginCredentials(_loginCredentials);
      setLoginResponseData(ApiResponse.completed(response));
      await AppPreferences()
          .save(key: SHARED_LOGGED, value: true, isModel: false);
      return true;
    } catch (error) {
      debugPrint('error loging in $error');
      setLoginResponseData(ApiResponse.error(error.toString()));
      return false;
    }
  }

  String get pendingResetEmail => _pendingResetEmail;

  Future<bool> requestPasswordReset() async {
    try {
      final email = _loginCredentials['reset-email']?.toString().trim() ?? '';
      if (email.isEmpty) return false;
      await _loginRepository.requestPasswordReset(email);
      _pendingResetEmail = email;
      return true;
    } catch (error) {
      debugPrint('error requesting password reset $error');
      setLoginResponseData(ApiResponse.error(error.toString()));
      return false;
    }
  }

  bool validate() {
    _loginErrors = {};
    debugPrint('email ${_loginCredentials[EnglishStrings().formKeys['email']!]}');
    debugPrint('password ${_loginCredentials[EnglishStrings().formKeys['password']!]}');
    String? emailMessage = AppValidation().isEmailValid(
        _loginCredentials[EnglishStrings().formKeys['email']!] ?? '');
    String? passwordMessage = AppValidation().isValidLoginPassword(
        _loginCredentials[EnglishStrings().formKeys['password']!] ?? '');
    if (emailMessage == null && passwordMessage == null) {
      notifyListeners();
      return true;
    }
    _loginErrors[EnglishStrings().formKeys['email']!] = emailMessage;
    _loginErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
    notifyListeners();
    return false;
  }

  Future<bool> validate1() async {
    _loginErrors = {};
    String? emailMessage =
        await AppPreferences().get(key: userEmailKey, isModel: false);
    debugPrint(emailMessage);
    String? passwordMessage =
        await AppPreferences().get(key: userPasswordKey, isModel: false);
    if (emailMessage == null && passwordMessage == null) {
      notifyListeners();
      return true;
    }
    _loginErrors[EnglishStrings().formKeys['email']!] = emailMessage;
    _loginErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
    notifyListeners();
    return true;
  }

  Future<bool> isTokenNotEmpty() async {
    try {
      final dynamic token =
          await AppPreferences().get(key: userTokenKey, isModel: false);
      return token != null && token != '';
    } catch (err) {
      return false;
    }
  }

  // get isActive => _userModelResponse.data?.status == 'active';
  get isLoggedIn => _loginResponse.status == Status.COMPLETED;
  get userRole => _userRole;
  get isTokenExpired => _userModelResponse.status == Status.ERROR;
  get errorMsg =>
      _loginResponse.status == Status.ERROR ? _loginResponse.message : null;
  get loginErrors => _loginErrors;
  get userEmail => _userPass;
  get userPass => _userEmail;
  get language => _language;
  get loginCredentials => _loginCredentials;
}
