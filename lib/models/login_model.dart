import 'dart:convert';

LoginModel loginModelMainFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelMainToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({this.accessToken, this.refreshToken, this.expires});

  String? accessToken;
  String? refreshToken;
  int? expires;

  @override
  String toString() {
    return '{$accessToken, $refreshToken}';
  }

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
        expires: json["expires"],
      );

  Map<String, dynamic> toJson() => {
        "accessToken": accessToken,
        "refreshToken": refreshToken,
        "expires": expires
      };
}
