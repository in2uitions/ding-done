import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../res/app_prefs.dart';

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
            context.appValues.appPadding.p8,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p8,
            context.appValues.appPadding.p0,
          ),
          child: Column(
            children: [
              GridView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                ),
                itemCount: categoriesViewModel.parentCategoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return buildCategoryWidget(
                      categoriesViewModel.parentCategoriesList[index],
                      categoriesViewModel);
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
      dynamic category, CategoriesViewModel categoriesViewModel) {
    Map<String, dynamic>? services;
    if (lang == null) {
      lang = "en-US";
    }
    debugPrint('category $category');
    for (Map<String, dynamic> translation in category["translations"]) {
      // for (Map<String, dynamic> translation1 in translation["categories_id"]["translations"]) {
      //   debugPrint('translation 1 is ${translation1}');
      if (translation["languages_code"] == lang) {
        services = translation;
        break; // Break the loop once the translation is found
      }
      // }
    }
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(22),
          ),
          color: widget.servicesViewModel.searchBody["search_services"]
                          .toString()
                          .toLowerCase() ==
                      services?["title"].toString().toLowerCase() ||
                  widget.servicesViewModel.parentCategory
                          .toString()
                          .toLowerCase() ==
                      services?["title"].toString().toLowerCase()
              ? const Color(0xffBEC2CE)
              : widget.servicesViewModel.searchBody["search_services"] == '' ||
                      widget.servicesViewModel.searchBody["search_services"] ==
                          null
                  ? const Color(0xffF3D347)
                  : const Color(0xffF3D347),
        ),
        child: _isLoading
            ? SkeletonListView()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.network(
                    '${context.resources.image.networkImagePath}/${category["image"]}',
                    height: 40,
                    width: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    services?["title"] ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getPrimaryBoldStyle(
                      fontSize: 12,
                      color: const Color(0xff180D38),
                    ),
                  ),
                ],
              ),
      ),
      onTap: () {
        debugPrint('search filter ${widget.servicesViewModel.searchBody}');
        widget.servicesViewModel.setParentCategoryExistence(true);
        widget.servicesViewModel
            .filterData(index: 'search_services', value: services?["title"]);
        debugPrint(
            'search filter ${widget.servicesViewModel.searchBody["search_services"]}');
        widget.servicesViewModel.setParentCategory('');
        categoriesViewModel.sortCategories(services?["title"]);
      },
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
