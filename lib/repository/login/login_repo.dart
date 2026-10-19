import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/models/login_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/res/app_prefs.dart';

class LoginRepository {
  final BaseApiService _apiService =
      NetworkApiService(url: ApiEndPoints().login);
  final BaseApiService _userApiService =
      NetworkApiService(url: ApiEndPoints().usersMe);
  final BaseApiService _apiUser =
      NetworkApiService(url: ApiEndPoints().userData);
  final BaseApiService _refreshToken =
      NetworkApiService(url: ApiEndPoints().refreshToken);
  final BaseApiService _requestPasswordReset =
      NetworkApiService(url: ApiEndPoints().requestPasswordReset);
  final BaseApiService _resetPassword =
      NetworkApiService(url: ApiEndPoints().resetPassword);

  Future<LoginModel?> postLoginCredentials(dynamic body) async {
    try {
      dynamic response =
          await _apiService.postResponse(data: body, sendToken: false);
      debugPrint('response in post credential is $response');
      final jsonData = LoginModel.fromJson(response['data']);
      debugPrint('response in post credential jsonData is $jsonData');

      return jsonData;
    } catch (e) {
      debugPrint('error $e');
      rethrow;
    }
  }

  Future<LoginModel?> refreshAccessToken() async {
    try {
      String? oldRefreshToken =
          await AppPreferences().get(key: userRefreshToken, isModel: false);

      print('Old Refresh Token: $oldRefreshToken');

      if (oldRefreshToken == null) {
        debugPrint('No refresh token available');
        return null;
      }

      var body = {"refresh_token": "$oldRefreshToken", "mode": "json"};

      dynamic response =
          await _refreshToken.postResponse(data: body, sendToken: true);
      debugPrint('response is $response');
      final newTokenData = LoginModel.fromJson(response['data']);
      debugPrint('newTokenData is $newTokenData');
      return newTokenData;
    } catch (e) {
      debugPrint('Error refreshing access token repo: $e');
      return null;
    }
  }

  void _rejectIfError(dynamic response) {
    if (response is! Map) return;
    if (response['status']?.toString() == 'NOT_OK') {
      throw Exception(
        response['message']?.toString() ?? 'Reset failed',
      );
    }
    final errors = response['errors'];
    if (errors != null || response['error'] != null) {
      final message = response['message'] ?? response['error'] ?? errors;
      throw Exception(message.toString());
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final response = await _requestPasswordReset.postResponse(
      data: {'email': email},
      sendToken: false,
    );
    _rejectIfError(response);
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String smsCode,
    required String password,
  }) async {
    final response = await _resetPassword.postResponse(
      data: {
        'email': email,
        'token': token,
        'sms_code': smsCode,
        'password': password,
      },
      sendToken: false,
    );
    _rejectIfError(response);
  }

  Future<UserModel?> getUserDetails() async {
    try {
      dynamic response = await _userApiService.getResponse();
      final jsonData = UserModel.fromJson(response['data']);
      debugPrint('user details is $jsonData');
      return jsonData;
    } catch (e) {
      debugPrint('error getting user details $e');
      rethrow;
    }
  }

  Future<bool?> getActiveState({dynamic body}) async {
    try {
      String userId = await getUserId();
      dynamic response = await _apiUser.getResponse(params: '/$userId');
      return response["data"]["is_active"];
    } catch (error) {
      rethrow;
    }
  }

  Future<void> patchUserActive(dynamic body) async {
    try {
      String userId = await getUserId();
      dynamic response = await _apiUser.patchResponse(id: userId, data: body);
    } catch (error) {
      debugPrint('error  post Active data  ${error}');
      rethrow;
    }
  }

  Future<String> getUserId() async {
    try {
      String? token =
          await AppPreferences().get(key: userIdKey, isModel: false);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }
}
