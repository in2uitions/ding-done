import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/models/profile_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  final BaseApiService _apiSupplierProfile =
      NetworkApiService(url: ApiEndPoints().supplierProfile);
  final BaseApiService _apiCustomerProfile =
      NetworkApiService(url: ApiEndPoints().customerProfile);
  final BaseApiService _apiSupplierLocation =
      NetworkApiService(url: ApiEndPoints().supplierChangeLocation);
  final BaseApiService _userApi =
  NetworkApiService(url: ApiEndPoints().userData);

  Future<ProfileModel?> getProfileBody() async {
    try {
      ProfileModel? jsonData;
      String userId = await getUserId();
      String role = await getRole();
      debugPrint('user id ${userId}');
      debugPrint('role id ${role}');
      dynamic response;
      if (Constants.customerRoleId == role) {
        response = await _apiCustomerProfile.getResponse(
            params: '?fields=*.*&filter[user][_eq]=$userId');
      } else {
        if (Constants.supplierRoleId == role) {
          response = await _apiSupplierProfile.getResponse(
              params: '?fields=*.*.*&filter[user][_eq]=$userId');
        }
      }
      debugPrint('resounse is ${response['data'][0]}');
      if (response['data'] != null && response['data'].length > 0) {
        jsonData = ProfileModel.fromJson(response['data'][0]);
      }
      return jsonData;
    } catch (error) {
      debugPrint('error in fetching profile data ${error}');
      rethrow;
    }
  }

  Future<ProfileModel?> patchProfileState(
      {required int id, dynamic body}) async {
    try {
      String userId = await getUserId();
      body["user"] = userId;
      String role = await getRole();
      debugPrint('body is $body');
      dynamic response;
      if (Constants.customerRoleId == role) {
        response = await _apiCustomerProfile.patchResponse(
            id: id, data: body, params: '?fields=*.*');
      } else {
        if (Constants.supplierRoleId == role) {
          debugPrint('supplier body ${body}');
          response = await _apiSupplierProfile.patchResponse(
              id: id, data: body, params: '?fields=*,supplier_info.*');
        }
      }
      final jsonData = ProfileModel.fromJson(response['data']);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }
  Future<dynamic> changeCurrentLocation(
      {dynamic body}) async {
    try {
      String userId = await getUserId();
      body["supplier_id"] = userId;
      String role = await getRole();
      dynamic response;
      if (Constants.customerRoleId == role) {
        debugPrint('customer change location ');
        // response = await _apiCustomerLocation.postResponse(
        //    data: body);
      } else {
        if (Constants.supplierRoleId == role) {
          debugPrint('supplier change location ');
          debugPrint('supplier body ${body}');
          response = await _apiSupplierLocation.postResponse(
            data: body);
        }
      }
      debugPrint('response of change location $response');
      return response;
    } catch (error) {
      debugPrint('error in repo change location $error');
      rethrow;
    }
  }
// Function to recursively remove the 'token' field
  void removeToken(Map<String, dynamic> map) {
    map.remove('token'); // Remove the 'token' at the current level
    map.remove('user_updated');
    map.remove('user_created');
    map.remove('supplier_info');
    map.remove('customer_info');
    map.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        removeToken(value); // Recursively remove 'token' from nested maps
      } else if (value is List) {
        for (var item in value) {
          if (item is Map<String, dynamic>) {
            removeToken(item); // Remove 'token' from each map in a list
          }
        }
      }
    });
  }
  Future<ProfileModel?> patchProfile({required int id, dynamic body}) async {
    try {
      String userId = await getUserId();

      String role = await getRole();
      dynamic response;
      debugPrint('patching daa $body');
      if (Constants.customerRoleId == role) {
        // // Make a copy of the body to avoid mutating the original data
        // var cleanedBody = Map<String, dynamic>.from(body);
        // // Remove the 'token' field from the cleanedBody
        // removeToken(cleanedBody);
        // Call the patchResponse method with the cleanedBody
        // var finalBody = <String, dynamic>{};
        // finalBody["user"]=cleanedBody["user"];
        // debugPrint('supplier finalBody body ${finalBody}');

        response = await _apiCustomerProfile.patchResponse(
            id: id, data: body, params: '?fields=*.*');
        debugPrint('customer ${response}');
      } else {
        if (Constants.supplierRoleId == role) {
          // Make a copy of the body to avoid mutating the original data
          var cleanedBody = Map<String, dynamic>.from(body);
          // Remove the 'token' field from the cleanedBody
          removeToken(cleanedBody);
          debugPrint('clean body address ${cleanedBody["address"]}');
          debugPrint('clean body current address ${cleanedBody["current_address"]}');

          // Call the patchResponse method with the cleanedBody
          var finalBody = <String, dynamic>{};
          finalBody["user"]=cleanedBody["user"];
          finalBody["current_address"]=cleanedBody["current_address"];
          debugPrint('address is ${cleanedBody['address']}');
          if(cleanedBody["address"]!=null){
            finalBody["address"]=cleanedBody["address"];

          }
          debugPrint('supplier finalBody body ${finalBody}');

          response = await _apiSupplierProfile.patchResponse(
            id: id,
            data: finalBody,
            params: '?fields=*.*',
          );

          debugPrint('supplier ${response}');
        }
      }
      final jsonData = ProfileModel.fromJson(response['data']);
      return jsonData;
    } catch (error) {
      debugPrint('error in patching data repo $error');
      rethrow;
    }
  }

  Future<dynamic> patchPassword({required String id, dynamic body}) async {
    try {

      dynamic response;
        response = await _userApi.patchResponse(
            id: id, data: body, params: '?fields=*.*');
        debugPrint('patch passqw response repo ${response}');


      // final jsonData = UserModel.fromJson(response['data']);
      debugPrint('jsondata repo ${response}');

      return response["data"];
    } catch (error) {
      rethrow;
    }
  }

  Future<String> getUserId() async {
    try {
      // String? token =
      // await AppPreferences().get(key: userIdKey, isModel: false);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(userIdKey);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }

  Future<String> getRole() async {
    try {
      // String? role=await AppPreferences().get(key: userRoleKey, isModel: false);
      final prefs = await SharedPreferences.getInstance();
      final role = prefs.getString(userRoleKey);
      return role ?? '';
    } catch (err) {
      return '';
    }
  }
}
