import 'package:dingdone/models/categories_model.dart';
import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/repository/categories/categories_repo.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/data/remote/response/ApiResponse.dart';

import '../../res/app_prefs.dart';

class CategoriesViewModel with ChangeNotifier {
  final CategoriesRepo _categoriesRepository = CategoriesRepo();
  ApiResponse<CategoriesModelMain> _categoriesResponse = ApiResponse.loading();
  List<DropdownRoleModel>? _categoriesList = List.empty();
  List<DropdownRoleModel>? _parentCategoriesList = List.empty();
  ApiResponse<DropDownModelMain> _apiCategoriesResponse = ApiResponse.loading();
  ApiResponse<DropDownModelMain> _apiParentCategoriesResponse = ApiResponse.loading();
  String? lang;


  CategoriesViewModel() {
    readJson();
  }
  Future<void> readJson() async {
    await getCategories();
    getLanguage();
  }
  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }

  Future<List<DropdownRoleModel>?> getCategories() async {
    try {

      dynamic response = await _categoriesRepository.getAllCategories();
      // _categoriesResponse = ApiResponse.completed(response);
      // _categoriesList = _categoriesResponse.data?.toJson()["categories"];

      // _jobsResponseList =
      // _apiJobsResponse.data?.toCarouselJson()["jobs_carousel"];

      _apiCategoriesResponse = ApiResponse.completed(response);
      _categoriesList = _apiCategoriesResponse.data?.dropDownList;
      _parentCategoriesList = _categoriesList!.where((category) => category.classs == null && category.status=='published').toList();

      _categoriesList = _categoriesList!.where((category) => category.classs != null && category.status=='published').toList();

      notifyListeners();


    } catch (error) {
      debugPrint('Error fetching categories ${error}');
    }
    notifyListeners();
    return _categoriesList;
  }

  Future<void> sortCategories(dynamic serv) async {
    try {

      ServicesViewModel servicesViewModel =ServicesViewModel();

      _categoriesList?.sort((a, b) {

        // Define a function to check if a service is yellow
        bool isYellow(DropdownRoleModel service) {
          Map<String, dynamic>? services;
          Map<String, dynamic>? parentServices;
          for (Map<String, dynamic> translation in service.translations) {
            if (translation["languages_code"]["code"] == lang) {
              services = translation;
              break; // Break the loop once the translation is found
            }
          }
          for (Map<String, dynamic> translationParent in service.classs["translations"]) {
            if (translationParent["languages_code"]["code"] == lang) {
              parentServices = translationParent;
              break; // Break the loop once the translation is found
            }
          }
          debugPrint('${serv
              .toString()
              .toLowerCase() ==
              services?["title"].toString().toLowerCase() ||
              serv
                  .toString()
                  .toLowerCase() ==
                  parentServices?["title"].toString().toLowerCase()}');
          // Logic to determine if the service is yellow
          // You should replace this with your actual logic
          return serv
              .toString()
              .toLowerCase() ==
              services?["title"].toString().toLowerCase() ||
              serv
                  .toString()
                  .toLowerCase() ==
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
    notifyListeners();
  }
//
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
  get categoriesList => _categoriesList;
  get parentCategoriesList => _parentCategoriesList;

}
