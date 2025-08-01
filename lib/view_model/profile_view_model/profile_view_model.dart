import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/models/profile_model.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/repository/profile/profile_repository.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/view_model/dispose_view_model/dispose_view_model.dart';
import 'package:flutter/foundation.dart';

import '../../res/app_validation.dart';
import '../../res/constants.dart';
import '../../res/strings/english_strings.dart';

class ProfileViewModel extends DisposableViewModel {
  ProfileRepository _homeRepository = ProfileRepository();
  ApiResponse<ProfileModel> _apiProfileResponse = ApiResponse.loading();
  ApiResponse<UserModel> _apiUserResponse = ApiResponse.loading();
  Map<String, dynamic> profileBody = {};
  Map<String?, String?> verifyPassword = {};
  List<dynamic>? _selectedServices = List.empty();
  String? lang;

  Map<String?, String?> profileErrors = {};

  Future<void> readJson() async {
    await getProfiledata();
    await getLanguage();
    // await apigetNotifications();
    notifyListeners();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    if (lang == null) {
      lang = 'en-US';
    }
  }

  get errorMsg => null;

  Future<dynamic> getProfiledata() async {
    //Todo sign up save user
    try {
      ProfileModel? response = await _homeRepository.getProfileBody();
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};
      // debugPrint('PROFILEREE ${profileBody}');

      notifyListeners();
      return profileBody;
    } catch (error) {
      debugPrint('error getting profile $error');
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }


  Future<void> patchProfileState(dynamic state) async {
    try {
      ProfileModel? response = await _homeRepository
          .patchProfileState(id: profileBody["id"], body: {"state": state});
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      // profileBody = _apiProfileResponse.data?.toJson() ?? {};
      await getProfiledata();
      notifyListeners();
    } catch (error) {
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }
  Future<dynamic> deleteProfile() async {
    try {
      dynamic response = await _homeRepository
          .deleteProfile();
      debugPrint('response deleting profile $response');
    return response;
    } catch (error) {
      debugPrint('error deleting profile $error');
      return {'status':'not_ok'};

    }
  }

  Future<bool>? patchProfileServices() async {
    try {
      debugPrint('patching Selected services $_selectedServices');
      if(_selectedServices!.isNotEmpty){
        dynamic response = await _homeRepository.patchProfileServices(
          profileBody["id"],
          {
            "supplier_services": _selectedServices?.map((serviceId) {
              return {"services_id": serviceId};
            }).toList(),
          },
        );
        debugPrint('response ${response}');
        // profileBody=response;
        notifyListeners();

        return true;
      }else{
        return false;

      }

    } catch (error) {
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> setSelectedServices(dynamic services) async {
    try {
      _selectedServices = services;
      notifyListeners();
    } catch (error) {
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }

  Future<void> changeCurrentLocation(
      dynamic latitude, dynamic longitude) async {
    try {
      debugPrint('Changing current location');
      dynamic response = await _homeRepository.changeCurrentLocation(
          // id: profileBody["id"],
          body: {
            "latitude": latitude,
            "longitude": longitude,
          });
      // _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      // profileBody = _apiProfileResponse.data?.toJson() ?? {};
      debugPrint('response view model change location $response');
      notifyListeners();
    } catch (error) {
      debugPrint('error while changing locationn $error');
      // _apiProfileResponse = ApiResponse<ProfileModel>.error(error.toString());
      notifyListeners();
    }
  }

  Future<bool?> patchProfileData(dynamic body) async {
    try {
      final String userId = await getUserId();
      final role = await AppPreferences().get(key: userRoleKey, isModel: false);
      // make a mutable copy of your existing addresses
      final List<Map<String, dynamic>> existingAddresses =
      List<Map<String, dynamic>>.from(profileBody["address"] as List);

      debugPrint('body in patch profile data: $body');
      final addressId = body['id'];

      final Map<String, dynamic> addressMap = {
        if (addressId != null) 'id': addressId,
        "street_name": body["address"],
        "street_number": body["street_number"],
        "building_number": body["building_number"],
        "city": body["city"],
        "floor": body["floor"],
        "apartment_number": body["apartment_number"],
        "state": body["state"],
        "zone": body["zone"],
        "longitude": body["longitude"],
        "latitude": body["latitude"],
        "address_label": body["address_label"],
        "country": body["country"].toString(),
      };
      debugPrint('constructed addressMap: $addressMap');

      Map<String, dynamic> updatedCurrent;

      final bool isSupplier = role== Constants.supplierRoleId;

      if (isSupplier) {
        // Supplier: always replace the address list with the new address
        if (existingAddresses.isNotEmpty) {
          addressMap['id'] = existingAddresses.first['id']; // preserve the first id
        }
        updatedCurrent = addressMap;
        existingAddresses
          ..clear()
          ..add(addressMap);
        debugPrint('Supplier role: replaced address list with new address');
      } else {
        // Non-supplier logic: update existing or add new
        if (addressId != null) {
          final idx = existingAddresses.indexWhere((a) => a['id'] == addressId);
          if (idx != -1) {
            existingAddresses[idx] = {
              ...existingAddresses[idx],
              ...addressMap,
            };
            updatedCurrent = existingAddresses[idx];
            debugPrint('updated address at index $idx');
          } else {
            existingAddresses.add(addressMap);
            updatedCurrent = addressMap;
            debugPrint('id not found, added as new');
          }
        } else {
          existingAddresses.add(addressMap);
          updatedCurrent = addressMap;
          debugPrint('added new address');
        }
      }

      final ProfileModel? response = await _homeRepository.patchProfile(
        id: profileBody["id"],
        body: {
          "user": userId,
          "address": existingAddresses,
          "current_address": updatedCurrent,
        },
      );
      debugPrint('patch response: $response');

      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
      return true;
    } catch (error) {
      debugPrint('error in patching profile data: $error');
      notifyListeners();
      return false;
    }
  }


  void deleteAddress(int index) async {
    List<Map<String, dynamic>> updatedAddresses =
        List.from(profileBody['address']);
    updatedAddresses.removeAt(index);

    try {
      String userId = await getUserId();
      ProfileModel? response = await _homeRepository.patchProfile(
        id: profileBody["id"],
        body: {
          "user": userId,
          "address": updatedAddresses,
          "current_address":
              updatedAddresses.isNotEmpty ? updatedAddresses.first : null,
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
      debugPrint('current address data $body');
      ProfileModel? response = await _homeRepository.patchProfile(
          id: profileBody["id"],
          body: {"user": userId, "current_address": body});
      debugPrint('adding new address ${response}');
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      profileBody = _apiProfileResponse.data?.toJson() ?? {};

      notifyListeners();
    } catch (error) {
      debugPrint('error in patching current address data  $error');
      notifyListeners();
    }
  }

  Future<void> deleteNotificationById(dynamic id) async {
    try {
      ProfileModel? response = await _homeRepository.deleteNotificationById(
          id:id,
         );
      debugPrint('deletingNotification ${response}');

      notifyListeners();
    } catch (error) {
      debugPrint('error in deletingNotification current address data  $error');
      notifyListeners();
    }
  }
  Future<void> clearAllNotifications() async {
    try {
      ProfileModel? response = await _homeRepository.deleteNotifications();
      debugPrint('deletingNotifications ${response}');

      notifyListeners();
    } catch (error) {
      debugPrint('error in deletingNotifications current address data  $error');
      notifyListeners();
    }
  }

  Future<bool?> patchUserData(dynamic body) async {
    try {
      String userId = await getUserId();
      // Create a new address
      Map<String, dynamic> newUser = {
        "id": userId,
        "first_name": body["first_name"] != null
            ? body["first_name"]
            : profileBody["user"]["first_name"],
        "last_name": body["last_name"] != null
            ? body["last_name"]
            : profileBody["user"]["last_name"],
        "email": body["email"] != null
            ? body["email"]
            : profileBody["user"]["email"],
        "phone_number": body["phone_number"] != null
            ? body["phone_number"]
            : profileBody["user"]["phone_number"],
        "phone": body["phone"] != null
            ? body["phone"]
            : profileBody["user"]["phone"],
        "phone_code": body["phone_code"] != null
            ? body["phone_code"]
            : profileBody["user"]["phone_code"],
        "avatar": body["avatar"] != null
            ? body["avatar"]
            : profileBody["user"]["avatar"],
        "description": body["description"] != null
            ? body["description"]
            : profileBody["user"]["description"],
        // "status": body["status"] != null
        //     ? body["status"]
        //     : profileBody["user"]["status"],
        // "status":"Active"
      };

      // Add the new address to the existing list

      ProfileModel? response =
          await _homeRepository.patchProfile(id: profileBody["id"], body: {
        "user": newUser,
      });
      _apiProfileResponse = ApiResponse<ProfileModel>.completed(response);
      await getProfiledata();
      // profileBody = _apiProfileResponse.data?.toJson() ?? {};

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
      String userId = await AppPreferences()
          .get(key: userIdTochangePassword, isModel: false);
      // Create a new address
      Map<String, dynamic> newUser = {};

      // Add the new address to the existing list

      dynamic response = await _homeRepository.patchPassword(
          id: userId, body: {"status":"active","password": profileBody["new_password"]});
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

    newPasswordMessage =
        AppValidation().isValidPassword(profileBody['new_password'] ?? '');
    debugPrint('new password message ${newPasswordMessage}');
    debugPrint('profileBody new password ${profileBody['new_password']}');
    confirmNewPasswordMessage = AppValidation()
        .isValidPassword(profileBody['confirm_new_password'] ?? '');
    mustmatch = AppValidation().matchingPasswords(
        profileBody['new_password'] == profileBody['confirm_new_password']);
    if (newPasswordMessage == null &&
        confirmNewPasswordMessage == null &&
        mustmatch == null) {
      notifyListeners();
      return true;
    }
    verifyPassword['new_password'] = newPasswordMessage;
    verifyPassword['confirm_new_password'] = confirmNewPasswordMessage;
    verifyPassword['confirm_new_password'] = mustmatch;
    notifyListeners();
    return false;
  }
  void clear() {
    profileBody = {};

    notifyListeners();
  }

  void setInputValues({required String index, dynamic value}) {
    debugPrint('settin profile $index $value');
    profileBody[index] = value;

    notifyListeners();
  }

  Future<dynamic> getData() async {
    return profileBody;
  }

  bool validateData({required int index}) {
    // profileBody = {};
    String? firstnameMessage = '';
    String? lastnameMessage = '';
    String? streetMessage = '';
    String? buildingMessage = '';
    String? apartmentMessage = '';
    String? cityMessage = '';
    String? zoneMessage = '';
    String? addressLabelMessage = '';
    String? countryMessage = '';
    String? floorMessage = '';
    String? longitudeMessage = '';
    String? latitudeMessage = '';
    String? emailMessage = '';
    String? passwordMessage = '';
    String? phoneMessage = '';
    // String? dobMessage = '';

    String? role = profileBody['role'];
    debugPrint('profile body in validate $profileBody');

    if (index == 0) {
      firstnameMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['first_name']!] ?? '',
          index: 'First name');
      lastnameMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['last_name']!] ?? '',
          index: 'Last name');
      // dobMessage = AppValidation().isNotEmpty(
      //     value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
      //     index: 'Date of birth');

      if (firstnameMessage == null && lastnameMessage == null
          // && dobMessage == null
          ) {
        notifyListeners();
        return true;
      }
      profileBody[EnglishStrings().formKeys['first_name']!] = firstnameMessage;
      profileBody[EnglishStrings().formKeys['last_name']!] = lastnameMessage;
      // signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;

      notifyListeners();
      return false;
    }

    if (index == 1) {
      emailMessage = AppValidation()
          .isEmailValid(profileBody[EnglishStrings().formKeys['email']!] ?? '');
      phoneMessage = AppValidation().isValidPhoneNumber(
        profileBody[EnglishStrings().formKeys['phone_number']!] ?? '',
      );

      if (emailMessage == null && phoneMessage == null) {
        notifyListeners();
        return true;
      }
      profileErrors[EnglishStrings().formKeys['email']!] = emailMessage;
      profileErrors[EnglishStrings().formKeys['phone_number']!] = phoneMessage;
      notifyListeners();
      return false;
    }

    // if (index == 2) {
    //   passwordMessage = AppValidation().isValidPassword(
    //       profileBody[EnglishStrings().formKeys['password']!] ?? '');
    //   if (passwordMessage == null) {
    //     notifyListeners();
    //     return true;
    //   }
    //   profileErrors[EnglishStrings().formKeys['password']!] =
    //       passwordMessage;
    //   notifyListeners();
    //   return false;
    //
    // }

    if (index == 2) {
      streetMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['street_number']!] ?? '',
          index: 'Street Number');
      buildingMessage = AppValidation().isNotEmpty(
          value:
              profileBody[EnglishStrings().formKeys['building_number']!] ?? '',
          index: 'Building Number');
      apartmentMessage = AppValidation().isNotEmpty(
          value:
              profileBody[EnglishStrings().formKeys['apartment_number']!] ?? '',
          index: 'Apartment Number');
      cityMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['city']!] ?? '',
          index: 'City');
      zoneMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['zone']!] ?? '',
          index: 'Zone');
      addressLabelMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['address_label']!] ?? '',
          index: 'Address Label');
      countryMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['country']!] ?? '',
          index: 'Country');
      floorMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['floor']!] ?? '',
          index: 'Floor');
      longitudeMessage = AppValidation().isNotEmpty(
          value: profileBody['longitude'] ?? '', index: 'Longitude');
      latitudeMessage = AppValidation()
          .isNotEmpty(value: profileBody['latitude'] ?? '', index: 'Latitude');
      if (streetMessage == null &&
          buildingMessage == null &&
          apartmentMessage == null &&
          cityMessage == null &&
          zoneMessage == null &&
          addressLabelMessage == null &&
          countryMessage == null &&
          floorMessage == null &&
          latitudeMessage == null &&
          longitudeMessage == null) {
        notifyListeners();
        return true;
      }

      profileErrors[EnglishStrings().formKeys['street_number']!] =
          streetMessage;
      profileErrors[EnglishStrings().formKeys['building_number']!] =
          buildingMessage;
      profileErrors[EnglishStrings().formKeys['apartment_number']!] =
          apartmentMessage;
      profileErrors[EnglishStrings().formKeys['city']!] = cityMessage;
      profileErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
      profileErrors[EnglishStrings().formKeys['address_label']!] =
          addressLabelMessage;
      profileErrors[EnglishStrings().formKeys['country']!] = countryMessage;
      profileErrors[EnglishStrings().formKeys['floor']!] = floorMessage;
      profileErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
      profileErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
      notifyListeners();
      return false;
    }

    if (index == 3) {
      firstnameMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['first_name']!] ?? '',
          index: 'First name');
      lastnameMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['last_name']!] ?? '',
          index: 'Last name');
      emailMessage = AppValidation()
          .isEmailValid(profileBody[EnglishStrings().formKeys['email']!] ?? '');
      phoneMessage = AppValidation().isValidPhoneNumber(
        profileBody[EnglishStrings().formKeys['phone_number']!] ?? '',
      );
      // dobMessage = AppValidation().isNotEmpty(
      //     value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
      //     index: 'Date of birth');
      passwordMessage = AppValidation().isValidPassword(
          profileBody[EnglishStrings().formKeys['password']!] ?? '');
      streetMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['street_number']!] ?? '',
          index: 'Street Number');
      buildingMessage = AppValidation().isNotEmpty(
          value:
              profileBody[EnglishStrings().formKeys['building_number']!] ?? '',
          index: 'Building Number');
      apartmentMessage = AppValidation().isNotEmpty(
          value:
              profileBody[EnglishStrings().formKeys['apartment_number']!] ?? '',
          index: 'Apartment Number');
      cityMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['city']!] ?? '',
          index: 'City');
      zoneMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['zone']!] ?? '',
          index: 'Zone');
      addressLabelMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['address_label']!] ?? '',
          index: 'Address Label');
      countryMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['country']!] ?? '',
          index: 'Country');
      floorMessage = AppValidation().isNotEmpty(
          value: profileBody[EnglishStrings().formKeys['floor']!] ?? '',
          index: 'Floor');
      longitudeMessage = AppValidation().isNotEmpty(
          value: profileBody['longitude'] ?? '', index: 'Longitude');
      latitudeMessage = AppValidation()
          .isNotEmpty(value: profileBody['latitude'] ?? '', index: 'Latitude');
      if (firstnameMessage == null &&
          lastnameMessage == null &&
          emailMessage == null &&
          phoneMessage == null &&
          // passwordMessage == null &&
          // dobMessage == null &&
          streetMessage == null &&
          buildingMessage == null &&
          apartmentMessage == null &&
          cityMessage == null &&
          floorMessage == null &&
          countryMessage == null &&
          zoneMessage == null &&
          addressLabelMessage == null &&
          latitudeMessage == null &&
          longitudeMessage == null) {
        notifyListeners();
        return true;
      }
      profileErrors[EnglishStrings().formKeys['first_name']!] =
          firstnameMessage;
      profileErrors[EnglishStrings().formKeys['last_name']!] = lastnameMessage;
      profileErrors[EnglishStrings().formKeys['email']!] = emailMessage;
      profileErrors[EnglishStrings().formKeys['phone_number']!] = phoneMessage;
      profileErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
      // signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;
      profileErrors[EnglishStrings().formKeys['street_number']!] =
          streetMessage;
      profileErrors[EnglishStrings().formKeys['building_number']!] =
          buildingMessage;
      profileErrors[EnglishStrings().formKeys['apartment_number']!] =
          apartmentMessage;
      profileErrors[EnglishStrings().formKeys['city']!] = cityMessage;
      profileErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
      profileErrors[EnglishStrings().formKeys['address_label']!] =
          addressLabelMessage;
      profileErrors[EnglishStrings().formKeys['country']!] = countryMessage;
      profileErrors[EnglishStrings().formKeys['floor']!] = floorMessage;
      profileErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
      profileErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
      notifyListeners();
      return false;
    }

    notifyListeners();
    return false;
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
  get selectedServices => _selectedServices;

  @override
  void disposeValues() {
    _homeRepository = ProfileRepository();
  }
}
