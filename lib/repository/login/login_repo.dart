import 'dart:convert';

import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/models/login_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  final BaseApiService _apiService =
      NetworkApiService(url: ApiEndPoints().login);
  final BaseApiService _userApiService =
      NetworkApiService(url: ApiEndPoints().usersMe);
  final BaseApiService _apiUser =
      NetworkApiService(url: ApiEndPoints().userData);
  final BaseApiService _refreshToken =
      NetworkApiService(url: ApiEndPoints().refreshToken);
  final BaseApiService _apisendSMS =
      NetworkApiService(url: ApiEndPoints().sendSMS);

  final BaseApiService _apiSendReset =
      NetworkApiService(url: ApiEndPoints().apiSendReset);

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
      final prefs = await SharedPreferences.getInstance();

      // Get the old refresh token from SharedPreferences
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

  Future<dynamic> sendResetEmail(dynamic body) async {
    try {
      // debugPrint('body is ${body}');
      // // await sdk.auth.forgottenPassword.request(usreml);
      // dynamic response=_apiSendReset.postResponse(data: body);
      // debugPrint('Request Sent ${response}');

      http.Response res = await http
          .post(Uri.parse("https://cms.dingdone.app/email/reset-data"), body: {
        'email': body['email'].toString(),
      }).catchError((value) async {
        debugPrint('error is ${value.body}');

        throw ('Error message ${value.body}');
      });
      debugPrint('res.body is ${res.body}');
      sendResetEmail1(jsonDecode(res.body));
      debugPrint('Request Sent');
      return res.body;
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<dynamic> sendResetSMS(dynamic body) async {
    try {
      // Encode your Mailjet API key and secret in Base64
      String apiCredentials = base64Encode(utf8.encode(
          "${Constants.MJ_APIKEY_PUBLIC}:${Constants.MJ_APIKEY_PRIVATE}"));
      var rndnumber = "";
      var rnd = new Random();
      for (var i = 0; i < 4; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      await AppPreferences()
          .save(key: otpNumber, value: rndnumber, isModel: false);
      // await AppPreferences()
      //     .save(key: userIdTochangePassword, value: body["id"], isModel: false);
      dynamic response = await _apisendSMS.postResponse(data: {
        'recipientPhone': body['recipientPhone'].toString(),
        'smsText': 'Hi,\n this is your OTP $rndnumber'
      });

      // http.Response res = await http.post(
      //     Uri.parse("https://cms.dingdone.app/registerUser/sendOTP"),
      //     body: {
      //       'recipientPhone': body['recipientPhone'].toString(),
      //       'smsText': 'Hi,\n this is your OTP $rndnumber'
      //     }).catchError((value) async {
      //   debugPrint('error is ${value.body}');
      //
      //   throw ('Error message ${value.body}');
      // });
      debugPrint('res.body is ${response}');
      // sendResetEmail1(jsonDecode(response));
      debugPrint('Request Sent');
      return response;
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<String?> sendResetEmail1(Map<String, dynamic> body) async {
    try {
      debugPrint('body is ${body}');
      // Encode your Mailjet API key and secret in Base64
      String apiCredentials = base64Encode(utf8.encode(
          "${Constants.MJ_APIKEY_PUBLIC}:${Constants.MJ_APIKEY_PRIVATE}"));
      var rndnumber = "";
      var rnd = new Random();
      for (var i = 0; i < 4; i++) {
        rndnumber = rndnumber + rnd.nextInt(9).toString();
      }
      await AppPreferences()
          .save(key: otpNumber, value: rndnumber, isModel: false);
      await AppPreferences()
          .save(key: userIdTochangePassword, value: body["id"], isModel: false);
      http.Response res = await http
          .post(
        Uri.parse("https://api.mailjet.com/v3.1/send"),
        headers: {
          'Authorization': 'Basic $apiCredentials',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "Messages": [
            {
              "From": {
                "Email": "rim.zakhour@in2uitions.com",
                "Name": "DingDone"
              },
              "To": [
                {
                  "Email": body["email"],
                  "Name": body["first_name"] + " " + body["last_name"]
                }
              ],
              "TemplateID": 5532729,
              "TemplateLanguage": true,
              "Subject": "Reset Password",
              "Variables": {
                "reset_link": "com.in2uitions.dingdone://new_password/",
                "email": body["email"],
                "name": body["first_name"] + " " + body["last_name"],
                "otp": rndnumber
              }
            }
          ]
        }),
      )
          .catchError((value) async {
        debugPrint('error is ${value.body}');
        throw ('Error message ${value.body}');
      });

      debugPrint('res.body is ${res.body}');
      debugPrint('Request Sent');
      return res.body;
    } catch (e) {
      debugPrint('error $e');
    }
  }

  Future<UserModel?> getUserDetails() async {
    try {
      dynamic response = await _userApiService.getResponse();
      final jsonData = UserModel.fromJson(response['data']);
      return jsonData;
    } catch (e) {
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
