import 'package:dingdone/models/categories_model.dart';
import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/models/services_model.dart';
import 'package:dingdone/repository/categories/categories_repo.dart';
import 'package:dingdone/utils/country_helper.dart';
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
  List<dynamic>? _getItDoneData = List.empty();
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
    await getCategoriesAndServices();
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
  }

  Future<List<dynamic>?> getCategoriesAndServices() async {
    try {
      debugPrint('Getting categories and services ');

      // Run featured carousel fetch in parallel with the main catalog.
      final getItDoneFuture = _categoriesRepository.getItDone();
      dynamic response = await _categoriesRepository.getCategoriesAndServices();
      final selectedCountry = await AppPreferences()
          .get(key: selectedCountryKey, isModel: false) as String?;

      // debugPrint('Getting categories and services2 $response');

      // _apiCategoriesResponse = ApiResponse.completed(response["categories"]);
      // _categoriesList = _apiCategoriesResponse.data?.dropDownList;
      final allCategories = _asMapList(response["categories"]);
      final allServices = _asMapList(response["services"]);
      final categoriesById = <dynamic, Map<String, dynamic>>{
        for (final category in allCategories)
          if (_categoryId(category) != null) _categoryId(category): category,
      };

      if (selectedCountry == null || selectedCountry.isEmpty) {
        _categoriesList = [];
        _parentCategoriesList = [];
        _servicesList = [];
        _servicesList2 = [];
        _getItDoneData = [];
        notifyListeners();
        return _categoriesList;
      }

      _servicesList = allServices
          .where((service) =>
              service["status"].toString().toLowerCase() == 'published')
          .map((service) {
            final matchingRates =
                (service["country_rates"] as List? ?? const [])
                    .where((rate) => _rateMatchesCountry(rate, selectedCountry))
                    .toList();
            if (matchingRates.isEmpty) return null;

            return <String, dynamic>{
              ...service,
              "country_rates": matchingRates,
            };
          })
          .whereType<Map<String, dynamic>>()
          .toList();

      final serviceCategoryIds = _servicesList!
          .map((service) => _categoryId(service["category"]))
          .where((id) => id != null)
          .toSet();
      final leafCategories = allCategories
          .where((category) =>
              serviceCategoryIds.contains(_categoryId(category)) &&
              category["status"] == 'published')
          .toList();

      // Walk nested class chains (e.g. leaf → mid → root) so Cyprus-style
      // multi-level categories still resolve to a visible parent tab.
      final rootParents = <dynamic, Map<String, dynamic>>{};
      for (final category in leafCategories) {
        final root = _rootParent(category, categoriesById);
        if (root != null && root["status"] == 'published') {
          final rootId = _categoryId(root);
          if (rootId != null) rootParents[rootId] = root;
        }
      }

      _categoriesList = leafCategories
          .where((category) => category["class"] != null)
          .map((category) {
        final root = _rootParent(category, categoriesById);
        if (root == null) return category;
        return <String, dynamic>{
          ...category,
          // Existing screens filter with category['class']['id'] == parentId.
          "class": root,
        };
      }).toList();
      _parentCategoriesList = rootParents.values.toList();

      // Some catalogs attach services directly to a parent category.
      _parentCategoriesList!.addAll(leafCategories.where((category) =>
          category["class"] == null &&
          !_parentCategoriesList!
              .any((parent) => parent["id"] == category["id"])));

      _servicesList2 = List<dynamic>.from(_servicesList!);
      // Show catalog immediately; featured carousel catches up next.
      notifyListeners();

      try {
        dynamic response2 = await getItDoneFuture;
        debugPrint('get it done data ${response2["data"]}');
        final servicesById = <dynamic, Map<String, dynamic>>{
          for (final service in _servicesList!)
            if (_relationId(service["id"]) != null)
              _relationId(service["id"]): service,
        };
        final allowedServiceIds = servicesById.keys.toSet();
        final allowedCategoryIds = <dynamic>{
          ..._categoriesList!.map(_categoryId),
          ..._parentCategoriesList!.map(_categoryId),
        }..removeWhere((id) => id == null);

        _getItDoneData =
            List<dynamic>.from(response2["data"] as List? ?? const [])
                .whereType<Map>()
                .map((item) => Map<String, dynamic>.from(item))
                .where((item) {
          final serviceId = _relationId(item["service"]);
          if (serviceId != null) {
            return allowedServiceIds.contains(serviceId);
          }

          final subCategoryId = _categoryId(item["sub_category"]);
          if (subCategoryId != null) {
            return allowedCategoryIds.contains(subCategoryId);
          }

          final parentCategoryId = _categoryId(item["parent_category"]);
          if (parentCategoryId != null) {
            return allowedCategoryIds.contains(parentCategoryId);
          }

          // Entries that only carry an external link are country agnostic.
          return true;
        }).map((item) {
          final serviceId = _relationId(item["service"]);
          if (serviceId != null && servicesById.containsKey(serviceId)) {
            // Hydrate slim API service id with the already-filtered catalog row.
            return <String, dynamic>{
              ...item,
              "service": servicesById[serviceId],
            };
          }
          return item;
        }).toList();
        notifyListeners();
      } catch (error) {
        debugPrint('Error fetching get it done $error');
      }

      return _categoriesList;
    } catch (error) {
      debugPrint('Error fetching categories and services ${error}');
    }
    notifyListeners();
    return _categoriesList;
  }

  dynamic _relationId(dynamic relation) {
    if (relation is Map) return relation["id"];
    return relation;
  }

  List<Map<String, dynamic>> _asMapList(dynamic value) {
    return List<dynamic>.from(value as List? ?? const [])
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  /// Catalog services expose their category as a translations-only object, so
  /// the id has to come from `translations[*].categories_id`.
  dynamic _categoryId(dynamic category) {
    if (category is! Map) return category;
    if (category["id"] != null) return category["id"];

    for (final translation in (category["translations"] as List? ?? const [])) {
      if (translation is Map && translation["categories_id"] != null) {
        return _relationId(translation["categories_id"]);
      }
    }
    return null;
  }

  /// Resolve the top-most parent category for nested class chains.
  Map<String, dynamic>? _rootParent(
    Map<String, dynamic> category,
    Map<dynamic, Map<String, dynamic>> categoriesById,
  ) {
    dynamic current = category["class"];
    if (current == null) return null;

    final seen = <dynamic>{};
    while (current != null) {
      if (current is Map) {
        final currentMap = Map<String, dynamic>.from(current);
        final currentId = _categoryId(currentMap);
        if (currentMap["class"] == null) return currentMap;
        if (currentId != null && !seen.add(currentId)) break;
        current = currentMap["class"] ??
            (currentId != null ? categoriesById[currentId] : null);
        continue;
      }

      if (!seen.add(current)) break;
      final next = categoriesById[current];
      if (next == null) return null;
      if (next["class"] == null) return next;
      current = next["class"];
    }
    return null;
  }

  bool _rateMatchesCountry(dynamic rate, String selectedCountry) {
    if (rate is! Map) return false;
    return countryValuesMatch(rate["country"], selectedCountry);
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
  get getItDoneData => _getItDoneData;
}
