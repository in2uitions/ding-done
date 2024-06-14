import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';

class CategoriesRepo {
  final BaseApiService _apiCategories =
      NetworkApiService(url: ApiEndPoints().getCategories);

  Future<DropDownModelMain?> getAllCategories() async {
    try {
      dynamic response = await _apiCategories.getResponse();
      final jsonData = DropDownModelMain.fromJson(response);
      return jsonData;
    } catch (error) {
      rethrow;
    }
  }

}
