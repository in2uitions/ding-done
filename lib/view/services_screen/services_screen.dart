import 'package:dingdone/view/categories_screen/categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart'; // Adjust path as needed
import 'package:dingdone/res/app_prefs.dart';

import '../../view_model/jobs_view_model/jobs_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../book_a_service/book_a_service.dart';
import '../widgets/categories_screen/categories_screen_cards.dart';

class CategoriesGridWidget extends StatefulWidget {
  final ServicesViewModel servicesViewModel;
  final String categoryType; // "maintenance" or "pro"

  const CategoriesGridWidget({
    Key? key,
    required this.servicesViewModel,
    required this.categoryType,
  }) : super(key: key);

  @override
  State<CategoriesGridWidget> createState() => _CategoriesGridWidgetState();
}

class _CategoriesGridWidgetState extends State<CategoriesGridWidget> {
  final bool _isLoading = false;
  String? lang;

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  Future<void> getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
      builder: (context, categoriesViewModel, _) {
        // Use an alternative filtering approach if a dedicated "categoryType" field is not present.
        final List<dynamic> filteredCategories =
            categoriesViewModel.categoriesList.where((service) {
          String currentLang = lang ?? "en-US";

          // Try to retrieve the parent translation.
          Map<String, dynamic>? parentTranslation;
          for (Map<String, dynamic> translation in service["class"]
              ["translations"]) {
            if (translation["languages_code"] == currentLang) {
              parentTranslation = translation;
              break;
            }
          }
          if (parentTranslation == null) return false;

          final String parentTitle =
              parentTranslation["title"].toString().toLowerCase();
          if (widget.categoryType == "maintenance") {
            return parentTitle.contains("maintenance");
          } else {
            return parentTitle.contains("pro");
          }
        }).toList();

        debugPrint(
            "Filtered services for ${widget.categoryType}: ${filteredCategories}");

        final String searchKey = widget.categoryType == "maintenance"
            ? "search_services"
            : "pro_services";

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: context.appValues.appSizePercent.w100,
              height: context.appValues.appSizePercent.h30,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p0,
                  context.appValues.appPadding.p10,
                ),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredCategories.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p5,
                    ),
                    child: buildServiceWidget(
                      filteredCategories[index],
                      categoriesViewModel,
                      index,
                      searchKey,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  /// Builds an individual grid cell.
  Widget buildServiceWidget(dynamic service,
      CategoriesViewModel categoriesViewModel, int index, String searchKey) {
    // Set default language if not loaded.
    if (lang == null) {
      lang = "en-US";
    }
    Map<String, dynamic>? services;
    Map<String, dynamic>? parentServices;

    // Retrieve matching translation for the service.
    for (Map<String, dynamic> translation in service["translations"]) {
      if (translation["languages_code"] == lang) {
        services = translation;
        break;
      }
    }
    // Retrieve translation for the parent service.
    for (Map<String, dynamic> translationParent in service["class"]
        ["translations"]) {
      if (translationParent["languages_code"] == lang) {
        parentServices = translationParent;
        break;
      }
    }

    // Get the filter value (if any) from the services view model.
    String? filterValue = widget.servicesViewModel.searchBody[searchKey]
        ?.toString()
        .toLowerCase();

    // If no filter is set, show all items; otherwise only show matching ones.
    bool shouldShow;
    if (filterValue == null || filterValue.isEmpty) {
      shouldShow = true;
    } else {
      shouldShow =
          filterValue == services?["title"]?.toString().toLowerCase() ||
              filterValue == parentServices?["title"]?.toString().toLowerCase();
    }

    // if (!shouldShow) {
    //   return Container();
    // }

    return InkWell(
      onTap: () {
        // Apply filtering based on the type.
        debugPrint('search_key $searchKey');
        if (searchKey == "search_services") {
          widget.servicesViewModel
              .filterData(index: 'search_services', value: services?["title"]);
        } else {
          widget.servicesViewModel
              .filterData(index: 'pro_services', value: services?["title"]);
        }

        widget.servicesViewModel
            .setParentCategory('${parentServices?["title"]}');
        debugPrint('search filter ${services?["title"]}');
        debugPrint('index $index');
        Navigator.of(context).push(_createRoute(
          CategoriesScreen(
            categoriesViewModel:
                Provider.of<CategoriesViewModel>(context, listen: false),
            initialTabIndex: index,
            serviceViewModel: widget.servicesViewModel,
          ),
        ));
        // categoriesViewModel.sortCategories(services?["title"]);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Colored container with icon.
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(
              color: const Color(0xffEAEAFF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: service["image"] != null
                  ? SvgPicture.network(
                      '${context.resources.image.networkImagePath2}/${service["image"]}',
                      width: 30,
                      height: 30,
                    )
                  : Container(
                      width: context.appValues.appSizePercent.w20,
                      height: context.appValues.appSizePercent.h5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(
                            service["image"] != null
                                ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          // Text under the colored container.
          SizedBox(
            width: context.appValues.appSizePercent.w23,
            child: Text(
              services?["title"] ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: getPrimaryRegularStyle(
                fontSize: 10,
                color: const Color(0xff180D38),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;
      final tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

//
// ServicesScreen displays the purple header at the top with a draggable bottom sheet
// that contains the search bar, a styled TabBar, and two TabBarViews for Maintenance and PRO Services.
//
class ServicesScreen extends StatefulWidget {
  const ServicesScreen({Key? key}) : super(key: key);

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredServices = [];
  String? lang;

  @override
  void initState() {
    super.initState();
    getLanguage();
    // _tabController = TabController(length: 2, vsync: this);
    final servicesViewModel =
        Provider.of<ServicesViewModel>(context, listen: false);

    // Determine the initial tab index based on the search filter
    final maintenanceFilter = servicesViewModel.searchBody['search_services'];

    int initialIndex = 0;
    if (maintenanceFilter != null &&
        maintenanceFilter.toString().isNotEmpty &&
        maintenanceFilter.toString() == 'PRO Services') {
      initialIndex = 1;
    }

    _tabController =
        TabController(length: 2, vsync: this, initialIndex: initialIndex);
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    searchController.addListener(_filterServices);
    // Initially display all services
    filteredServices = categoriesViewModel.servicesList2;
  }

  Future<void> getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() {});
    setState(() {});
  }

  void _filterServices() {
    String searchText = searchController.text.toLowerCase();
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    categoriesViewModel.searchData(index: 'search_services', value: searchText);
    debugPrint('categories search result ${categoriesViewModel.servicesList2}');

    setState(() {
      if (searchText.isEmpty) {
        // Display all services if search text is empty
        filteredServices = categoriesViewModel.servicesList2;
      } else {
        filteredServices = categoriesViewModel.servicesList2;
      }
    });
  }

  void _handleServiceSelection(dynamic service, JobsViewModel jobsViewModel,
      ProfileViewModel profileViewModel) {
    // Logic to handle service selection and navigation to next screen
    if (lang == null) {
      lang = 'en-US';
    }
    jobsViewModel.setInputValues(index: 'service', value: service["id"]);
    jobsViewModel.setInputValues(
      index: 'job_address',
      value: profileViewModel.getProfileBody['current_address'],
    );

    jobsViewModel.setInputValues(
      index: 'address',
      value:
          '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
    );
    jobsViewModel.setInputValues(
        index: 'latitude',
        value: profileViewModel.getProfileBody['current_address']['latitude']);
    jobsViewModel.setInputValues(
        index: 'longitude',
        value: profileViewModel.getProfileBody['current_address']['longitude']);
    jobsViewModel.setInputValues(index: 'payment_method', value: 'Card');

    Navigator.of(context).push(_createRoute(BookAService(
      service: service,
      lang: lang,
      image: service["image"] != null
          ? '${context.resources.image.networkImagePath2}${service["image"]}'
          : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
    )));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Retrieve ServicesViewModel. Ensure it’s provided higher in the widget tree.
    final servicesViewModel =
        Provider.of<ServicesViewModel>(context, listen: false);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height * 1.5,
            decoration: const BoxDecoration(
              color: Color(0xff4100E3),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p15,
                ),
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xffEAEAFF),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF6E6BE8),
                    ),
                    hintText: "I’m done with...",
                    hintStyle: getPrimaryRegularStyle(
                      color: const Color(0xFF6E6BE8),
                      fontSize: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF6E6BE8),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          searchController.text.isEmpty
              ? MediaQuery.removeViewInsets(
                  context: context,
                  removeBottom: true,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.80,
                    minChildSize: 0.80,
                    maxChildSize: 1.0,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Color(0xffFEFEFE),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Gap(10),
                            // Updated TabBar container.
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: const Color(0xffEAEAFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TabBar(
                                controller: _tabController,
                                indicatorSize: TabBarIndicatorSize.tab,
                                // Add padding to the indicator for a little breathing room.
                                indicatorPadding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 3,
                                ),
                                // Use a custom indicator BoxDecoration.
                                indicator: BoxDecoration(
                                  color: const Color(0xff4100E3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                // Remove any default underline by setting these to transparent.
                                indicatorColor: Colors.white,
                                indicatorWeight: 0,
                                dividerColor: Colors.transparent,
                                labelColor: Colors.white,
                                unselectedLabelColor: const Color(0xff4100E3),
                                labelStyle: getPrimarySemiBoldStyle(
                                  fontSize: 12,
                                ),
                                unselectedLabelStyle: getPrimaryMediumStyle(
                                  fontSize: 12,
                                ),
                                tabs: const [
                                  Tab(text: 'Maintenance'),
                                  Tab(text: 'PRO Services'),
                                ],
                              ),
                            ),
                            // The TabBarView for the two categories grids.
                            Expanded(
                              child: TabBarView(
                                controller: _tabController,
                                children: [
                                  CategoriesGridWidget(
                                    servicesViewModel: servicesViewModel,
                                    categoryType: "maintenance",
                                  ),
                                  CategoriesGridWidget(
                                    servicesViewModel: servicesViewModel,
                                    categoryType: "pro",
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : MediaQuery.removeViewInsets(
                  context: context,
                  removeBottom: true,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.75,
                    minChildSize: 0.75,
                    maxChildSize: 1,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                            color: Color(0xffFEFEFE),
                          ),
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: filteredServices.length,
                            itemBuilder: (context, index) {
                              var service = filteredServices[index];

                              // Find the translation where language_code == lang
                              // var lang = 'ar-SA'; // Replace this with the actual language code you're using
                              var translation =
                                  service['translations'].firstWhere(
                                (t) => t['languages_code'] == lang,
                                orElse: () => null,
                              );

                              // If no translation is found, fallback to default
                              if (translation == null) {
                                translation = {
                                  'title': service["xtitle"] ?? '',
                                  'description': service["xdescription"] ?? ''
                                };
                              }
                              debugPrint('translation si $translation');

                              return Consumer2<JobsViewModel, ProfileViewModel>(
                                builder: (context, jobsViewModel,
                                    profileViewModel, _) {
                                  return CategoriesScreenCards(
                                    category: service["category"],
                                    title: translation != null
                                        ? translation["title"]
                                        : '',
                                    cost: 0,
                                    // '${service["country_rates"][0]["unit_rate"]} ${service["country_rates"][0]["country"]["curreny"]}',
                                    image: service["image"] != null
                                        ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                        : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                    onTap: () {
                                      _handleServiceSelection(service,
                                          jobsViewModel, profileViewModel);
                                    },
                                  );
                                },
                              );
                            },
                          )

                          // child: ListView.builder(
                          //   controller: scrollController,
                          //   itemCount: filteredServices.length,
                          //   itemBuilder: (BuildContext context, int index) {
                          //     var service = filteredServices[index];
                          //     return ListTile(
                          //       title: Text(service.title),
                          //       subtitle: Text(service!=null && service.description !=null ?service.description:''),
                          //     );
                          //   },
                          // ),
                          );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
