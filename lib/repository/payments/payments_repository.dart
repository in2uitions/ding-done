import 'package:dingdone/models/payments_model.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentsRepository {
  final BaseApiService _addPaymentCard =
      NetworkApiService(url: ApiEndPoints().addPaymentCard);
  final BaseApiService _getAllPayments =
      NetworkApiService(url: ApiEndPoints().getAllPayments);
  final BaseApiService _apiCustomerProfile =
  NetworkApiService(url: ApiEndPoints().customerProfile);

  Future<PaymentsModelMain?> getPayments(dynamic id) async {
    try {
      String role= await getRole();
      dynamic response;
      if(Constants.supplierRoleId==role){
        String user =await getUserId();
        response = await _apiCustomerProfile.getResponse(
            params:
            '?fields=*.*&filter[user][_eq]=$id');
        debugPrint('data in customer profile ${response["data"][0]["id"]}');
        response = await _getAllPayments.getResponse(params: '&filter[customer][_eq]=${response["data"][0]["id"]}');

      }else{
        response = await _getAllPayments.getResponse(params: '&filter[customer][_eq]=$id');

      }
      final jsonData = PaymentsModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      debugPrint('error in getting card $error');
      rethrow;
    }
  }

  Future<dynamic> addPaymentCard(dynamic body) async {
    try {
      dynamic response = await _addPaymentCard.postResponse(data: body);
      // final jsonData = PaymentsModelMain.fromJson(response);
      return response;
    } catch (error) {
      debugPrint('error in adding card $error');
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
      final role=prefs.getString(userRoleKey);
      return role ?? '';
    } catch (err) {
      return '';
    }
  }



}