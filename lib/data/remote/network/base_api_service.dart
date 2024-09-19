abstract class BaseApiService {
  // final String baseUrl = "http://192.168.0.108:8056";
  final String baseUrl = "https://cms.dingdone.app";

  Future<dynamic> getResponse({params = '', bool sendToken});
  Future<dynamic> postResponse({required dynamic data, bool sendToken, String params = ''});
  Future<dynamic> postResponseFile({required dynamic data, bool sendToken, String params = ''});
  Future<dynamic> patchResponse({required dynamic id, dynamic data, String params =''});
  Future<dynamic> deleteResponse({params = ''});
}
