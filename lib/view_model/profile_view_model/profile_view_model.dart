
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/models/profile_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/repository/profile/profile_repository.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/view_model/dispose_view_model/dispose_view_model.dart';
import 'package:flutter/foundation.dart';

import '../../res/app_validation.dart';
import '../../res/strings/english_strings.dart';


class ProfileViewModel extends DisposableViewModel {
  ProfileRepository _homeRepository = ProfileRepository();
  ApiResponse<ProfileModel> _apiProfileResponse = ApiResponse.loading();
  ApiResponse<UserModel> _apiUserResponse = ApiResponse.loading();
  Map<String, dynamic> profileBody = {};
  Map<String?, String?> verifyPassword = {};

  Future<void> readJson() async {

    await getProfiledata();
    notifyListeners();
  }

  get errorMsg => null;



  Future<dynamic> getProfiledata() async {
    //Todo sign up save user
    try {
      ProfileModel? response = await _homeRepository.getProfileBody();
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};
      debugPrint('PROFILEREE ${profileBody}');

      notifyListeners();
      return profileBody;
    } catch (error) {
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }


  Future<void> patchProfileState(dynamic state) async {
    try {
      ProfileModel? response = await _homeRepository.patchProfileState(
          id: profileBody["id"],
          body: {
            "state" :state
      });
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
    } catch (error) {
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }

  Future<void> patchProfileData(dynamic body) async {
    try {
      String userId = await getUserId();
      List<Map<String, dynamic>> existingAddresses = List.from(profileBody["address"]);
      // Create a new address
      Map<String, dynamic> newAddress = {
        "street_name": body["street_name"],
        "building_number": body["street_name"],
        "city": body["city"],
        "state": body["state"],
        "postal_code": body["postal_code"],
        "longitude": body["longitude"],
        "latitude": body["latitude"],
        // "country": body["country"].toString(),
      };
      debugPrint('adding new address $newAddress');

      // Add the new address to the existing list
      existingAddresses.add(newAddress);

      ProfileModel? response = await _homeRepository.patchProfile(
          id: profileBody["id"],
          body: {
            "user": userId,
            "address" :existingAddresses,
            "current_address":newAddress
      });
      debugPrint('adding new address ${response}');
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
    } catch (error) {
      debugPrint('error in patching profile data  $error');
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }

  void deleteAddress(int index) async {
    List<Map<String, dynamic>> updatedAddresses = List.from(profileBody['address']);
    updatedAddresses.removeAt(index);

    try {
      String userId = await getUserId();
      ProfileModel? response = await _homeRepository.patchProfile(
        id: profileBody["id"],
        body: {
          "user": userId,
          "address": updatedAddresses,
          "current_address": updatedAddresses.isNotEmpty ? updatedAddresses.first : null,
        },
      );
      // Update the local address list
      profileBody['address'] = updatedAddresses;
      notifyListeners();
    } catch (error) {
      debugPrint('Error deleting address: $error');
    }
  }

 Future<void> setCurrentAddress(dynamic body) async {
    try {
      String userId = await getUserId();

      ProfileModel? response = await _homeRepository.patchProfile(
          id: profileBody["id"],
          body: {
            "user": userId,
            "current_address":body
      });
      debugPrint('adding new address ${response}');
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
    } catch (error) {
      debugPrint('error in patching current address data  $error');
      notifyListeners();
    }
  }

 Future<bool?> patchUserData(dynamic body) async {
    try {

      String userId = await getUserId();
      // Create a new address
      Map<String, dynamic> newUser = {
        "id":userId,
        "first_name": body["first_name"]!=null?body["first_name"]:profileBody["user"]["first_name"],
        "last_name": body["last_name"]!=null?body["last_name"]:profileBody["user"]["last_name"],
        "email": body["email"]!=null?body["email"]:profileBody["user"]["email"],
        "phone_number": body["phone_number"]!=null?body["phone_number"]:profileBody["user"]["phone_number"],
        "avatar": body["avatar"]!=null?body["avatar"]:profileBody["user"]["avatar"],
        "description": body["description"]!=null?body["description"]:profileBody["user"]["description"],
      };

      // Add the new address to the existing list

      ProfileModel? response = await _homeRepository.patchProfile(
          id: profileBody["id"],
          body: {
            "user": newUser,

      });
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('error is $error');
      notifyListeners();
      return false;
    }
  }
 Future<bool?> patchPassword() async {
    try {

      String userId = await AppPreferences().get(key: userIdTochangePassword, isModel: false);
      // Create a new address
      Map<String, dynamic> newUser = {


      };

      // Add the new address to the existing list

      dynamic response = await _homeRepository.patchPassword(
          id: userId,
          body: {
            "password":profileBody["new_password"]

      });
      debugPrint('response $response');
      // _apiUserResponse = ApiResponse<UserModel>.completed(response);

      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('error is $error');
      notifyListeners();
      return false;
    }
  }
  bool validate() {
    verifyPassword = {};
    String? newPasswordMessage = '';
    String? confirmNewPasswordMessage = '';
    String? mustmatch = '';

        newPasswordMessage = AppValidation().isValidPassword(
            profileBody['new_password'] ?? '');
        debugPrint('new password message ${newPasswordMessage}');
        debugPrint('profileBody new password ${profileBody['new_password']}');
    confirmNewPasswordMessage = AppValidation().isValidPassword(
        profileBody['confirm_new_password'] ?? '');
    mustmatch=AppValidation().matchingPasswords(profileBody['new_password']==profileBody['confirm_new_password']);
        if (newPasswordMessage == null && confirmNewPasswordMessage==null && mustmatch==null) {
          notifyListeners();
          return true;
        }
    verifyPassword['new_password'] = newPasswordMessage;
    verifyPassword['confirm_new_password'] = confirmNewPasswordMessage;
    verifyPassword['confirm_new_password']=mustmatch;
    notifyListeners();
    return false;



  }

  void setInputValues({required String index, dynamic value}) {
    debugPrint('settin profile $index $value');
    profileBody[index] = value;

    notifyListeners();
  }
  Future<dynamic> getData() async{
    return profileBody;
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

  get getProfileBody => profileBody;

  @override
  void disposeValues() {
    _homeRepository = ProfileRepository();

  }
}