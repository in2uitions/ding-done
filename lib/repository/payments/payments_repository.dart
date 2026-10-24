import 'package:dingdone/models/payments_model.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';

class PaymentsRepository {
  final BaseApiService _addPaymentCard =
      NetworkApiService(url: ApiEndPoints().addPaymentCard);
  final BaseApiService _apiAuthorizeCard =
      NetworkApiService(url: ApiEndPoints().authorizeCard);
  final BaseApiService _deletePaymentCard =
      NetworkApiService(url: ApiEndPoints().deletePaymentCard);
  final BaseApiService _customerCards =
      NetworkApiService(url: ApiEndPoints().customerCards);
  final BaseApiService _deleteCard =
      NetworkApiService(url: ApiEndPoints().deleteCard);
  final BaseApiService _initiateCardSave =
      NetworkApiService(url: ApiEndPoints().initiateCardSave);
  final BaseApiService _verifyCard =
      NetworkApiService(url: ApiEndPoints().verifyCard);
  final BaseApiService _addOrUpdateTapCustomer =
      NetworkApiService(url: ApiEndPoints().addOrUpdateTapCustomer);
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
  Future<dynamic> patchCustomerTapId({required id,required customer_id}) async {
    try {
      dynamic response = await _apiCustomerProfile.patchResponse(id:id,data: {'tap_id':customer_id});
      // final jsonData = PaymentsModelMain.fromJson(response);
      debugPrint('response in patching customer card $response');

      return response;
    } catch (error) {
      debugPrint('error in patching customer card $error');
      rethrow;
    }
  }
  Future<dynamic> authorizeCard({required  body}) async {
    try {
      dynamic response =
          await _apiAuthorizeCard.postResponse(data: body, logBody: false);
      debugPrint('response in authorizing customer card $response');

      return response;
    } catch (error) {
      debugPrint('error in authorizing customer card $error');
      rethrow;
    }
  }
  Future<dynamic> getCustomerCards() async {
    try {
      return await _customerCards.getResponse();
    } catch (error) {
      debugPrint('error in listing cards $error');
      rethrow;
    }
  }

  Future<dynamic> deleteTapCard(String cardId) async {
    try {
      return await _deleteCard.postResponse(data: {'card_id': cardId});
    } catch (error) {
      debugPrint('error in deleting tap card $error');
      rethrow;
    }
  }

  Future<dynamic> verifyCard(String token) async {
    try {
      return await _verifyCard.postResponse(
        data: {'token': token},
        logBody: false,
      );
    } catch (error) {
      debugPrint('error in verifying card');
      rethrow;
    }
  }

  Future<dynamic> initiateCardSave(Map<String, dynamic> card) async {
    try {
      return await _initiateCardSave.postResponse(data: card, logBody: false);
    } catch (error) {
      debugPrint('error in initiating card save');
      rethrow;
    }
  }

  Future<dynamic> addOrUpdateTapCustomer() async {
    try {
      return await _addOrUpdateTapCustomer.postResponse(data: {});
    } catch (error) {
      debugPrint('error in creating tap customer $error');
      rethrow;
    }
  }

  Future<dynamic> deletePaymentCard(dynamic body) async {
    try {
      dynamic response = await _deletePaymentCard.postResponse(data: body);
      debugPrint('deleting payment card $response');
      // final jsonData = PaymentsModelMain.fromJson(response);
      return response;
    } catch (error) {
      debugPrint('error in deleting card $error');
      rethrow;
    }
  }

  Future<String> getUserId() async {
    try {
      final token = await AppPreferences().get(key: userIdKey, isModel: false);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }
  Future<String> getRole() async {
    try {
      final role =
          await AppPreferences().get(key: userRoleKey, isModel: false);
      return role ?? '';
    } catch (err) {
      return '';
    }
  }



}
