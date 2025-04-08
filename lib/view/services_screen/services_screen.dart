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
            "Filtered services for ${widget.categoryType}: ${filteredCategories.length}");

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

    if (!shouldShow) {
      return Container();
    }

    return InkWell(
      onTap: () {
        // Apply filtering based on the type.
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
        Navigator.of(context).push(_createRoute(
          CategoriesScreen(
            categoriesViewModel:
                Provider.of<CategoriesViewModel>(context, listen: false),
            initialTabIndex: index,
            serviceViewModel: widget.servicesViewModel,
          ),
        ));
        categoriesViewModel.sortCategories(services?["title"]);
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
                fontSize: 12,
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Purple header covering the top half.
          Container(
            width: screenSize.width,
            height: screenSize.height * 1.5,
            decoration: const BoxDecoration(
              color: Color(0xff4100E3),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.85,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) {
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
                    const Gap(30),
                    // Updated TabBar container.
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
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
                        indicatorWeight: 0, dividerColor: Colors.transparent,
                        labelColor: Colors.white,
                        unselectedLabelColor: const Color(0xff4100E3),
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
          )
        ],
      ),
    );
  }
}
