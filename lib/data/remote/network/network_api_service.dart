import 'dart:convert';
import 'dart:io';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dingdone/data/remote/app_exception.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/utils/navigation_service.dart';
import 'package:dingdone/view/on_boarding/on_boarding.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class NetworkApiService extends BaseApiService {
  final String url;
  Map<String, String> headers = {};

  NetworkApiService({required this.url}) {
    if (headers[HttpHeaders.contentTypeHeader] == null) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
    }
  }

  @override
  Future getResponse({params = '',bool sendToken = true,}) async {
    dynamic responseJson;
    String finalUrl = baseUrl + url;
    if (params != '') {
      finalUrl = '$finalUrl$params';
    }
    debugPrint(finalUrl);
    try {
      String? tokenValue;
      if(sendToken){
        tokenValue = await getToken();
        if (tokenValue != '' && url=='/users/me') {
          headers[HttpHeaders.authorizationHeader] = tokenValue;
        }else{
          headers[HttpHeaders.contentTypeHeader] = 'application/json';

        }

        headers[HttpHeaders.authorizationHeader] = tokenValue;
      }

      debugPrint('final url $finalUrl');
      debugPrint('token value $tokenValue');
      // headers[HttpHeaders.authorizationHeader] =
      // 'Bearer yINQ0FBZ_j35uR8OP1gUZ8P3BP6RNEuh';
      final response;
      response = await http.get(Uri.parse(finalUrl), headers: headers);
      responseJson = returnResponse(response);
    } catch (error) {
      debugPrint('error $error');
      rethrow;
    }
    return responseJson;
  }
 @override
  Future getResponseFile({params = '',bool sendToken = true,}) async {
    dynamic responseJson;
    String finalUrl = baseUrl + url;
    if (params != '') {
      finalUrl = '$finalUrl$params';
    }
    debugPrint(finalUrl);
    try {
      String? tokenValue;
      if(sendToken){
        tokenValue = await getToken();
        if (tokenValue != '' && url=='/users/me') {
          headers[HttpHeaders.authorizationHeader] = tokenValue;
        }else{
          headers[HttpHeaders.contentTypeHeader] = 'application/json';

        }

        headers[HttpHeaders.authorizationHeader] = tokenValue;
      }

      debugPrint('final url file $finalUrl');
      debugPrint('token value $tokenValue');
      // headers[HttpHeaders.authorizationHeader] =
      // 'Bearer yINQ0FBZ_j35uR8OP1gUZ8P3BP6RNEuh';
      final response;
      response = await http.get(Uri.parse(finalUrl), headers: headers);
      return response.bodyBytes;
    } catch (error) {
      debugPrint('error $error');
      rethrow;
    }
    return responseJson;
  }

  @override
  Future postResponse(
      {required dynamic data,
      bool sendToken = true,
      String params = ''}) async {
    dynamic responseJson;
    if (sendToken) {
      String tokenValue = await getToken();
      if (tokenValue != '') {
        debugPrint('there is a token');
        headers[HttpHeaders.authorizationHeader] = tokenValue;
      }
      headers[HttpHeaders.authorizationHeader] = await getToken();
    }
    debugPrint('final kkk}');

    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    // headers[HttpHeaders.authorizationHeader] = await getToken();
    // headers[HttpHeaders.authorizationHeader] =
    // 'Bearer yINQ0FBZ_j35uR8OP1gUZ8P3BP6RNEuh';
    String finalUrl = baseUrl + url;
    debugPrint('final ${finalUrl}');

    if (params != '') {
      finalUrl = '$finalUrl$params';
    }
    debugPrint('final ${finalUrl}');
    debugPrint('data ${data}');
    debugPrint('token ${headers[HttpHeaders.authorizationHeader]}');
    try {
      final response;
      response = await http.post(Uri.parse(finalUrl),
          headers: headers,
          body: jsonEncode(data));
      debugPrint('response network ${response.body}');

      responseJson = await returnResponse(response);
      debugPrint('response json ${responseJson}');

    } catch (error) {
      debugPrint('error network api $error');
      rethrow;
    }
    return responseJson;
  }
  @override
  Future<File?> postResponseFile({
    required dynamic data,
    bool sendToken = true,
    String params = '',
  }) async {
    if (sendToken) {
      String tokenValue = await getToken();
      if (tokenValue.isNotEmpty) {
        headers[HttpHeaders.authorizationHeader] = tokenValue;
      }
    }
    headers[HttpHeaders.contentTypeHeader] = 'application/json';

    String finalUrl = baseUrl + url;
    if (params.isNotEmpty) {
      finalUrl = '$finalUrl$params';
    }

    debugPrint('Requesting URL: $finalUrl');
    debugPrint('Request data: $data');

    try {
      final response = await http.post(
        Uri.parse(finalUrl),
        headers: headers,
        body: jsonEncode(data),
      );

      // Handle response status codes
      if (response.statusCode == 200) {
        final fileData = response.bodyBytes;

        if (fileData.isNotEmpty) {
          final appDocumentsDirectory = await getTemporaryDirectory();
          final filePath =
              '${appDocumentsDirectory.path}/DingDone_Job_${data["job_id"]}.pdf';
          final file = File(filePath);

          await file.writeAsBytes(fileData);
          debugPrint('File saved at: ${file.path} with size: ${file.lengthSync()} bytes');

          if (await file.exists()) {
            return file;
          } else {
            debugPrint('File not found after saving');
            return null;
          }
        } else {
          debugPrint('Downloaded file is empty.');
          return null;
        }
      } else {
        // Log the status code and error message
        debugPrint('Failed to download file. Status code: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      debugPrint('Error while downloading file: $error');
      return null;
    }
  }


  @override
  Future patchResponse(
      {required dynamic id, dynamic data, String params = ''}) async {
    dynamic responseJson;
    headers[HttpHeaders.authorizationHeader] = await getToken();
    // headers[HttpHeaders.authorizationHeader] =
    //     'Bearer yINQ0FBZ_j35uR8OP1gUZ8P3BP6RNEuh';
    headers[HttpHeaders.contentTypeHeader] = 'application/json';
    String finalUrl = id != '' ? '$baseUrl$url/$id' : '$baseUrl$url';
    if (params != '') {
      finalUrl = '$finalUrl$params';
    }
    debugPrint('final ${finalUrl}');
    debugPrint('data ${data}');
    try {
      final response;

      response = await http.patch(Uri.parse(finalUrl),
          headers: headers, body: jsonEncode(data));
      debugPrint('response json ${response.body}');
      debugPrint('returnResponse ${returnResponse(response)}');

      responseJson = returnResponse(response);
    } on SocketException {
      throw FetchDataException('No Internet Connection');
    } catch (error) {
      rethrow;
    }
    return responseJson;
  }

  @override
  Future deleteResponse({params = ''}) async {
    // dynamic responseJson;
    String finalUrl = baseUrl + url;
    if (params != '') {
      finalUrl = '$finalUrl$params';
    }
    try {
      String tokenValue = await getToken();
      if (tokenValue != '') {
        headers[HttpHeaders.authorizationHeader] = tokenValue;
        // headers[HttpHeaders.authorizationHeader] =
        // 'Bearer yINQ0FBZ_j35uR8OP1gUZ8P3BP6RNEuh';
      }
      final response = await http.delete(Uri.parse(finalUrl), headers: headers);
      return response.body;
    } catch (error) {
      rethrow;
    }
  }

  dynamic returnResponse(http.Response response) async {
    LoginViewModel loginViewModel = LoginViewModel();
    debugPrint('status code ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
        //
        dynamic responseJson = jsonDecode(response.body);
        debugPrint('respon j $responseJson');
        return responseJson;
        case 503:
        //
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
        case 505:
        //
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
        case 300:
        //
        dynamic responseJson = jsonDecode(response.body);
        return responseJson;
      case 400:
        throw BadRequestException(response.toString());
      case 401:
        if (await getToken() != '') {
          loginViewModel.loginSharedPreference();
        } else {
          AppPreferences().clear();
        }
        throw UnauthorisedException(
            jsonDecode(response.body)['errors'][0]['message']);
      case 403:
        NavigationService().navigateToScreen(const OnBoardingScreen());
        throw UnauthorisedException(
            jsonDecode(response.body)['errors'][0]['message']);
      case 404:
        throw UnauthorisedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException(
            'Error occured while communication with server with status code : ${response.statusCode} ${response.body}');
    }
  }

  Future<String> getToken() async {
    try {
      String? token =
          await AppPreferences().get(key: userTokenKey, isModel: false);
      if ((headers[HttpHeaders.authorizationHeader] == null ||
              headers[HttpHeaders.authorizationHeader] != token) &&
          token != null &&
          token != '') {
        debugPrint('token is $token');

        return "Bearer $token";
      }
      return '';
    } catch (err) {
      return '';
    }
  }
}
