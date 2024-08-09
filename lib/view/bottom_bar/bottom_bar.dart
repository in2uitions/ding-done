// ignore_for_file: must_be_immutable

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/home_page/home_page.dart';
import 'package:dingdone/view/home_page/home_page_supplier.dart';
import 'package:dingdone/view/inbox_page/inbox_page.dart';
import 'package:dingdone/view/jobs_page/jobs_page.dart';
import 'package:dingdone/view/profile_page/profile_page.dart';
import 'package:dingdone/view/profile_page_supplier/profile_page_supplier.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';

class BottomBar extends StatefulWidget {
  var userRole;

  BottomBar({super.key, required this.userRole});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  // Properties & Variables needed
  String? lang;

  int currentTab = 0;
  late Widget currentScreen;
  // to keep track of active tab index
  // final List<Widget> screens = [
  //   // HomePage(),
  //   HomePageSupplier(),
  //   JobsPage(),
  //   InboxPage(),
  //   ProfilePage(),
  //   // HomePage(),
  // ]; // to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();
  final JobsViewModel _jobsViewModel = JobsViewModel();

  @override
  void initState() {
    super.initState();
    getLanguage();
    Provider.of<CategoriesViewModel>(context, listen: false).readJson();

    _jobsViewModel.readJson();
    currentScreen = widget.userRole == Constants.supplierRoleId
        ? const HomePageSupplier()
        : const HomePage();
  }
  // Widget currentScreen = HomePage(); // Our first view in viewport
  // Widget currentScreen = HomePageSupplier(); // Our first view in viewport

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    if(lang==null){
      lang='en-US';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Provider.of<ProfileViewModel>(context, listen: false)
            .getProfiledata(),
        builder: (context, AsyncSnapshot data) {
          return Scaffold(
            extendBody: false,
            backgroundColor: Colors.white,
            body: PageStorage(
              child: currentScreen,
              bucket: bucket,
            ),
            // floatingActionButton: Container(
            //   // height: 35,
            //   // width: context.appValues.appSizePercent.w90,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(context.appValues.appRadius.r25),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Color(0xff180C39),
            //         spreadRadius: 0,
            //         blurRadius: 3,
            //         offset: const Offset(0, 0),
            //       ),
            //     ],
            //     // color: const const Color(0xff9F9AB7),
            //   ),
            //   child: FloatingActionButton(
            //     backgroundColor: const Color(0xff9F9AB7),
            //     child: SvgPicture.asset(
            //       'assets/img/sc.svg',
            //       fit: BoxFit.contain,
            //       // height: 17,
            //       color: Colors.white,
            //     ),
            //     onPressed: () {
            //       setState(() {
            //         currentScreen = JobCards(
            //           filter: null,
            //           jobsViewModel: null,
            //           index: null,
            //           profileViewModel: null,
            //         ); // if user taps on this dashboard tab will be active
            //         currentTab = 4;
            //       });
            //     },
            //   ),
            // ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: BottomAppBar(
              padding: EdgeInsets.zero,
              color: Colors.white,
              shape: const CircularNotchedRectangle(),
              notchMargin: 5,
              child: Container(
                  color: Colors.white,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Row(
                      //   // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      Builder(
                        builder: (context) {
                          return MaterialButton(
                            minWidth: 40,
                            onPressed: () {
                              setState(() {
                                currentScreen =
                                    // HomePage(); // if user taps on this dashboard tab will be active
                                    widget.userRole == Constants.supplierRoleId
                                        ? const HomePageSupplier()
                                        : const HomePage();
                                currentTab = 0;
                              });
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Icon(
                                //   Icons.home_outlined,
                                //   size: context.appValues.appSize.s25,
                                //   color: currentTab == 0
                                //       ? const Color(0xff9F9AB7)
                                //       : Color(0xff180C39),
                                // ),
                                SvgPicture.asset(
                                  'assets/img/home-new.svg',
                                  fit: BoxFit.contain,
                                  height: context.appValues.appSizePercent.h3,
                                  color: currentTab == 0
                                      ? const Color(0xff9F9AB7)
                                      : const Color(0xff180C39),
                                ),
                                // SizedBox(height: context.appValues.appSize.s5),
                                // Text(
                                //   translate('bottom_bar.home'),
                                //   style: getPrimaryRegularStyle(
                                //     color: currentTab == 0
                                //         ? const Color(0xff9F9AB7)
                                //         : const Color(0xff180C39),
                                //   ),
                                // ),
                              ],
                            ),
                          );
                        }
                      ),
                      Consumer<JobsViewModel>(
                          builder: (context, jobsViewModel, _) {
                        return MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = JobsPage(
                                  userRole: widget.userRole, lang:lang!,initialActiveTab: 'activeJobs', initialIndex: 0,);
                              currentTab = 1;
                            });
                          },
                          child: Container(
                            width: context.appValues.appSizePercent.w9,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      'assets/img/briefcase-new.svg',
                                      fit: BoxFit.contain,
                                      height:
                                          context.appValues.appSizePercent.h3,
                                      color: currentTab == 1
                                          ? const Color(0xff9F9AB7)
                                          : const Color(0xff180C39),
                                    ),
                                    // SizedBox(
                                    //     height: context.appValues.appSize.s5),
                                    // Text(
                                    //   translate('bottom_bar.jobs'),
                                    //   style: getPrimaryRegularStyle(
                                    //     color: currentTab == 1
                                    //         ? const Color(0xff9F9AB7)
                                    //         : const Color(0xff180C39),
                                    //   ),
                                    // ),
                                  ],
                                ),
                                // Notification bubble
                                widget.userRole == Constants.supplierRoleId
                                    ? jobsViewModel.supplierBookedJobs.length >
                                            0
                                        ? Container(
                                            child: Positioned(
                                              right: 0,
                                              bottom: 37,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(4),
                                                decoration: const BoxDecoration(
                                                  color: Colors
                                                      .red, // Choose your preferred background color
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '${jobsViewModel.supplierBookedJobs.length}',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container()
                                    : jobsViewModel.getcustomerJobs
                                                .where(
                                                    (e) => e.status == 'booked')
                                                .toList()
                                                .length >
                                            0
                                        ? Container()
                                        : Container()
                              ],
                            ),
                          ),
                        );
                      }),

                      //   ],
                      // ),

                      // Right Tab bar icons

                      // Row(
                      //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: <Widget>[
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen =
                                const InboxPage(); // if user taps on this dashboard tab will be active
                            currentTab = 2;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/img/chat-new.svg',
                              fit: BoxFit.contain,
                              height: context.appValues.appSizePercent.h3,
                              color: currentTab == 2
                                  ? const Color(0xff9F9AB7)
                                  : const Color(0xff180C39),
                            ),
                            // SizedBox(height: context.appValues.appSize.s5),
                            // Text(
                            //   translate('bottom_bar.inbox'),
                            //   style: getPrimaryRegularStyle(
                            //     color: currentTab == 2
                            //         ? const Color(0xff9F9AB7)
                            //         : const Color(0xff180C39),
                            //   ),
                            // ),
                            // Icon(
                            //   Icons.dashboard,
                            //   color: currentTab == 2 ? Colors.blue : Color(0xff180C39),
                            // ),
                          ],
                        ),
                      ),
                      MaterialButton(
                        minWidth: 40,
                        onPressed: () {
                          setState(() {
                            currentScreen = widget.userRole ==
                                    Constants.supplierRoleId
                                ? Consumer<CategoriesViewModel>(
                                    builder: (context, categoriesViewModel, _) {
                                    return ProfilePageSupplier(
                                        data: data.data,
                                        list:
                                            categoriesViewModel.categoriesList);
                                  })
                                : const ProfilePage();
                            currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/img/profile-new.svg',
                              fit: BoxFit.contain,
                              height: context.appValues.appSizePercent.h3,
                              color: currentTab == 3
                                  ? const Color(0xff9F9AB7)
                                  : const Color(0xff180C39),
                            ),
                            // SizedBox(height: context.appValues.appSize.s5),
                            // Text(
                            //   translate('bottom_bar.profile'),
                            //   style: getPrimaryRegularStyle(
                            //     color: currentTab == 3
                            //         ? const Color(0xff9F9AB7)
                            //         : const Color(0xff180C39),
                            //   ),
                            // ),
                          ],
                        ),
                      )
                    ],
                  )
                  //   ],
                  // ),
                  ),
            ),
          );
        });
  }
}
