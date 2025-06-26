import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
// import 'package:dingdone/models/result_confirm_email.dart';
import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/res/app_prefs.dart';

class SignUpRepository {
  final BaseApiService _apiRoleGet =
      NetworkApiService(url: ApiEndPoints().getRoles);
  final BaseApiService _apiCountriesGet =
      NetworkApiService(url: ApiEndPoints().getCountries);
  final BaseApiService _apiUserRegister =
      NetworkApiService(url: ApiEndPoints().userRegister);
  // final BaseApiService _apiEmailConfirm =
  //     NetworkApiService(url: ApiEndPoints().emailConfirm);
  final BaseApiService _userUpdate =
      NetworkApiService(url: ApiEndPoints().userUpdate);

  final BaseApiService _apiCompanies =
  NetworkApiService(url: ApiEndPoints().getCompanies);

  Future<DropDownModelMain?> getRoles() async {
    try {
      dynamic response = await _apiRoleGet.getResponse();
      final jsonData = DropDownModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }
  Future<dynamic> getCountries() async {
    try {
      dynamic response = await _apiCountriesGet.getResponse(sendToken: false);
      // final jsonData = DropDownModelMain.fromJson(response);
      return response;
    } catch (error) {
      rethrow;
    }
  }

  Future<UserModel>? updateUser({dynamic data}) async {
    try {
      String userId = await getUserId();

      dynamic response =
          await _userUpdate.patchResponse(id: userId, data: data);
      final jsonData = UserModel.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }
  Future<dynamic> getCompanies() async {
    try {
      dynamic response =
      await _apiCompanies.getResponse(sendToken: false);
      // debugPrint('response in get categories and serices $response');
      return response;
    } catch (error) {
      debugPrint('error in get companies $error');

      rethrow;
    }
  }
  // Future<String> getUserRoleFromId(String id) async {
  //   try {
  //     String roleName = id;
  //     String role = '';
  //     // if (roleName == jobSeeker) {
  //     //   role = 'jobseeker';
  //     // } else {
  //     //   role = 'recruiter';
  //     // }
  //     return role;
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<dynamic?> postUserCredentials(dynamic body) async {
    try {
      dynamic response =
          await _apiUserRegister.postResponse(data: body, sendToken: false);
      if(response["data"]!=null){

        final jsonData = UserModel.fromJson(response['data']);
        debugPrint('data in post user credentials ${jsonData}');
        return jsonData;

      }else{
        debugPrint('response in error $response');
        return response;
      }


    } catch (error) {
      debugPrint('error in post user credentials ${error}');
      rethrow;
    }
  }

  // Future<ResultConfirmEmail?> postEmailConfimation(dynamic body) async {
  //   try {
  //     dynamic response = await _apiEmailConfirm.postResponse(data: body);
  //     final jsonData = ResultConfirmEmail.fromJson(response);
  //     debugPrint('data in post email confirmation ${jsonData}');

  //     return jsonData;
  //   } catch (error) {
  //     debugPrint('error in post email confirmation ${error}');
  //     rethrow;
  //   }
  // }

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
