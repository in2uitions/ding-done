import 'package:dingdone/models/categories_model.dart';
import 'package:dingdone/models/country_rates_model.dart';
import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:dingdone/repository/categories/categories_repo.dart';
import 'package:dingdone/repository/services/services_repo.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';

class ServicesViewModel with ChangeNotifier {
  final ServicesRepository _servicesRepository = ServicesRepository();
  ApiResponse<ServicesModelMain> _servicesResponse = ApiResponse.loading();
  List<ServicesModel>? _servicesList = List.empty();
  List<ServicesModel>? _servicesList2 = List.empty();
  List<CountryRatesModel>? _countryRatesList = List.empty();
  List<dynamic>? _servicesCategoryList = List.empty();
  List<dynamic>? _allServices = List.empty();
  ApiResponse<ServicesModelMain> _apiServicesResponse = ApiResponse.loading();
  ApiResponse<CountryRatesModelMain> _apiCountyRatesResponse =
      ApiResponse.loading();
  Map<String, dynamic> searchBody = {};
  CategoriesViewModel categoriesViewModel = CategoriesViewModel();

  ApiResponse<dynamic> _apiServicesCategoryResponse = ApiResponse.loading();
  List<List<dynamic>> listOfLists = [];
  List<List<bool>> _checkboxValues = [];
  dynamic _parentCategory = '';
  bool _servicesFetched = false;
  bool _chosenParent = false;

  ServicesViewModel() {
    // readJson();

  }

  Future<void> readJson() async {
    await getServices();
    _checkboxValues = List.generate(listOfLists.length, (index) {
      var servicesInCategory = listOfLists[index];
      return List.generate(servicesInCategory.length, (innerIndex) => false);
    });
  }

  void setInputValues({required String index, dynamic value}) {
    searchBody[index] = value;
    notifyListeners();
  }
  void setFetchedServices(bool value) {
    _servicesFetched=value;
    notifyListeners();
  }

  Future<void> filterData({required String index, dynamic value}) async {
    String? lang = await AppPreferences().get(key: dblang, isModel: false);

    _servicesList2 = _servicesList?.where((element) {
      String firstTranslationTitle = '';
      String firstTranslationCategoryTitle = '';
      String firstTranslationDescription = '';
      String firstTranslationClass = '';
      Map<String, dynamic>? parentServices;
      for (Map<String, dynamic> translation in element.translations) {
        for (Map<String,
            dynamic> translation1 in translation["services_id"]["translations"]) {
          if (translation1["languages_code"] == lang) {
            firstTranslationDescription = translation1["description"];
            firstTranslationTitle = translation1["title"];
            firstTranslationCategoryTitle = translation1["title"];

            break; // Break the loop once the translation is found
          }

        }
      }

      for (Map<String, dynamic> translation
          in element.category["translations"]) {

          if (translation["languages_code"] == lang) {
            debugPrint('category title ${translation["title"].toString()}');

            firstTranslationCategoryTitle = translation["title"];
            break; // Break the loop once the translation is found
          }
        }

      for (Map<String, dynamic> translation
          in element.category["translations"]) {

          if (translation["languages_code"] == lang) {
            // debugPrint(translation["title"].toString());

            firstTranslationCategoryTitle = translation["title"];
            break; // Break the loop once the translation is found
          }
        }

      return firstTranslationDescription
                  .toLowerCase()
                  ==value.toString().toLowerCase() ||
              firstTranslationTitle
                  .toLowerCase()
                  ==value.toString().toLowerCase()||
              firstTranslationCategoryTitle
                  .toLowerCase()
                  ==value.toString().toLowerCase()
          // ||
          // firstTranslationClass
          //     .toLowerCase()
          //     .contains(value.toString().toLowerCase())
          ;
    }).toList();
    searchBody[index] = value;
    debugPrint('searchbody in filter $searchBody');

    notifyListeners();
  }
 Future<void> searchData({required String index, dynamic value}) async {
    String? lang = await AppPreferences().get(key: dblang, isModel: false);

    _servicesList2 = _servicesList?.where((element) {
      String firstTranslationTitle = '';
      String firstTranslationCategoryTitle = '';
      String firstTranslationDescription = '';
      String firstTranslationClass = '';
      Map<String, dynamic>? parentServices;
      for (Map<String, dynamic> translation in element.translations) {
        for (Map<String,
            dynamic> translation1 in translation["services_id"]["translations"]) {
          if (translation1["languages_code"] == lang) {
            firstTranslationDescription = translation1["description"];
            firstTranslationTitle = translation1["title"];
            firstTranslationCategoryTitle = translation1["title"];

            break; // Break the loop once the translation is found
          }
        }
      }

      for (Map<String, dynamic> translation
          in element.category["translations"]) {
        // for (Map<String,
        //     dynamic> translation1 in translation["services_id"]["translations"]) {
          if (translation["languages_code"] == lang) {
            debugPrint('category title1 ${translation["title"].toString()}');

            firstTranslationCategoryTitle = translation["title"];
            break; // Break the loop once the translation is found
          }
        // }
      }
      for (Map<String, dynamic> translation
          in element.category["translations"]) {
        // for (Map<String,
        //     dynamic> translation1 in translation["services_id"]["translations"]) {
          if (translation["languages_code"] == lang) {
            // debugPrint(translation["title"].toString());

            firstTranslationCategoryTitle = translation["title"];
            break; // Break the loop once the translation is found
          }
        }
      // }

      return firstTranslationDescription
                  .toLowerCase()
                  .contains(value.toString().toLowerCase()) ||
              firstTranslationTitle
                  .toLowerCase()
                  .contains(value.toString().toLowerCase())||
              firstTranslationCategoryTitle
                  .toLowerCase()
                  .contains(value.toString().toLowerCase())
          ||
          firstTranslationClass
              .toLowerCase()
              .contains(value.toString().toLowerCase())
          ;
    }).toList();
    searchBody[index] = value;

    notifyListeners();
  }

  Future<void> setParentCategory(dynamic data) async {
    try {
      debugPrint('parent Category  $data');
      _parentCategory = data;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 1${error}');
    }
    notifyListeners();
  }

  Future<void> setParentCategoryExistence(bool isChosen) async {
    try {
      debugPrint('parent Category chosen $isChosen');
      _chosenParent = isChosen;
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 1${error}');
    }
    notifyListeners();
  }

  Future<bool?> getServices() async {
    try {
      dynamic response = await _servicesRepository.getAllServices();
      _apiServicesResponse = ApiResponse.completed(response);
      _servicesList = _apiServicesResponse.data?.services;
      _servicesList = _servicesList!.where((service) => service.status.toString().toLowerCase() == 'published').toList();

      _servicesList2 = _apiServicesResponse.data?.services;
      _servicesList2 = _servicesList2!.where((service) => service.status.toString().toLowerCase() == 'published').toList();

      debugPrint('services response ${_servicesList}');
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 2${error}');
    }
    notifyListeners();
    return true;
  }

  Future<bool?> getCountryRate(dynamic service, String? country_code) async {
    try {
      debugPrint(
          'service in get consultation rate ${service.id} ${service.title}');
      dynamic response =
          await _servicesRepository.getContryRate(service.id, country_code!);

      _apiCountyRatesResponse = ApiResponse.completed(response);
      debugPrint(
          'data of country rates ${_apiCountyRatesResponse.data!.countryRates}');
      _countryRatesList = _apiCountyRatesResponse.data!.countryRates;

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 3${error}');
    }
    notifyListeners();
    return true;
  }

  Future<void> getServicesByCategoryID(int id,dynamic supplier_services) async {
    try {
      dynamic response = await _servicesRepository.getServicesByCategoryID(id);
      debugPrint('response is in service view model $response');
      _apiServicesCategoryResponse = ApiResponse.completed(response);
      _servicesCategoryList = _apiServicesResponse.data?.services;
      // _servicesCategoryList = _servicesCategoryList!.where((service) => service.status.toString().toLowerCase() == 'published').toList();

      listOfLists.add(response);
      listOfLists = listOfLists.toSet().toList();
      // Extract service IDs from supplier_services
      if(supplier_services!=null){
        var supplierServiceIds = supplier_services.map((service) => service['services_id']['id']).toSet();

        // Initialize checkbox values based on supplier_services
        if (_checkboxValues.length < listOfLists.length) {
          for (var i = _checkboxValues.length; i < listOfLists.length; i++) {
            var categoryServices = listOfLists[i];
            _checkboxValues.add(List.generate(categoryServices.length, (innerIndex) {
              var serviceId = categoryServices[innerIndex]["id"];
              // Check if this serviceId is in supplier_services
              return supplierServiceIds.contains(serviceId);
            }));
          }
        }
      }else{
        _checkboxValues = List.generate(listOfServices.length, (index) {
          var servicesInCategory = listOfServices[index];
          return List.generate(servicesInCategory.length, (innerIndex) => false);
        });
      }
      debugPrint('list of lists ${listOfLists}');
      notifyListeners();
      // return listOfLists;
    } catch (error) {
      debugPrint('Error fetching services 4${error}');
    }
    notifyListeners();
    // return [];
  }

  Future<void> setCheckbox(int index, int innerIndex) async {
    try {
      _checkboxValues[index][innerIndex] = !_checkboxValues[index][innerIndex];
      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 5${error}');
    }
    notifyListeners();
  }

  Future<void> addService(
      int index, int innerIndex, int serviceIndex, int supplier_id) async {
    try {
      debugPrint('supplier_id ${supplier_id}');
      if (supplier_id != 0) {
        // Handle the result of setting the service for the supplier
        bool? success = await _servicesRepository.setServiceForSupplier(
            supplier_id, serviceIndex);
        debugPrint('success is $success');

        // if (success!) {
        //   _checkboxValues[index][innerIndex] =
        //       !_checkboxValues[index][innerIndex];
        // } else {
        //   // Handle the case where setting the service for the supplier failed
        //   // You can show an error message or handle it as needed.
        // }
      }

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 6${error}');
    }
  }

  Future<void> removeService(
      int index, int innerIndex, int serviceIndex, int supplier_id) async {
    try {
      debugPrint('supplier_id ${supplier_id}');
      debugPrint('service_index ${serviceIndex}');
      if (supplier_id != 0) {
        // Handle the result of setting the service for the supplier
        bool success = await _servicesRepository.removeServiceForSuplier(
            supplier_id, serviceIndex);
        debugPrint('success is $success');

        if (success) {
          _checkboxValues[index][innerIndex] =
              !_checkboxValues[index][innerIndex];
        } else {
          _checkboxValues[index][innerIndex] =
          _checkboxValues[index][innerIndex];
          // Handle the case where setting the service for the supplier failed
          // You can show an error message or handle it as needed.
        }
      }

      notifyListeners();
    } catch (error) {
      debugPrint('Error fetching services 7${error}');
    }
  }

  // get isActive => _userModelResponse.data?.status == 'active';
  get servicesList => _servicesList;

  get servicesList2 => _servicesList2;

  get countryRatesList => _countryRatesList;

  get servicesCategoryList => _servicesCategoryList;

  get listOfServices => listOfLists;

  get checkboxValues => _checkboxValues;
  get parentCategory => _parentCategory;
  get servicesFetched => _servicesFetched;
  get chosenParent => _chosenParent;
}
