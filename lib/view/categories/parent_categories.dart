import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../res/app_prefs.dart';
import '../bottom_bar/bottom_bar.dart';
import '../services_screen/services_screen.dart';

class ParentCategoriesWidget extends StatefulWidget {
  var servicesViewModel;

  ParentCategoriesWidget({super.key, required this.servicesViewModel});

  @override
  State<ParentCategoriesWidget> createState() => _ParentCategoriesWidgetState();
}

String? lang;

class _ParentCategoriesWidgetState extends State<ParentCategoriesWidget> {
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    setState(() {}); // Trigger a rebuild after fetching the language
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
      builder: (context, categoriesViewModel, _) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p0,
          ),
          child: Column(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items in each row
                  crossAxisSpacing: 20, // Spacing between items horizontally
                  mainAxisSpacing: 4, // Spacing between items vertically
                  childAspectRatio: 1.5, // Aspect ratio of each grid item
                ),
                itemCount: categoriesViewModel.parentCategoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCategoryWidget(
                    categoriesViewModel.parentCategoriesList[index],
                    categoriesViewModel,
                    index,
                  );
                },
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget buildCategoryWidget(
      dynamic category, CategoriesViewModel categoriesViewModel, int index) {
    Map<String, dynamic>? services;
    if (lang == null) {
      lang = "en-US";
    }
    for (Map<String, dynamic> translation in category["translations"]) {
      if (translation["languages_code"] == lang) {
        services = translation;
        break; // Break the loop once the translation is found
      }
    }

    Color categoryColor;
    switch (index) {
      case 0:
        categoryColor = const Color(0xFFEAEAFF); // Purple
        break;
      case 1:
        categoryColor = const Color(0xFFEAEAFF); // Pink
        break;
      default:
        categoryColor = const Color(0xFFEAEAFF); // Default Yellow
    }

    // Build the image container only
    Widget imageContainer = Container(
      height: 76,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        color: categoryColor,
      ),
      child: _isLoading
          ? SkeletonListView()
          : Center(
              child: SvgPicture.network(
                '${context.resources.image.networkImagePath2}/${category["image"]}.svg',
                height: 40,
                width: 40,
              ),
            ),
    );

    return InkWell(
      onTap: () {
        debugPrint('search filter ${services?['title']}');
        widget.servicesViewModel.setParentCategoryExistence(true);
        widget.servicesViewModel
            .filterData(index: 'search_services', value: services?["title"]);
        widget.servicesViewModel.setInputValues(
            index: 'search_services', value: services?["title"]);
        widget.servicesViewModel.setParentCategory(services?["title"]);
        categoriesViewModel.sortCategories(services?["title"]);
        Navigator.of(context).push(_createRoute(
                  ServicesScreen(initialTabIndex: index),
                ));
        Navigator.of(context).push(_createRoute(
          BottomBar(
            userRole: Constants.customerRoleId,
            currentTab: 1,
          ),
        ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageContainer,
          const SizedBox(height: 10),
          Text(
            services?["title"] ?? '',
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getPrimaryMediumStyle(
              fontSize: 12,
              color: const Color(0xff180D38),
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

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
