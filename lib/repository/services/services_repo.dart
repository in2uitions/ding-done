import 'package:dingdone/models/country_rates_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';

class ServicesRepository {
  final BaseApiService _apiServices =
      NetworkApiService(url: ApiEndPoints().getServices);
  final BaseApiService _apiSupplier =
      NetworkApiService(url: ApiEndPoints().supplierProfile);
  final BaseApiService _apiCountryRates =
      NetworkApiService(url: ApiEndPoints().countryRates);

  Future<ServicesModelMain?> getAllServices() async {
    try {
      dynamic response = await _apiServices.getResponse();
      final jsonData = ServicesModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }

  Future<CountryRatesModelMain?> getContryRate(
      dynamic service_id, String country_code) async {
    try {
      dynamic response = await _apiCountryRates.getResponse(
          params:
              '?filter[country][_eq]=$country_code&filter[service][id][_eq]=${service_id}');
      final jsonData = CountryRatesModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> getServicesByCategoryID(int id) async {
    try {
      dynamic response = await _apiServices.getResponse(
          params: '&filter[category][id][_eq]=$id');
      debugPrint('responseee 2222${response["data"]}');
      // final jsonData = ServicesModelMain.fromJson(response["data"]);
      // debugPrint('jsoon data ${jsonData}');
      return response["data"];
      // return jsonData;
    } catch (error) {
      rethrow;
    }
  }

  Future<dynamic> setServiceForSupplier(int supplier_id, int service_id) async {
    try {
      dynamic existingResponse =
          await _apiSupplier.getResponse(params: '/$supplier_id?fields=*.*');

      if (existingResponse["data"] != null) {
        if (existingResponse["data"].containsKey('supplier_services')) {
          List<dynamic> existingServices =
              existingResponse["data"]['supplier_services'];
          existingServices.add({"services_id": service_id});
          Map<String, dynamic> updatedData = {
            "supplier_services": existingServices,
          };
          dynamic response = await _apiSupplier.patchResponse(
            data: updatedData,
            id: supplier_id,
          );

          if (response != null) {
            // Successfully updated the 'supplier_services' field
            // Handle the response as needed
          } else {
            // Handle the API request error
          }
        } else {
          // Handle the case where 'supplier_services' is not found in the response
        }
      } else {
        // Handle the case where the initial fetch returned null or encountered an error
      }

      return;
    } catch (error) {
      debugPrint('erroor ${error}');
      rethrow;
    }
  }

  Future<dynamic> removeServiceForSuplier(
      int supplier_id, int service_id) async {
    try {
      dynamic existingResponse =
          await _apiSupplier.getResponse(params: '/$supplier_id?fields=*.*');
      debugPrint('existing response $existingResponse');

      if (existingResponse["data"] != null) {
        if (existingResponse["data"].containsKey('supplier_services')) {
          List<dynamic> existingServices =
              existingResponse["data"]['supplier_services'];

          existingServices
              .removeWhere((element) => element["services_id"] == service_id);

          Map<String, dynamic> updatedData = {
            "supplier_services": existingServices,
          };
          dynamic response = await _apiSupplier.patchResponse(
            data: updatedData,
            id: supplier_id,
          );
        }
      }
      return;
    } catch (error) {
      debugPrint('erroor ${error}');
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
