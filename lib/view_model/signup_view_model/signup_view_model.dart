import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/repository/signup/signup_repo.dart';
import 'package:dingdone/res/constants.dart';
import 'package:flutter/foundation.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/models/user_model.dart';
import 'package:dingdone/res/app_validation.dart';
import 'package:dingdone/res/strings/english_strings.dart';

class SignUpViewModel with ChangeNotifier {
  final SignUpRepository _signUpRepository = SignUpRepository();

  // final ProfileRepository _homeRepository = ProfileRepository();
  ApiResponse<DropDownModelMain> _apiRoleResponse = ApiResponse.loading();
  ApiResponse<UserModel> _apiRegisterResponse = ApiResponse.loading();

  // ApiResponse<ResultConfirmEmail> _apiConfirmResponse = ApiResponse.loading();
  List<DropdownRoleModel>? _listRole = List.empty();
  List<dynamic>? _listCountries = List.empty();
  Map<String?, String?> signUpErrors = {};

  // Map<String, dynamic> signUpBody = {"status": 'draft'};
  Map<String, dynamic> signUpBody = {"status": 'active'};
  List<dynamic> signUpBodyValidation = List.empty();

  // Map<String, dynamic> dropdownValues = {};
  bool _isDataWritten = false;

  String _userRole = '';

  SignUpViewModel() {
    roles();
    countries();
  }

  void start() {}

  Future<bool> signup() async {
    //Todo sign up save user
    try {
      UserModel? response =
          await _signUpRepository.postUserCredentials(signUpBody);
      _apiRegisterResponse = ApiResponse<UserModel>.completed(response);
      // ResultConfirmEmail? res = await _signUpRepository.postEmailConfimation({
      //   'email': signUpBody['email'],
      // });
      // _apiConfirmResponse = ApiResponse<ResultConfirmEmail>.completed(res);
      // await createCometChat(
      //     fullName:
      //         '${_apiRegisterResponse.data?.first_name} ${_apiRegisterResponse.data?.last_name}',
      //     userId: '${_apiRegisterResponse.data?.id}');
      // await saveProfileData();
      return true;
    } catch (error) {
      _apiRegisterResponse = ApiResponse<UserModel>.error(error.toString());
      return false;
    }
    // debugPrint('sign up body ${signUpBody}');
    // return false;
  }
  Future<void> setDataWriten(bool isWriten) async {
    _isDataWritten = isWriten;

    notifyListeners();
  }


  bool validate({required int index}) {
    signUpErrors = {};
    String? firstnameMessage = '';
    String? lastnameMessage = '';
    String? streetMessage = '';
    String? buildingMessage = '';
    String? apartmentMessage = '';
    String? cityMessage = '';
    String? zoneMessage = '';
    String? countryMessage = '';
    String? floorMessage = '';
    String? longitudeMessage = '';
    String? latitudeMessage = '';
    String? emailMessage = '';
    String? passwordMessage = '';
    String? phoneMessage = '';
    String? dobMessage = '';
    String? QIDMessage = '';
    String? paymentinfoMessage = '';
    String? categoriesMessage = '';
    String? idMessage = '';
    String? bankAccountMessage = '';

    String? role = signUpBody['role'];
    if (role == Constants.supplierRoleId) {
      debugPrint('role is supplier');
      if (index == 0) {
        firstnameMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['first_name']!] ?? '',
            index: 'First name');
        lastnameMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['last_name']!] ?? '',
            index: 'Last name');
        dobMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
            index: 'Date of birth');
        debugPrint('selected option is ${signUpBody['selectedOption']}');

        QIDMessage = signUpBody['selectedOption'] =='individual'?
        AppValidation().isNotEmpty(
            value: signUpBody['id_image'] ?? '',
            index: 'QID'):
        signUpBody['selectedOption'] =='company'?
        AppValidation().isNotEmpty(
            value: signUpBody['company'] ?? '',
            index: 'company'):'Please select a profile type';
        debugPrint('QIDMessage ${QIDMessage} ${signUpBody['selectedOption']}');
        if (firstnameMessage == null && lastnameMessage == null && dobMessage == null&& QIDMessage == null) {
          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['first_name']!] =
            firstnameMessage;
        signUpErrors[EnglishStrings().formKeys['last_name']!] = lastnameMessage;
        signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;
        signUpBody['selectedOption'] =='individual'?
        signUpErrors[EnglishStrings().formKeys['id_image']!] = QIDMessage:
        signUpErrors[EnglishStrings().formKeys['company']!] = QIDMessage;

        notifyListeners();
        return false;
      }

      if (index == 1) {
        phoneMessage = AppValidation().isValidPhoneNumber(
           signUpBody[EnglishStrings().formKeys['phone_number']!] ?? '',
           );


        emailMessage = AppValidation().isEmailValid(
            signUpBody[EnglishStrings().formKeys['email']!] ?? '');
        if (emailMessage == null && phoneMessage==null) {
          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['email']!] = emailMessage;
        signUpErrors[EnglishStrings().formKeys['phone_number']!] = phoneMessage;

        notifyListeners();
        return false;
      }

      if (index == 2) {
        passwordMessage = AppValidation().isValidPassword(
            signUpBody[EnglishStrings().formKeys['password']!] ?? '');
        if (passwordMessage == null) {
          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
        notifyListeners();
        return false;
      }

      if (index == 3) {
        streetMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['street_number']!] ?? '',
            index: 'Street Number');
        buildingMessage = AppValidation().isNotEmpty(
            value:
            signUpBody[EnglishStrings().formKeys['building_number']!] ?? '',
            index: 'Building Number');
        apartmentMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['apartment_number']!] ??
                '',
            index: 'Apartment Number');
        cityMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['city']!] ?? '',
            index: 'City');
        zoneMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['zone']!] ?? '',
            index: 'Zone');
        countryMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['country']!] ?? '',
            index: 'Country');
        floorMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['floor']!] ?? '',
            index: 'Floor');
        longitudeMessage = AppValidation().isNotEmpty(
            value: signUpBody['longitude'] ?? '',
            index: 'Longitude');
        latitudeMessage = AppValidation().isNotEmpty(
            value: signUpBody['latitude'] ?? '',
            index: 'Latitude');
        if (streetMessage == null &&
            buildingMessage == null &&
            apartmentMessage == null &&
            cityMessage == null &&
            zoneMessage == null &&
            countryMessage == null &&
            floorMessage == null && signUpBody['longitude']!=null &&signUpBody['latitude']!=null) {
          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['street_number']!] = streetMessage;
        signUpErrors[EnglishStrings().formKeys['building_number']!] =
            buildingMessage;
        signUpErrors[EnglishStrings().formKeys['apartment_number']!] =
            apartmentMessage;
        signUpErrors[EnglishStrings().formKeys['city']!] = cityMessage;
        signUpErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
        signUpErrors[EnglishStrings().formKeys['country']!] = countryMessage;
        signUpErrors[EnglishStrings().formKeys['floor']!] = floorMessage;
        signUpErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
        signUpErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
        notifyListeners();
        return false;

      }

      if (index == 4) {
        categoriesMessage = AppValidation().isNotListEmpty(
            value:
            signUpBody[EnglishStrings().formKeys['supplier_services']!] ??
                [],
            index: 'Categories');
        if (categoriesMessage == null) {
          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['supplier_services']!] =
            categoriesMessage;
        notifyListeners();
        return false;
      }

      if (index == 5) {
        debugPrint('index 5 avatar ${ signUpBody["avatar"]}');

        firstnameMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['first_name']!] ?? '',
            index: 'First name');
        lastnameMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['last_name']!] ?? '',
            index: 'Last name');
        emailMessage = AppValidation().isEmailValid(
            signUpBody[EnglishStrings().formKeys['email']!] ?? '');
        phoneMessage = AppValidation().isValidPhoneNumber(
             signUpBody[EnglishStrings().formKeys['phone_number']!] ?? '',
          );
        dobMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
            index: 'Date of birth');
        passwordMessage = AppValidation().isValidPassword(
            signUpBody[EnglishStrings().formKeys['password']!] ?? '');

        streetMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['street_number']!] ?? '',
            index: 'Street Number');
        buildingMessage = AppValidation().isNotEmpty(
            value:
            signUpBody[EnglishStrings().formKeys['building_number']!] ?? '',
            index: 'Building Number');
        apartmentMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['apartment_number']!] ??
                '',
            index: 'Apartment Number');
        cityMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['city']!] ?? '',
            index: 'City');
        zoneMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['zone']!] ?? '',
            index: 'Zone');
        countryMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['country']!] ?? '',
            index: 'Country');
        floorMessage = AppValidation().isNotEmpty(
            value: signUpBody[EnglishStrings().formKeys['floor']!] ?? '',
            index: 'Floor');

        longitudeMessage = AppValidation().isNotEmpty(
            value: signUpBody['longitude'] ?? '',
            index: 'Longitude');
        latitudeMessage = AppValidation().isNotEmpty(
            value: signUpBody['latitude'] ?? '',
            index: 'Latitude');
        QIDMessage = signUpBody['selectedOption'] =='individual'?
        AppValidation().isNotEmpty(
            value: signUpBody['id_image'] ?? '',
            index: 'QID'):
        signUpBody['selectedOption'] =='company'?
        AppValidation().isNotEmpty(
            value: signUpBody['company'] ?? '',
            index: 'company'):'Please select a profile type';
        debugPrint('signupbody avatar ${ signUpBody["avatar"]}');
        if (
            firstnameMessage == null &&
            lastnameMessage == null &&
            emailMessage == null &&
            phoneMessage == null &&
            passwordMessage == null &&
            dobMessage == null &&
            streetMessage == null &&
            buildingMessage == null &&
            apartmentMessage == null &&
            cityMessage == null &&
            zoneMessage == null &&
                countryMessage == null &&
            floorMessage == null &&
            QIDMessage == null &&
            signUpBody["avatar"]!=null&&
             signUpBody['longitude']!=null && signUpBody['latitude']!=null) {

          notifyListeners();
          return true;
        }
        signUpErrors[EnglishStrings().formKeys['first_name']!] =
            firstnameMessage;
        signUpErrors[EnglishStrings().formKeys['last_name']!] = lastnameMessage;
        signUpErrors[EnglishStrings().formKeys['email']!] = emailMessage;
        signUpErrors[EnglishStrings().formKeys['phone_number']!] = phoneMessage;
        signUpErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
        signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;
        signUpErrors[EnglishStrings().formKeys['supplier_services']!] =
            categoriesMessage;
        signUpErrors[EnglishStrings().formKeys['street_number']!] = streetMessage;
        signUpErrors[EnglishStrings().formKeys['building_number']!] =
            buildingMessage;
        signUpErrors[EnglishStrings().formKeys['apartment_number']!] =
            apartmentMessage;
        signUpErrors[EnglishStrings().formKeys['city']!] = cityMessage;
        signUpErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
        signUpErrors[EnglishStrings().formKeys['country']!] = countryMessage;
        signUpErrors[EnglishStrings().formKeys['floor']!] = floorMessage;
        signUpErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
        signUpErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
        signUpBody['selectedOption'] =='individual'?
        signUpErrors[EnglishStrings().formKeys['id_image']!] = QIDMessage:
        signUpErrors[EnglishStrings().formKeys['company']!] = QIDMessage;

        notifyListeners();
        return false;
     
      }


    } else {
      if (role == Constants.customerRoleId) {
        if (index == 0) {
          firstnameMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['first_name']!] ?? '',
              index: 'First name');
          lastnameMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['last_name']!] ?? '',
              index: 'Last name');
          dobMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
              index: 'Date of birth');

          if (firstnameMessage == null && lastnameMessage == null && dobMessage == null) {
            notifyListeners();
            return true;
          }
          signUpErrors[EnglishStrings().formKeys['first_name']!] =
              firstnameMessage;
          signUpErrors[EnglishStrings().formKeys['last_name']!] =
              lastnameMessage;
          signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;

          notifyListeners();
          return false;
        }

        if (index == 1) {
          emailMessage = AppValidation().isEmailValid(
              signUpBody[EnglishStrings().formKeys['email']!] ?? '');
          phoneMessage = AppValidation().isValidPhoneNumber(

              signUpBody[EnglishStrings().formKeys['phone_number']!] ?? '',
          );

          if (emailMessage == null && phoneMessage == null) {
            notifyListeners();
            return true;
          }
          signUpErrors[EnglishStrings().formKeys['email']!] = emailMessage;
          signUpErrors[EnglishStrings().formKeys['phone_number']!] =
              phoneMessage;
          notifyListeners();
          return false;
        }

        if (index == 2) {
          passwordMessage = AppValidation().isValidPassword(
              signUpBody[EnglishStrings().formKeys['password']!] ?? '');
          if (passwordMessage == null) {
            notifyListeners();
            return true;
          }
          signUpErrors[EnglishStrings().formKeys['password']!] =
              passwordMessage;
          notifyListeners();
          return false;

        }

        if (index == 3) {
          streetMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['street_number']!] ?? '',
              index: 'Street Number');
          buildingMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['building_number']!] ??
                  '',
              index: 'Building Number');
          apartmentMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['apartment_number']!] ??
                  '',
              index: 'Apartment Number');
          cityMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['city']!] ?? '',
              index: 'City');
          zoneMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['zone']!] ?? '',
              index: 'Zone');
          countryMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['country']!] ?? '',
              index: 'Country');
          floorMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['floor']!] ?? '',
              index: 'Floor');
          longitudeMessage = AppValidation().isNotEmpty(
              value: signUpBody['longitude'] ?? '',
              index: 'Longitude');
          latitudeMessage = AppValidation().isNotEmpty(
              value: signUpBody['latitude'] ?? '',
              index: 'Latitude');
          if (
              streetMessage == null &&
              buildingMessage == null &&
              apartmentMessage == null &&
              cityMessage == null &&
              zoneMessage == null &&
              countryMessage == null &&
              floorMessage == null && latitudeMessage==null && longitudeMessage==null) {
            notifyListeners();
            return true;
          }

          signUpErrors[EnglishStrings().formKeys['street_number']!] =
              streetMessage;
          signUpErrors[EnglishStrings().formKeys['building_number']!] =
              buildingMessage;
          signUpErrors[EnglishStrings().formKeys['apartment_number']!] =
              apartmentMessage;
          signUpErrors[EnglishStrings().formKeys['city']!] = cityMessage;
          signUpErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
          signUpErrors[EnglishStrings().formKeys['country']!] = countryMessage;
          signUpErrors[EnglishStrings().formKeys['floor']!] =
              floorMessage;
          signUpErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
          signUpErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
          notifyListeners();
          return false;
        }

        if (index == 4) {
          firstnameMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['first_name']!] ?? '',
              index: 'First name');
          lastnameMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['last_name']!] ?? '',
              index: 'Last name');
          emailMessage = AppValidation().isEmailValid(
              signUpBody[EnglishStrings().formKeys['email']!] ?? '');
          phoneMessage = AppValidation().isValidPhoneNumber(
              signUpBody[EnglishStrings().formKeys['phone_number']!] ?? '',
            );
          dobMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['dob']!] ?? '',
              index: 'Date of birth');
          passwordMessage = AppValidation().isValidPassword(
              signUpBody[EnglishStrings().formKeys['password']!] ?? '');
          streetMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['street_number']!] ?? '',
              index: 'Street Number');
          buildingMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['building_number']!] ??
                  '',
              index: 'Building Number');
          apartmentMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['apartment_number']!] ??
                  '',
              index: 'Apartment Number');
          cityMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['city']!] ?? '',
              index: 'City');
          zoneMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['zone']!] ?? '',
              index: 'Zone');
          countryMessage = AppValidation().isNotEmpty(
              value: signUpBody[EnglishStrings().formKeys['country']!] ?? '',
              index: 'Country');
          floorMessage = AppValidation().isNotEmpty(
              value:
              signUpBody[EnglishStrings().formKeys['floor']!] ?? '',
              index: 'Floor');
          longitudeMessage = AppValidation().isNotEmpty(
              value: signUpBody['longitude'] ?? '',
              index: 'Longitude');
          latitudeMessage = AppValidation().isNotEmpty(
              value: signUpBody['latitude'] ?? '',
              index: 'Latitude');
          if (firstnameMessage == null &&
              lastnameMessage == null &&
              emailMessage == null &&
              phoneMessage == null &&
              passwordMessage == null &&
              dobMessage == null &&
              streetMessage == null &&
              buildingMessage == null &&
              apartmentMessage == null &&
              cityMessage == null &&
              floorMessage == null &&
              countryMessage == null &&
              zoneMessage == null  && latitudeMessage==null && longitudeMessage==null) {
            notifyListeners();
            return true;
          }
          signUpErrors[EnglishStrings().formKeys['first_name']!] =
              firstnameMessage;
          signUpErrors[EnglishStrings().formKeys['last_name']!] = lastnameMessage;
          signUpErrors[EnglishStrings().formKeys['email']!] = emailMessage;
          signUpErrors[EnglishStrings().formKeys['phone_number']!] = phoneMessage;
          signUpErrors[EnglishStrings().formKeys['password']!] = passwordMessage;
          signUpErrors[EnglishStrings().formKeys['dob']!] = dobMessage;
          signUpErrors[EnglishStrings().formKeys['street_number']!] =
              streetMessage;
          signUpErrors[EnglishStrings().formKeys['building_number']!] =
              buildingMessage;
          signUpErrors[EnglishStrings().formKeys['apartment_number']!] =
              apartmentMessage;
          signUpErrors[EnglishStrings().formKeys['city']!] = cityMessage;
          signUpErrors[EnglishStrings().formKeys['zone']!] = zoneMessage;
          signUpErrors[EnglishStrings().formKeys['country']!] =
              countryMessage;
          signUpErrors[EnglishStrings().formKeys['floor']!] =
              floorMessage;
          signUpErrors[EnglishStrings().formKeys['longitude']!] = longitudeMessage;
          signUpErrors[EnglishStrings().formKeys['latitude']!] = latitudeMessage;
          notifyListeners();
          return false;

        }


      }
    }

    notifyListeners();
    return false;
  }

  void setInputValues({required String index,required dynamic value}) {
    signUpBody[index] = value;
    debugPrint('signup body $signUpBody');
    notifyListeners();
  }
  Future<dynamic> getData() async{
    return signUpBody;
  }

  void roles() async {
    try {
      dynamic response = await _signUpRepository.getRoles();
      _apiRoleResponse = ApiResponse.completed(response);
      _listRole = _apiRoleResponse.data?.dropDownList;
    } catch (error) {
      _apiRoleResponse = ApiResponse.error(error.toString());
    }
    notifyListeners();
  }
  Future<List<dynamic>?> countries() async {
    try {
      dynamic response = await _signUpRepository.getCountries();
      debugPrint('response getting countries $response');
      // _apiCountriesResponse = ApiResponse.completed(response);
      _listCountries = response['data'];
      return _listCountries;
    } catch (error) {
      debugPrint('error getting countries $error');
      // _apiRoleResponse = ApiResponse.error(error.toString());
    }
    notifyListeners();
  }
 
  // Future<void> getUserRoleFromId(String id) async {
  //   try {
  //     String? user_role = await _signUpRepository.getUserRoleFromId(id);
  //     _userRole = user_role ?? '';
  //     debugPrint('user role is ${_userRole}');
  //     notifyListeners();
  //   } catch (error) {
  //     _userRole = '';
  //     notifyListeners();
  //   }
  // }

  get userRole => _userRole;

  get getRoleList => _listRole;
  get getCountries => _listCountries;

  // get isEmailSent => _apiConfirmResponse.status == Status.COMPLETED;
  get getRoleApiResponse => _apiRoleResponse;

  get getSignUpBody => signUpBody;

  get isDataWritten => _isDataWritten;
}
