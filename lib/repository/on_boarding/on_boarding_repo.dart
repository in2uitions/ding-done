import 'package:dingdone/data/remote/network/api_end_points.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/data/remote/network/network_api_service.dart';
import 'package:dingdone/models/on_boarding_model.dart';

class OnBoardingRepository {
  final BaseApiService _apiService =
      NetworkApiService(url: ApiEndPoints().onBoarding);

  Future<OnBoardingMain?> getOnBoardingList() async {
    try {
      dynamic response = await _apiService.getResponse();
      final jsonData = OnBoardingMain.fromJson(response);
      return jsonData;
    } catch (e) {
      rethrow;
    }
  }
}
