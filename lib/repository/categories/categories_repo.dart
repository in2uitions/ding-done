import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:flutter/cupertino.dart';

class CategoriesRepo {
  final BaseApiService _apiCategories =
      NetworkApiService(url: ApiEndPoints().getCategories);
  final BaseApiService _apiCategoriesAndServices =
      NetworkApiService(url: ApiEndPoints().getCategoriesAndServices);

  Future<DropDownModelMain?> getAllCategories() async {
    try {
      dynamic response = await _apiCategories.getResponse();
      final jsonData = DropDownModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }
 Future<dynamic> getCategoriesAndServices() async {
    try {
      dynamic response = await _apiCategoriesAndServices.getResponse();
      debugPrint('response in get categories and serices $response');
      return response;
    } catch (error) {
      debugPrint('error in get categories and serices $error');

      rethrow;
    }
  }

}
