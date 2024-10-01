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
      var supplierServices = widget.profileViewModel.getProfileBody["supplier_services"];
      if (supplierServices is List) {
        // Map and cast service IDs to int
        selectedServices = supplierServices
            .map((service) => service["services_id"]?['id'] as int) // Explicitly cast to int
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
      builder: (context, jobsViewModel, categoriesViewModel, _) {
        if (isLoading) {
          return Center(child: CircularProgressIndicator()); // Loading indicator
        }

        return Padding(
          padding: EdgeInsets.all(context.appValues.appPadding.p10),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: categoriesViewModel.categoriesList.length,
            itemBuilder: (BuildContext context, int categoryIndex) {
              var category = categoriesViewModel.categoriesList[categoryIndex];

              // Get the category's translated name based on the current language
              var categoryTranslation = (category['translations']
                  .firstWhere((translation) => translation['languages_code'] == lang, orElse: () {
                return category['translations'].isNotEmpty
                    ? category['translations']
                    : {'title': 'Default Title'};
              }))['title'].toString();

              // Find services that belong to this category
              var servicesInCategory = categoriesViewModel.servicesList.where((service) {
                var categoryTranslation = service['category']['translations'].firstWhere(
                        (translation) => translation['languages_code'] == lang,
                    orElse: () => null);

                return categoryTranslation != null &&
                    categoryTranslation['categories_id'] == category['id'];
              }).toList();

              if (servicesInCategory.isEmpty) {
                return const SizedBox.shrink(); // No services to show for this category
              }

              return ExpansionTile(
                title: Text(
                  categoryTranslation,
                  style: getPrimaryBoldStyle(
                    fontSize: 15,
                    color: const Color(0xff1F1F39),
                  ),
                ),
                children: [
                  for (int innerIndex = 0; innerIndex < servicesInCategory.length; innerIndex++)
                    servicesInCategory[innerIndex]["status"] == 'published'
                        ? CheckboxListTile(
                      value: selectedServices.contains(servicesInCategory[innerIndex]["id"]),
                      activeColor: context.resources.color.btnColorBlue,
                      onChanged: (bool? value) async {
                        if (value != null) {
                          setState(() {
                            int serviceId = servicesInCategory[innerIndex]["id"];
                            // int supplierId = widget.profileViewModel.getProfileBody["id"];

                            if (value) {
                              selectedServices.add(serviceId); // Add to local state
                              // widget.servicesViewModel.addService(categoryIndex, innerIndex, serviceId, supplierId);
                            } else {
                              selectedServices.remove(serviceId); // Remove from local state
                              // widget.servicesViewModel.removeService(categoryIndex, innerIndex, serviceId, supplierId);
                            }
                          });
                          debugPrint('selected Services $selectedServices');
                          widget.profileViewModel.setSelectedServices(selectedServices);
                        }
                      },
                      title: Text(
                        servicesInCategory[innerIndex]["translations"]
                            .firstWhere(
                              (translation) => translation["languages_code"] == lang,
                          orElse: () => servicesInCategory[innerIndex]["translations"][0],
                        )["title"]
                            .toString(),
                        style: getPrimaryRegularStyle(
                          fontSize: 15,
                          color: context.resources.color.secondColorBlue,
                        ),
                      ),
                    )
                        : Container(),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
