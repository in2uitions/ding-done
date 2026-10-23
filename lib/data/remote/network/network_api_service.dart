import 'dart:convert';
import 'dart:io';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dingdone/data/remote/app_exception.dart';
import 'package:dingdone/data/remote/network/base_api_service.dart';
import 'package:dingdone/res/app_prefs.dart';
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

  Future<void> _applyAuthHeader({bool sendToken = true}) async {
    if (!sendToken) {
      headers.remove(HttpHeaders.authorizationHeader);
      return;
    }
    final tokenValue = await getToken();
    if (tokenValue.isEmpty) {
      headers.remove(HttpHeaders.authorizationHeader);
    } else {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
      headers[HttpHeaders.authorizationHeader] = tokenValue;
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
      await _applyAuthHeader(sendToken: sendToken);

      debugPrint('final url $finalUrl');
      debugPrint('token value ${headers[HttpHeaders.authorizationHeader]}');
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
      await _applyAuthHeader(sendToken: sendToken);

      debugPrint('final url file $finalUrl');
      debugPrint('token value ${headers[HttpHeaders.authorizationHeader]}');
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
      String params = '',
      bool logBody = true}) async {
    dynamic responseJson;
    if (sendToken) {
      await _applyAuthHeader();
    } else {
      headers.remove(HttpHeaders.authorizationHeader);
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
    if (logBody) {
      debugPrint('data $data');
    } else if (data is Map) {
      debugPrint('data keys ${data.keys.toList()}');
    } else {
      debugPrint('data [not logged]');
    }
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

  dynamic _decodeBody(http.Response response) {
    if (response.body.isEmpty) return <String, dynamic>{};
    try {
      return jsonDecode(response.body);
    } catch (_) {
      return response.body;
    }
  }

  String _messageFromBody(dynamic decoded, http.Response response) {
    if (decoded is Map) {
      final errors = decoded['errors'];
      if (errors is List && errors.isNotEmpty) {
        final first = errors.first;
        if (first is Map && first['message'] != null) {
          return first['message'].toString();
        }
        return first.toString();
      }
      final message = decoded['message'] ??
          decoded['reason'] ??
          decoded['error'] ??
          decoded['detail'];
      if (message != null && message.toString().trim().isNotEmpty) {
        return message.toString();
      }
    }
    final body = response.body.trim();
    if (body.isNotEmpty && !body.toLowerCase().contains('instance of')) {
      return body;
    }
    return 'Request failed (${response.statusCode})';
  }

  dynamic returnResponse(http.Response response) async {
    LoginViewModel loginViewModel = LoginViewModel();
    debugPrint('status code ${response.statusCode}');
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
      case 300:
      case 503:
      case 505:
        final responseJson = _decodeBody(response);
        debugPrint('respon j $responseJson');
        return responseJson;
      case 400:
      case 422:
      case 502:
        final decoded = _decodeBody(response);
        if (decoded is Map) return decoded;
        throw BadRequestException(_messageFromBody(decoded, response));
      case 401:
        if (await getToken() != '') {
          loginViewModel.loginSharedPreference();
        }
        throw UnauthorisedException(
            _messageFromBody(_decodeBody(response), response));
      case 403:
        throw UnauthorisedException(
            _messageFromBody(_decodeBody(response), response));
      case 404:
        throw UnauthorisedException(
            _messageFromBody(_decodeBody(response), response));
      case 500:
      default:
        throw FetchDataException(
            _messageFromBody(_decodeBody(response), response));
    }
  }

  Future<String> getToken() async {
    try {
      final token =
          await AppPreferences().get(key: userTokenKey, isModel: false);
      if (token == null || token.toString().trim().isEmpty) {
        return '';
      }
      final raw = token.toString().trim();
      if (raw.startsWith('Bearer ')) {
        return raw;
      }
      return 'Bearer $raw';
    } catch (err) {
      return '';
    }
  }
}
