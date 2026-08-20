import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../res/app_prefs.dart';
import '../../../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../../../view_model/categories_view_model/categories_view_model.dart';

class ServiceOfferedWidget extends StatefulWidget {
  final dynamic servicesViewModel;
  final dynamic profileViewModel;
  final dynamic data;

  const ServiceOfferedWidget({
    Key? key,
    required this.profileViewModel,
    required this.data,
    required this.servicesViewModel,
  }) : super(key: key);

  @override
  State<ServiceOfferedWidget> createState() => _ServiceOfferedWidgetState();
}

class _ServiceOfferedWidgetState extends State<ServiceOfferedWidget> {
  String? lang;
  late List<int> selectedServices; // Local list to manage checked states
  bool isLoading = true; // Loading state

  int? _serviceCategoryId(dynamic service) {
    final category = service['category'];
    if (category is Map<String, dynamic>) {
      final directId = category['id'];
      if (directId is int) return directId;

      final translations = category['translations'];
      if (translations is List) {
        for (final translation in translations) {
          if (translation is Map<String, dynamic>) {
            final id = translation['categories_id'];
            if (id is int) return id;
          }
        }
      }
    }
    return null;
  }

  List<dynamic> _servicesInCategory(
    List<dynamic> allServices,
    int categoryId,
  ) {
    return allServices.where((svc) {
      return _serviceCategoryId(svc) == categoryId && svc['status'] == 'published';
    }).toList();
  }

  List<dynamic> _selectedServicesInCategory(
    List<dynamic> allServices,
    int categoryId,
  ) {
    return _servicesInCategory(allServices, categoryId)
        .where((svc) => selectedServices.contains(svc['id']))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchServices();
    _getLanguage();
    // Initialize local selected services based on the profile data
    selectedServices = []; // Initialize it here or set it later after fetching
  }

  void _fetchServices() {
    if (!widget.servicesViewModel.servicesFetched) {
      widget.servicesViewModel.setFetchedServices(true);
    }
  }

  /// Same logic you had before — finds the matching translation by _lang
  String _getTranslation(List<dynamic> translations) {
    final match = translations.firstWhere(
          (t) =>
      t['languages_code'] == lang &&
          (t['title'] ?? '')
              .toString()
              .isNotEmpty,
      orElse: () => translations.firstWhere(
              (t) => t['languages_code'] == 'en-US' ) ,

    );
    return (match['title'] ?? '').toString();
  }

  Future<void> _getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() {});
    await _fetchProfileData(); // Fetch profile data
  }

  Future<void> _fetchProfileData() async {
    await widget.profileViewModel.getProfiledata();

    // After fetching profile data, update selected services
    setState(() {
      // Check if supplier_services is not null and is a list
      var supplierServices =
      widget.profileViewModel.getProfileBody["supplier_services"];
      debugPrint('supp services length ${supplierServices.length}');
      if (supplierServices is List) {
        selectedServices = supplierServices
            .map((service) => service['services_id']?['id'] as int?)
            .whereType<int>()
            .toSet()
            .toList();
      } else {
        selectedServices = [];
      }

      isLoading = false; // Set loading to false after fetching
    });
  }

  bool isServiceChecked(int serviceId) {
    return selectedServices.contains(serviceId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<JobsViewModel, CategoriesViewModel>(
      builder: (context, jobsVM, categoriesVM, _) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final parents     = categoriesVM.parentCategoriesList ?? [];
        final subCats     = categoriesVM.categoriesList       ?? [];
        final allServices = categoriesVM.servicesList         ?? [];

        return Padding(
          padding: EdgeInsets.only(left:context.appValues.appPadding.p10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: const NeverScrollableScrollPhysics(),
            // shrinkWrap: true,
            children: [
              for (final parent in parents) ...[
                Builder(builder: (_) {
                  final parentId = parent['id'] as int;

                  // Every subcategory that belongs to this parent and has
                  // at least one published service in the catalog.
                  final allSubCategoriesForParent = subCats.where((cat) {
                    final parentClass = cat['class'];
                    if (parentClass is! Map<String, dynamic>) {
                      return false;
                    }

                    final categoryParentId = parentClass['id'];
                    if (categoryParentId != parentId) {
                      return false;
                    }

                    final categoryId = cat['id'];
                    if (categoryId is! int) {
                      return false;
                    }

                    return _servicesInCategory(allServices, categoryId)
                        .isNotEmpty;
                  }).toList();

                  // Show this parent only if the supplier has data in at least
                  // one of its subcategories. When that is true, show ALL
                  // subcategories under the parent.
                  final parentHasSupplierData = allSubCategoriesForParent.any(
                    (cat) => _selectedServicesInCategory(
                      allServices,
                      cat['id'] as int,
                    ).isNotEmpty,
                  );

                  if (!parentHasSupplierData) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Text(
                          _getTranslation(parent['translations'] as List<dynamic>),
                          style: getPrimaryBoldStyle(
                            fontSize: 18,
                            color: const Color(0xff1F1F39),
                          ),
                        ),
                      ),
                      for (final cat in allSubCategoriesForParent)
                        Builder(builder: (_) {
                          final categoryId = cat['id'] as int;
                          final servicesInCategory = _servicesInCategory(
                            allServices,
                            categoryId,
                          );

                          return Container(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: ExpansionTile(
                              title: Text(
                                _getTranslation(cat['translations'] as List<dynamic>),
                                style: getPrimaryRegularStyle(
                                  fontSize: 15,
                                  color: const Color(0xff1F1F39),
                                ),
                              ),
                              children: [
                                for (final svc in servicesInCategory)
                                  CheckboxListTile(
                                    value: selectedServices.contains(svc['id']),
                                    activeColor:
                                        context.resources.color.btnColorBlue,
                                    onChanged: (bool? checked) {
                                      if (checked == null) return;
                                      setState(() {
                                        final id = svc['id'] as int;
                                        if (checked) {
                                          if (!selectedServices.contains(id)) {
                                            selectedServices.add(id);
                                          }
                                        } else {
                                          selectedServices.remove(id);
                                        }
                                        widget.profileViewModel
                                            .setSelectedServices(selectedServices);
                                      });
                                    },
                                    title: Text(
                                      _getTranslation(
                                          svc['translations'] as List<dynamic>),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 15,
                                        color: context
                                            .resources.color.secondColorBlue,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),
                    ],
                  );
                }),
              ],
            ],
          ),
        );
      },
    );
  }
}
