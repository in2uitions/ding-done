// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dingdone/models/roles_model.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
      builder: (context, categoriesViewModel, _) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
          ),
          child: Column(
            children: [
              SizedBox(
                width: context.appValues.appSizePercent.w100,
                height: 64,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const ScrollPhysics(),
                  // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 8,
                  //   crossAxisSpacing: 8,
                  // ),
                  itemCount: categoriesViewModel.parentCategoriesList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: EdgeInsets.only(
                        right: context.appValues.appPadding.p20,
                        // left: context.appValues.appPadding.p10,
                      ),
                      child: buildServiceWidget(
                          categoriesViewModel.parentCategoriesList[index],
                          categoriesViewModel),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget buildServiceWidget(
      DropdownRoleModel service, CategoriesViewModel categoriesViewModel) {
    Map<String, dynamic>? services;
    Map<String, dynamic>? parentServices;
    for (Map<String, dynamic> translation in service.translations) {
      if (translation["languages_code"]["code"] == lang) {
        services = translation;
        break; // Break the loop once the translation is found
      }
    }
    return InkWell(
      child: Container(
        width: context.appValues.appSizePercent.w36,
        height: 100,
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
              ? const Color(0xff57527A)
              : widget.servicesViewModel.searchBody["search_services"] == '' ||
                      widget.servicesViewModel.searchBody["search_services"] ==
                          null
                  ? const Color(0xff9F9AB7)
                  : const Color(0xff9F9AB7),
        ),
        child: _isLoading
            ? SkeletonListView()
            : Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // SvgPicture.network(
                  //   '${context.resources.image.networkImagePath}/${service.image["filename_disk"]}',
                  // ),
                  Text(
                    services?["title"] ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: getPrimaryBoldStyle(
                      fontSize: 18,
                      color: context.resources.color.colorWhite,
                    ),
                  ),
                ],
              ),
      ),
      onTap: () {
        debugPrint('search filter ${widget.servicesViewModel.searchBody}');
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
