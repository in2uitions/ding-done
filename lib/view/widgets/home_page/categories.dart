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
                padding: EdgeInsets.only(
                    left: context.appValues.appPadding.p20,
                    top: context.appValues.appPadding.p10),
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
              height: context.appValues.appSizePercent.h30,
              child: ListView(
                children: [
                  GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of items in each row
                      crossAxisSpacing: 4, // Spacing between items horizontally
                      mainAxisSpacing: 4, // Spacing between items vertically
                      childAspectRatio: 1, // Aspect ratio of each grid item
                    ),
                    padding: EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p0,
                      context.appValues.appPadding.p10,
                    ),
                    physics:
                        const NeverScrollableScrollPhysics(), // Disable grid view scrolling
                    shrinkWrap: true, // Wrap content inside the Column
                    itemCount: categoriesViewModel.categoriesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            left: context.appValues.appPadding.p5,
                            right: context.appValues.appPadding.p5),
                        child: buildServiceWidget(
                            categoriesViewModel.categoriesList[index],
                            categoriesViewModel,
                            index),
                      );
                    },
                  ),
                ],
              ),
            ),
            // const SizedBox(
            //     height: 15), // Add space between the first and second row
          ],
        );
      },
    );
  }

  Widget buildServiceWidget(
      dynamic service, CategoriesViewModel categoriesViewModel, int index) {
    if (lang == null) {
      lang = "en-US";
    }
    Map<String, dynamic>? services;
    Map<String, dynamic>? parentServices;
    for (Map<String, dynamic> translation in service["translations"]) {
      if (translation["languages_code"] == lang) {
        services = translation;
        break;
      }
    }
    for (Map<String, dynamic> translationParent in service["class"]
    ["translations"]) {
      if (translationParent["languages_code"] == lang) {
        parentServices = translationParent;
        break;
      }
    }

    Color backgroundColor;
    Color textColor;
    Color iconColor;

    int columnIndex = index % 4; // Determine the column index

    switch (columnIndex) {
      case 0:
        backgroundColor = Color(0xffDECDFD);
        textColor = Color(0xff180D38);
        iconColor = Color(0xff581CC6);
        break;
      case 1:
        backgroundColor = Color(0xffFCD5ED);
        textColor = Color(0xff180D38);
        iconColor = Color(0xffCB1282);
        break;
      case 2:
        backgroundColor = Color(0xffCFF5D5);
        textColor = Color(0xff180D38);
        iconColor = Color(0xff0C8E1A);
        break;
      case 3:
        backgroundColor = Color(0xffFFDFAC);
        textColor = Color(0xff180D38);
        iconColor = Color(0xffD08000);
        break;
      default:
        backgroundColor = Colors.grey;
        textColor = Colors.black;
        iconColor = Colors.black;
    }

    return widget.servicesViewModel.searchBody["search_services"]
        .toString()
        .toLowerCase() ==
        services?["title"].toString().toLowerCase() ||
        widget.servicesViewModel.searchBody["search_services"]
            .toString()
            .toLowerCase() ==
            parentServices?["title"].toString().toLowerCase()
        ? Padding(
      padding: EdgeInsets.only(
        top: context.appValues.appPadding.p10,
        bottom: context.appValues.appPadding.p10,
      ),
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.only(
              left: context.appValues.appPadding.p0,
              bottom: context.appValues.appPadding.p0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 0),
                  child: service["image"] != null
                      ? SvgPicture.network(
                    '${context.resources.image.networkImagePath2}/${service["image"]}',
                    colorFilter: ColorFilter.mode(
                      iconColor,
                      BlendMode.srcIn,
                    ),
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
                SizedBox(
                  width: context.appValues.appSizePercent.w23,
                  child: Text(
                    services?["title"] ?? '',
                    textAlign: TextAlign.center,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: getPrimaryBoldStyle(
                      fontSize: 14,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          widget.servicesViewModel.filterData(
              index: 'search_services', value: services?["title"]);
          widget.servicesViewModel
              .setParentCategory('${parentServices?["title"]}');
          debugPrint('search filter ${services?["title"]}');
          Navigator.of(context).push(_createRoute(
            CategoriesScreen(
              categoriesViewModel: categoriesViewModel,
              initialTabIndex: index,
              serviceViewModel: widget.servicesViewModel,
            ),
          ));
          categoriesViewModel.sortCategories(services?["title"]);
        },
      ),
    )
        : Container();
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
