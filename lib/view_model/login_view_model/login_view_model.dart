import 'dart:convert';

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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // String? _language = "en-US";

  LoginViewModel() {
    readJson();
  }
  Future<void> readJson() async {
    // AppPreferences().clear();

  }

  Future<void> checkAndRefreshToken() async {
    if (await isTokenExpired()) {
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

    if (await isTokenNotEmpty() && !await isTokenExpired()) {
      if (await isTokenExpired()) {
        bool refreshSuccess = await refreshAccessToken();
        print('refreshed access token from splash login');
        if (!refreshSuccess) {
          NavigationService().navigateToScreen(const OnBoardingScreen());
          FlutterNativeSplash.remove();
          return;
        }
      }
      if (!await isActiveUser()) {
        await loginSharedPreference();
      } else {
        NavigationService().navigateToScreen(BottomBar(userRole: userRole));
      }
    } else {
      NavigationService().navigateToScreen(const OnBoardingScreen());
    }
    FlutterNativeSplash.remove();
  }
  Future<bool> refreshAccessToken() async {
    debugPrint("Attempting to refresh access token");
    final prefs = await SharedPreferences.getInstance();

    String? refreshToken = prefs.getString('refresh_token');

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
            key: refreshToken,
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
          NavigationService().navigateToScreen(BottomBar(userRole: userRole));
        } else {
          NavigationService().navigateToScreen(const OnBoardingScreen());
        }
      } else {
        NavigationService().navigateToScreen(const OnBoardingScreen());
      }
    } else {
      NavigationService().navigateToScreen(const OnBoardingScreen());
    }
  }

  void setInputValues({required String index, dynamic value}) {
    _loginCredentials[index] = value;
  }

  Future<void> setPref(String index, dynamic value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(index, value);
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
      final prefs = await SharedPreferences.getInstance();
      int? tokenExpiryTime = prefs.getInt(userTokenExpiry);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(SHARED_LOGGED, true);
    await prefs.setString(
      userEmailKey,
      _loginCredentials['email'],
    );
    await prefs.setString(userPasswordKey, _loginCredentials['password']);

    notifyListeners();
  }

  Future<void> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _userEmail = await AppPreferences().get(key: userEmailKey, isModel: false);
    _userPass =
        await AppPreferences().get(key: userPasswordKey, isModel: false);
    _userEmail = await prefs.getString(userEmailKey);
    _userPass = await prefs.getString(userPasswordKey);
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
      final prefs = await SharedPreferences.getInstance();

      await AppPreferences().save(
          key: userIdKey, value: _userModelResponse.data?.id, isModel: false);
      await prefs.setString(userIdKey, '${_userModelResponse.data?.id}');

      _userRole = _userModelResponse.data?.role;
      await AppPreferences().save(
          key: userRoleKey,
          value: _userModelResponse.data?.role,
          isModel: false);
      await prefs.setString(userRoleKey, _userRole!);
      // await AppPreferences().save(
      //     key: userRoleKey,
      //     value: _userModelResponse.data?.role,
      //     isModel: false);
      await AppPreferences().save(
          key: userNameKey,
          value: '${_userModelResponse.data?.first_name}',
          isModel: false);
      await prefs.setString(
          userNameKey, '${_userModelResponse.data?.first_name}');
      OneSignal.login('${_userModelResponse.data?.id}');
      OneSignal.User.addEmail('${_userModelResponse.data?.email}');
      OneSignal.User.addSms('${_userModelResponse.data?.phone}');
      debugPrint('Onesignal ${OneSignal.User}');

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
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(SHARED_LOGGED, true);
      return true;
    } catch (error) {
      debugPrint('error loging in $error');
      setLoginResponseData(ApiResponse.error(error.toString()));
      return false;
    }
  }

  Future<bool> sendResetEmail() async {
    try {
      final response = _loginRepository
          .sendResetEmail({'email': _loginCredentials["reset-email"]});
      debugPrint('response sending email $response');
      // final response = await http.post(
      //   Uri.parse('https://your-server-url/send-email'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'email': _loginCredentials["reset-email"]}),
      // );

      // if (response.statusCode == 200) {
      //   // Email sent successfully
      //   print('Email sent successfully');
      // } else {
      //   // Error handling
      //   print('Error sending email: ${response.body}');
      // }
      return true;
    } catch (error) {
      debugPrint('error sending email $error');
      setLoginResponseData(ApiResponse.error(error.toString()));
      return false;
    }
  }

  bool validate() {
    _loginErrors = {};
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
      final prefs = await SharedPreferences.getInstance();

      String? token =
          // await AppPreferences().get(key: userTokenKey, isModel: false);
          await prefs.getString(userTokenKey);
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
