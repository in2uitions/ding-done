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
      orElse: () => translations.first,
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
      if (supplierServices is List) {
        // Map and cast service IDs to int
        selectedServices = supplierServices
            .map((service) =>
        service["services_id"]?['id'] as int) // Explicitly cast to int
            .where((id) => id != null) // Ensure no null values are added
            .toList();
      } else {
        selectedServices = []; // Default to an empty list if not a list
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
                // Top-level parent title
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

                // Sub-categories under this parent
                for (final cat in subCats.where(
                      (c) => (c['class']['id'] as int) == (parent['id'] as int),
                )) ...[
                  Builder(builder: (_) {
                    // Compute services in this sub-category:
                    final servicesInCategory = allServices.where((svc) {
                      final catTransList =
                      svc['category']['translations'] as List<dynamic>;
                      final translation = catTransList.firstWhere(
                            (tr) => tr['languages_code'] == lang,
                        orElse: () => catTransList.first,
                      );
                      return (translation['categories_id'] as int) ==
                          (cat['id'] as int) &&
                          svc['status'] == 'published';
                    }).toList();

                    if (servicesInCategory.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      // decoration: BoxDecoration(
                      //   border:
                      //   Border.all(width: 0, color: const Color(0xffEDF1F7)),
                      // ),
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
                                    selectedServices.add(id);
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
                                  color:
                                  context.resources.color.secondColorBlue,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ],
              ],
            ],
          ),
        );
      },
    );
  }
}
