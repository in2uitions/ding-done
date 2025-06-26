import 'package:dingdone/models/categories_model.dart';
import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:dingdone/repository/categories/categories_repo.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';

import '../../res/app_prefs.dart';

class CategoriesViewModel with ChangeNotifier {
  final CategoriesRepo _categoriesRepository = CategoriesRepo();
  ApiResponse<CategoriesModelMain> _categoriesResponse = ApiResponse.loading();
  List<dynamic>? _categoriesList = List.empty();
  List<dynamic>? _servicesList = List.empty();
  List<dynamic>? _servicesList2 = List.empty();
  List<dynamic>? _categoriesList2 = List.empty();
  List<dynamic>? _parentCategoriesList = List.empty();
  ApiResponse<DropDownModelMain> _apiCategoriesResponse = ApiResponse.loading();
  ApiResponse<DropDownModelMain> _apiParentCategoriesResponse =
      ApiResponse.loading();
  String? lang;

  CategoriesViewModel() {
    readJson();
  }
  Future<void> readJson() async {
    // await getCategories();
    await getCategoriesAndServices();
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }

  // Future<List<dynamic>?> getCategories() async {
  //   try {
  //
  //     dynamic response = await _categoriesRepository.getAllCategories();
  //     // _categoriesResponse = ApiResponse.completed(response);
  //     // _categoriesList = _categoriesResponse.data?.toJson()["categories"];
  //
  //     // _jobsResponseList =
  //     // _apiJobsResponse.data?.toCarouselJson()["jobs_carousel"];
  //     ServicesViewModel servicesViewModel =ServicesViewModel();
  //
  //     _apiCategoriesResponse = ApiResponse.completed(response);
  //     _categoriesList = _apiCategoriesResponse.data?.dropDownList;
  //     _parentCategoriesList = _categoriesList!.where((category) => category.classs == null && category.status=='published').toList();
  //     _categoriesList = _categoriesList!.where((category) => category.classs != null && category.status=='published').toList();
  //     // _categoriesList2 = _categoriesList!.where((category) => category.classs == servicesViewModel.searchBody['search_services']).toList();
  //
  //     notifyListeners();
  //
  //
  //   } catch (error) {
  //     debugPrint('Error fetching categories ${error}');
  //   }
  //   notifyListeners();
  //   return _categoriesList;
  // }

  Future<List<dynamic>?> getCategoriesAndServices() async {
    try {
      debugPrint('Getting categories and services ');

      dynamic response = await _categoriesRepository.getCategoriesAndServices();

      // debugPrint('Getting categories and services2 $response');

      // _apiCategoriesResponse = ApiResponse.completed(response["categories"]);
      // _categoriesList = _apiCategoriesResponse.data?.dropDownList;
      _categoriesList = response["categories"];
      _parentCategoriesList = _categoriesList!
          .where((category) =>
              category["class"] == null && category["status"] == 'published')
          .toList();
      _categoriesList = _categoriesList!
          .where((category) =>
              category["class"] != null && category["status"] == 'published')
          .toList();
      // _categoriesList2 = _categoriesList!.where((category) => category.classs == servicesViewModel.searchBody['search_services']).toList();
      _servicesList = response["services"];
      // debugPrint('services list $_servicesList');
      _servicesList = _servicesList!
          .where((service) =>
              service["status"].toString().toLowerCase() == 'published')
          .toList();

      _servicesList2 = _servicesList;
      // await _getCompanies();

      notifyListeners();
      return _categoriesList;
    } catch (error) {
      debugPrint('Error fetching categories and services ${error}');
    }
    notifyListeners();
    return _categoriesList;
  }



  Future<void> sortCategories(dynamic serv) async {
    try {
      if (lang == null) {
        lang = 'en-US';
      }

      // Filter the categories list to only include those with the chosen parent category
      _categoriesList2 = _categoriesList?.where((category) {
        Map<String, dynamic>? services;
        Map<String, dynamic>? parentServices;

        // Find the translation for the current language
        for (Map<String, dynamic> translation in category["translations"]) {
          debugPrint('language code is  $lang');

          // for (Map<String,
          //     dynamic> translation1 in translation["categories_id"]["translations"]) {
          if (translation["languages_code"] == lang) {
            services = translation;
            break; // Break the loop once the translation is found
          }
          // }
        }
        for (Map<String, dynamic> translationParent in category["class"]
            ["translations"]) {
          // for (Map<String,
          //     dynamic> translation1 in translationParent["categories_id"]["translations"]) {
          if (translationParent["languages_code"] == lang) {
            parentServices = translationParent;
            break; // Break the loop once the translation is found
          }
        }
        // }
        debugPrint('servvv to search for $serv');
        debugPrint('services to search for ${services?["title"]}');

        // Check if the category or its parent matches the chosen parent category
        return serv.toString().toLowerCase() ==
                services?["title"].toString().toLowerCase() ||
            serv.toString().toLowerCase() ==
                parentServices?["title"].toString().toLowerCase();
      }).toList();

      _categoriesList?.sort((a, b) {
        // Define a function to check if a service is yellow
        bool isYellow(Map<String, dynamic> service) {
          Map<String, dynamic>? services;
          Map<String, dynamic>? parentServices;
          for (Map<String, dynamic> translation in service["translations"]) {
            //   for (Map<String,
            //       dynamic> translation1 in translation["categories_id"]["translations"]) {
            if (translation["languages_code"] == lang) {
              services = translation;
              break; // Break the loop once the translation is found
            }
            // }
          }
          for (Map<String, dynamic> translationParent in service["class"]
              ["translations"]) {
            // for (Map<String,
            //     dynamic> translation1 in translationParent["categories_id"]["translations"]) {
            if (translationParent["languages_code"] == lang) {
              parentServices = translationParent;
              break; // Break the loop once the translation is found
            }
            // }
          }

          // Logic to determine if the service is yellow
          // You should replace this with your actual logic
          return serv.toString().toLowerCase() ==
                  services?["title"].toString().toLowerCase() ||
              serv.toString().toLowerCase() ==
                  parentServices?["title"].toString().toLowerCase();
        }

        // Determine if services A and B are yellow
        bool isAYellow = isYellow(a);
        bool isBYellow = isYellow(b);

        // Sort based on whether A, B, or both are yellow
        if (isAYellow && !isBYellow) {
          return -1; // A (yellow) comes before B (non-yellow)
        } else if (!isAYellow && isBYellow) {
          return 1; // B (yellow) comes before A (non-yellow)
        } else {
          return 0; // Maintain the current order
        }
      });
      debugPrint('sorted');
      notifyListeners();
    } catch (error) {
      debugPrint('Error sorting categories: $error');
    }
    // notifyListeners();
  }

  Future<void> searchData({required String index, dynamic value}) async {
    String? lang = await AppPreferences().get(key: dblang, isModel: false);

    _servicesList2 = _servicesList?.where((element) {
      String firstTranslationTitle = '';
      String firstTranslationCategoryTitle = '';
      String firstTranslationDescription = '';
      String firstTranslationClass = '';
      Map<String, dynamic>? parentServices;
      for (Map<String, dynamic> translation in element["translations"]) {
        if (translation["languages_code"] == lang) {
          firstTranslationDescription = translation["description"].toString();
          firstTranslationTitle = translation["title"].toString();
          firstTranslationCategoryTitle = translation["title"].toString();
          break; // Break the loop once the translation is found
        }
      }

      for (Map<String, dynamic> translation in element["category"]
          ["translations"]) {
        if (translation["languages_code"] == lang) {
          firstTranslationCategoryTitle = translation["title"].toString();
          break; // Break the loop once the translation is found
        }
      }
      // }

      return firstTranslationDescription
              .toLowerCase()
              .contains(value.toString().toLowerCase()) ||
          firstTranslationTitle
              .toLowerCase()
              .contains(value.toString().toLowerCase()) ||
          firstTranslationCategoryTitle
              .toLowerCase()
              .contains(value.toString().toLowerCase()) ||
          firstTranslationClass
              .toLowerCase()
              .contains(value.toString().toLowerCase());
    }).toList();

    notifyListeners();
  }

// // Define a function to check if a service is yellow
//   bool _isYellow(DropdownRoleModel service) {
//     // Logic to determine if the service is yellow
//     // You should replace this with your actual logic
//     return _getColorForService(service) == Colors.yellow;
//   }

  // Future<List<DropdownRoleModel>?> getParentCategories() async {
  //   try {
  //
  //     dynamic response = await _categoriesRepository.getParentCategories();
  //
  //     _apiParentCategoriesResponse = ApiResponse.completed(response);
  //     _parentCategoriesList = _apiParentCategoriesResponse.data?.dropDownList;
  //     notifyListeners();
  //
  //
  //   } catch (error) {
  //     debugPrint('Error fetching parent categories ${error}');
  //   }
  //   notifyListeners();
  //   return _categoriesList;
  // }

  // get isActive => _userModelResponse.data?.status == 'active';
  get servicesList => _servicesList;
  get servicesList2 => _servicesList2;

  get categoriesList => _categoriesList;
  get categoriesList2 => _categoriesList2;
  get parentCategoriesList => _parentCategoriesList;
}
