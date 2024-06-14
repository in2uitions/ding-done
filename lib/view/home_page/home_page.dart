import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/categories/parent_categories.dart';
import 'package:dingdone/view/categories_screen/categories_screen.dart';
import 'package:dingdone/view/widgets/custom/custom_search_bar.dart';
import 'package:dingdone/view/widgets/home_page/categories.dart';
import 'package:dingdone/view/widgets/home_page/services.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../bottom_bar/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  dynamic image = {};
  Future<void> _handleRefresh() async {
    try {
      String? role = await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.of(context).push(_createRoute(BottomBar(userRole: role)));


    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body:  RefreshIndicator(
        onRefresh: _handleRefresh,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color: context.resources.color.colorWhite,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Consumer3<ProfileViewModel, ServicesViewModel,CategoriesViewModel>(
                  builder: (context, profileViewModel, servicesViewModel,categoriesViewModel, _) {
                return SafeArea(
                  child: Column(
                    children: [
                      // Container(
                      //   decoration: BoxDecoration(
                      //     color: context.resources.color.btnColorBlue,
                      //     borderRadius: const BorderRadius.only(
                      //         bottomLeft: Radius.circular(20),
                      //         bottomRight: Radius.circular(20)),
                      //   ),
                      //   child: SafeArea(
                      //       child: Padding(
                      //     padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      //     child: Column(
                      //       children: [
                      //         Row(
                      //           children: [
                      //             const Text(
                      //               "🏡",
                      //               style: TextStyle(fontSize: 20),
                      //             ),
                      //             SizedBox(width: context.appValues.appSize.s5),
                      //             // Text(
                      //             //   "Lordou Vyrona 57, Larnaca 6023, Cyprus",
                      //             //   style: getPrimaryBoldStyle(
                      //             //       color: const Color(0xffEDF1F7), fontSize: 13),
                      //             // ),
                      //             Consumer<ProfileViewModel>(
                      //                 builder: (context, profileViewModel, _) {
                      //               return CustomLocationDropDown(
                      //                   profileViewModel: profileViewModel);
                      //             }),
                      //           ],
                      //         ),
                      //         SizedBox(height: context.appValues.appSize.s15),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Text(
                            //   // 'Hey,',
                            //   translate('home_screen.hi'),
                            //   style: getPrimaryRegularStyle(
                            //       color: context.resources.color.colorYellow,
                            //       fontSize: 17),
                            // ),
                            // SizedBox(width: context.appValues.appSize.s5),
                            Text(
                              profileViewModel.getProfileBody["user"] != null
                                  ? 'Hi ${profileViewModel.getProfileBody["user"]["first_name"]}!'
                                  : '',
                              style: getPrimaryRegularStyle(
                                color: context.resources.color.btnColorBlue,
                                fontSize: 32,
                              ),
                            ),
                            Container(
                              width: context.appValues.appSizePercent.w10p5,
                              // width: 41,
                              height: context.appValues.appSizePercent.h5p1,
                              // height: 41,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                    profileViewModel.getProfileBody['user'] !=
                                                null &&
                                            profileViewModel.getProfileBody['user']
                                                    ['avatar'] !=
                                                null
                                        ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                                        : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p15,
                        ),
                        child: CustomSearchBar(
                          index: 'search_services',
                          hintText: "Search for services...",
                          viewModel: servicesViewModel.searchData,
                        ),
                      ),
                      //       ],
                      //     ),
                      //   )),
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     children: [
                      //       Text(
                      //         // 'Categories',
                      //         translate('home_screen.categories'),
                      //         style: getPrimaryRegularStyle(
                      //             fontSize: 17, color: const Color(0xff222B45)),
                      //       ),
                      //       InkWell(
                      //         child: Text(
                      //           // 'View All',
                      //           translate('home_screen.viewAll'),
                      //           style: getPrimaryRegularStyle(
                      //               fontSize: 15,
                      //               color: context.resources.color.btnColorBlue),
                      //         ),
                      //         onTap: () {
                      //           servicesViewModel.filterData(
                      //               index: 'search_services', value: '');
                      //           // Navigator.of(context)
                      //           //     .push(_createRoute(CategoriesPage()));
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(height: context.appValues.appSize.s15),
                      ParentCategoriesWidget(
                          servicesViewModel: servicesViewModel),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('home_screen.categories'),
                              style: getPrimaryRegularStyle(
                                  fontSize: 28,
                                  color: context.resources.color.btnColorBlue),
                            ),
                            InkWell(
                              child: Text(
                                translate('home_screen.seeAll'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 18,
                                  color: const Color(0xff9E9BB8),
                                ),
                              ),
                              onTap: () {
                                // servicesViewModel.filterData(
                                //     index: 'search_services', value: '');
                                Navigator.of(context)
                                    .push(_createRoute(CategoriesScreen(categoriesViewModel: categoriesViewModel,)));
                              },
                            ),
                          ],
                        ),
                      ),
                      CategoriesWidget(servicesViewModel: servicesViewModel),
                    ],
                  ),
                );
              }),
            ),
            Consumer<ServicesViewModel>(builder: (context, servicesViewModel, _) {
              return Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      servicesViewModel.searchBody["search_services"] != null &&
                              servicesViewModel.searchBody["search_services"] !=
                                  ''
                          ? servicesViewModel.searchBody["search_services"]
                          : translate('home_screen.featuredServices'),
                      style: getPrimaryRegularStyle(
                          fontSize: 28,
                          color: context.resources.color.btnColorBlue),
                    ),
                    // InkWell(
                    //   child: Text(
                    //     // 'View All',
                    //     translate('home_screen.seeAll'),
                    //     style: getPrimaryRegularStyle(
                    //       fontSize: 18,
                    //       color: const Color(0xff9E9BB8),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     Navigator.of(context).push(_createRoute(ServicesPage()));
                    //   },
                    // ),
                  ],
                ),
              );
            }),
            const ServicesWidget(),
          ],
        ),
      ),
    );
  }

  void showDemoActionSheet(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
        context: context,
        builder: (BuildContext context) => child).then((String? value) {
      if (value != null) changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        // title: Text(translate('language.selection.title')),
        title: Text('Title'),
        // message: Text(translate('language.selection.message')),
        message: Text('Message'),
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(translate('language.name.en-US')),
            onPressed: () async {
              await AppPreferences()
                  .save(key: language, value: 'en', isModel: false);
              Navigator.pop(context, 'en');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ar-SA')),
            onPressed: () async {
              await AppPreferences()
                  .save(key: language, value: 'ar', isModel: false);
              Navigator.pop(context, 'ar');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.el-GR')),
            onPressed: () async {
              await AppPreferences()
                  .save(key: language, value: 'el', isModel: false);
              Navigator.pop(context, 'el');
              RestartWidget.restartApp(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Text(translate('language.name.ru-RU')),
            onPressed: () async {
              await AppPreferences()
                  .save(key: language, value: 'ru', isModel: false);
              Navigator.pop(context, 'ru');
              RestartWidget.restartApp(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          // child: Text(translate('button.cancel')),
          child: Text('Cancel'),
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context, null),
        ),
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
