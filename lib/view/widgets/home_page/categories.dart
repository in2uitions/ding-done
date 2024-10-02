import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../../res/app_prefs.dart';
import '../../categories_screen/categories_screen.dart';

class CategoriesWidget extends StatefulWidget {
  var servicesViewModel;

  CategoriesWidget({super.key, required this.servicesViewModel});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

String? lang;

class _CategoriesWidgetState extends State<CategoriesWidget> {
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getLanguage();
    // Provider.of<CategoriesViewModel>(context, listen: false).sortCategories(widget.servicesViewModel.searchBody["search_services"]);

  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoriesViewModel>(
      builder: (context, categoriesViewModel, _) {
        // categoriesViewModel.sortCategories(widget.servicesViewModel.searchBody["search_services"]);
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left:context.appValues.appPadding.p20,top: context.appValues.appPadding.p10),
                child: InkWell(
                  child: SvgPicture.asset('assets/img/back.svg'),
                  onTap: () {
                    widget.servicesViewModel.setParentCategoryExistence(false);
                  },
                ),
              ),
            ),
            SizedBox(
              width: context.appValues.appSizePercent.w100,
              height: context.appValues.appSizePercent.h70,
              child:  GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // Number of items in each row
                  crossAxisSpacing: 4, // Spacing between items horizontally
                  mainAxisSpacing: 4, // Spacing between items vertically
                  childAspectRatio: 1, // Aspect ratio of each grid item
                ),
                padding:   EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p0,
                      context.appValues.appPadding.p10,
                    ),
                physics: NeverScrollableScrollPhysics(), // Disable grid view scrolling
                shrinkWrap: true, // Wrap content inside the Column
                itemCount: categoriesViewModel.categoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return
                  Padding(
                    padding: EdgeInsets.only(
                        left: context.appValues.appPadding.p5,right:context.appValues.appPadding.p5 ),
                    child: buildServiceWidget(
                        categoriesViewModel.categoriesList[index],
                        categoriesViewModel,index),
                  );
                },
              ),
            ),
            const SizedBox(
                height: 15), // Add space between the first and second row
          ],
        );
      },
    );
  }

  Widget buildServiceWidget(
      dynamic service, CategoriesViewModel categoriesViewModel,var index) {
    if(lang==null){
      lang="en-US";
    }
    Map<String, dynamic>? services;
    Map<String, dynamic>? parentServices;
    for (Map<String, dynamic> translation in service["translations"]) {
      // for (Map<String, dynamic> translation1 in translation["categories_id"]["translations"]) {

      if (translation["languages_code"] == lang) {
        debugPrint('transssb usg ${translation}');

        services = translation;
          // categoriesViewModel.sortCategories(widget.servicesViewModel.searchBody["search_services"]);
          break; // Break the loop once the translation is found
        }
      // }
    }
    for (Map<String, dynamic> translationParent
        in service["class"]["translations"]) {
        if (translationParent["languages_code"] == lang) {
        parentServices = translationParent;
        break; // Break the loop once the translation is found
      }
    }
    debugPrint('efhiew ${widget.servicesViewModel.searchBody["search_services"]}');

    return widget.servicesViewModel.searchBody["search_services"]
        .toString()
        .toLowerCase() ==
        services?["title"].toString().toLowerCase() ||
        widget.servicesViewModel.searchBody["search_services"]
            .toString()
            .toLowerCase() ==
            parentServices?["title"].toString().toLowerCase()

        ?
    Padding(
      padding: EdgeInsets.only(
        top: context.appValues.appPadding.p10,
        bottom: context.appValues.appPadding.p10,
      ),
      child: InkWell(
        child: Container(
          width: 137,
          height: 137,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.servicesViewModel.searchBody["search_services"]
                                .toString()
                                .toLowerCase() ==
                            services?["title"].toString().toLowerCase() ||
                        widget.servicesViewModel.searchBody["search_services"]
                                .toString()
                                .toLowerCase() ==
                            parentServices?["title"].toString().toLowerCase()
                    ? const Color(0xffF2CA74).withOpacity(0.5)
                    : widget.servicesViewModel.searchBody["search_services"] ==
                                '' ||
                            widget.servicesViewModel
                                    .searchBody["search_services"] ==
                                null
                        ? const Color(0xffF2CA74).withOpacity(0.5)
                        : Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            color: widget.servicesViewModel.searchBody["search_services"]
                            .toString()
                            .toLowerCase() ==
                        services?["title"].toString().toLowerCase() ||
                    widget.servicesViewModel.searchBody["search_services"]
                            .toString()
                            .toLowerCase() ==
                        parentServices?["title"].toString().toLowerCase()
                ? const Color(0xffF3D347)
                : widget.servicesViewModel.searchBody["search_services"] ==
                            '' ||
                        widget.servicesViewModel
                                .searchBody["search_services"] ==
                            null
                    ? const Color(0xffF3D347)
                    : Colors.grey,
          ),
          child: _isLoading
              ? SkeletonListView()
              : Stack(
                  children: [
                    LayoutBuilder(
                      builder: (context, constraints) => Stack(
                        children: [
                          Positioned(
                            right: -constraints.maxWidth * .25,
                            bottom: constraints.maxHeight * .4,
                            top: constraints.maxHeight * .01,
                            child: service["image"] != null
                                ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(150),
                                bottomRight: Radius.circular(20),
                              ),
                              child: SvgPicture.network('${context.resources.image.networkImagePath2}/${service["image"]}',
                                colorFilter: ColorFilter.mode(
                                  widget.servicesViewModel.searchBody["search_services"]
                                      .toString()
                                      .toLowerCase() ==
                                      services?["title"]
                                          .toString()
                                          .toLowerCase() ||
                                      widget.servicesViewModel.searchBody["search_services"]
                                          .toString()
                                          .toLowerCase() ==
                                          parentServices?["title"]
                                              .toString()
                                              .toLowerCase()
                                      ? const Color(0xffDDB504)
                                      : widget.servicesViewModel.searchBody["search_services"] ==
                                      '' ||
                                      widget.servicesViewModel.searchBody["search_services"] ==
                                          null
                                      ? const Color(0xffDDB504)
                                      : Color.fromARGB(255, 124, 124, 124),
                                  BlendMode.srcIn,
                                ),
                                width: 111.36,
                                height: 104.27,
                              ),
                            )
                                : ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(150),
                                bottomRight: Radius.circular(20),
                              ),
                              child: Container(
                                width: context.appValues.appSizePercent.w20,
                                height: context.appValues.appSizePercent.h5,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      service.image != null
                                          ? '${context.resources.image.networkImagePath2}${service.image["filename_disk"]}'
                                          : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg', // Specify the URL of your alternative image here
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: context.appValues.appPadding.p20,
                          bottom: context.appValues.appPadding.p20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              services?["title"] ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: getPrimaryBoldStyle(
                                fontSize: 16,
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: context.appValues.appPadding.p20,
                          bottom: context.appValues.appPadding.p20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: service["image"] != null
                                  ? SvgPicture.network('${context.resources.image.networkImagePath2}/${service["image"]}',
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                                width: 43,
                                height: 40,
                              )
                                  : Container(
                                width: context.appValues.appSizePercent.w20,
                                height: context.appValues.appSizePercent.h5,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      service["image"] != null
                                          ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                          : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg', // Specify the URL of your alternative image here
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                  // borderRadius: const BorderRadius.only(
                                  //   topLeft: Radius.circular(15),
                                  //   topRight: Radius.circular(15),
                                  // ),
                                ),
                              ),
                            ),
                            Text(
                              services?["title"] ?? '',
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: getPrimaryBoldStyle(
                                fontSize: 16,
                                color: context.resources.color.colorWhite,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
        ),
        onTap: () {
          widget.servicesViewModel
              .filterData(index: 'search_services', value: services?["title"]);
          widget.servicesViewModel
              .setParentCategory('${parentServices?["title"]}');
          debugPrint('search filter ${services?["title"]}');
          Navigator.of(context).push(_createRoute(
            CategoriesScreen(categoriesViewModel: categoriesViewModel,initialTabIndex: index,serviceViewModel: widget.servicesViewModel,),
          ));
          categoriesViewModel.sortCategories(services?["title"]);
        },

      ),
    ) :
    Container();
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
