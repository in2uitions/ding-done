// ignore_for_file: must_be_immutable

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/home_page/home_page.dart';
import 'package:dingdone/view/home_page/home_page_supplier.dart';
import 'package:dingdone/view/jobs_page/jobs_page.dart';
import 'package:dingdone/view/profile_page/profile_page.dart';
import 'package:dingdone/view/profile_page_supplier/profile_page_supplier.dart';
import 'package:dingdone/view/services_screen/services_screen.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';

class BottomBar extends StatefulWidget {
  var userRole;

  BottomBar({super.key, required this.userRole});

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  // Properties & Variables needed
  String? lang;

  int currentTab = 0;
  late Widget currentScreen;
  final PageStorageBucket bucket = PageStorageBucket();
  final JobsViewModel _jobsViewModel = JobsViewModel();
  bool hasNotifications = true; // Replace with your actual condition
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  String? _currentAddress;
  Position? _currentPosition;
  @override
  void initState() {
    super.initState();
    getLanguage();
    Provider.of<CategoriesViewModel>(context, listen: false).readJson();
    Provider.of<ServicesViewModel>(context, listen: false).readJson();
    getNotifications();
    _handleLocationPermission();
    _getCurrentPosition();
    _jobsViewModel.readJson();
    currentScreen = widget.userRole == Constants.supplierRoleId
        ? const HomePageSupplier()
        : const HomePage();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Makes it pulse continuously

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  getNotifications() async {
    dynamic notifications =
        await Provider.of<ProfileViewModel>(context, listen: false)
            .getNotifications();
    if (notifications != null) {
      if (notifications.isNotEmpty) {
        hasNotifications = true;
      } else {}
    } else {
      hasNotifications = false;
    }
  }

  // Widget currentScreen = HomePage(); // Our first view in viewport
  // Widget currentScreen = HomePageSupplier(); // Our first view in viewport
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    lang ??= 'en-US';
    debugPrint('language in bottom bar $lang');
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    debugPrint('has location permission $hasPermission');
    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      debugPrint('current location $position');
      setState(() => _currentPosition = position);
      // AppPreferences().save(key: currentPositionKey, value: position, isModel: false);
      debugPrint('current location $position');
      Provider.of<ProfileViewModel>(context, listen: false)
          .changeCurrentLocation(position.latitude, position.longitude);
    }).catchError((e) {
      debugPrint('error getting position $e');
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
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
                      Builder(builder: (context) {
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
                                currentTab == 0
                                    ? 'assets/img/homeselected.svg'
                                    : 'assets/img/homeunselected.svg',
                                fit: BoxFit.contain,
                                height: context.appValues.appSizePercent.h3,
                              ),
                              SizedBox(height: context.appValues.appSize.s5),
                              Text(
                                translate('bottom_bar.home'),
                                style: currentTab == 0
                                    ? getPrimaryBoldStyle(
                                        color: const Color(0xff180B3C),
                                      )
                                    : getPrimaryRegularStyle(
                                        color: const Color(0xff71727A),
                                      ),
                              ),
                            ],
                          ),
                        );
                      }),
                      Consumer<JobsViewModel>(
                          builder: (context, jobsViewModel, _) {
                        return MaterialButton(
                          minWidth: 40,
                          onPressed: () {
                            setState(() {
                              currentScreen = ServicesScreen();
                              currentTab = 1;
                            });
                          },
                          child: Container(
                            // width: context.appValues.appSizePercent.w12,
                            child: Stack(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    SvgPicture.asset(
                                      currentTab == 1
                                          ? 'assets/img/serviceselected.svg'
                                          : 'assets/img/servicesunselected.svg',
                                      fit: BoxFit.contain,
                                      height:
                                          context.appValues.appSizePercent.h3,
                                      // color: currentTab == 1
                                      //     ? const Color(0xff6A39E5)
                                      //     : const Color(0xff9d9d9d),
                                    ),
                                    SizedBox(
                                        height: context.appValues.appSize.s5),
                                    Text(
                                      translate('updateJob.services'),
                                      style: currentTab == 1
                                          ? getPrimaryBoldStyle(
                                              color: const Color(0xff180B3C),
                                            )
                                          : getPrimaryRegularStyle(
                                              color: const Color(0xff71727A),
                                            ),
                                    ),
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
                            // currentScreen = InboxPage(
                            //     hasNotifications:
                            //         hasNotifications); // Set InboxPage as the active screen
                            currentScreen = JobsPage(
                              userRole: widget.userRole,
                              lang: lang!,
                              initialActiveTab: 'activeJobs',
                              initialIndex: 0,
                            );
                            currentTab = 2;
                            // hasNotifications = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              currentTab == 2
                                  ? 'assets/img/jobsselected.svg'
                                  : 'assets/img/jobsunselected.svg',
                              fit: BoxFit.contain,
                              height: context.appValues.appSizePercent.h3,
                              // color: currentTab == 2
                              //     ? const Color(0xff6A39E5)
                              //     : const Color(0xff9d9d9d),
                            ),
                            SizedBox(height: context.appValues.appSize.s5),
                            Text(
                              translate('bottom_bar.jobs'),
                              style: currentTab == 2
                                  ? getPrimaryBoldStyle(
                                      color: const Color(0xff180B3C),
                                    )
                                  : getPrimaryRegularStyle(
                                      color: const Color(0xff71727A),
                                    ),
                            ),
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
                              currentTab == 3
                                  ? 'assets/img/profileselected.svg'
                                  : 'assets/img/profileunselected.svg',
                              fit: BoxFit.contain,
                              height: context.appValues.appSizePercent.h3,
                              // color: currentTab == 3
                              //     ? const Color(0xff6A39E5)
                              //     : const Color(0xff9d9d9d),
                            ),
                            SizedBox(height: context.appValues.appSize.s5),
                            Text(
                              translate('profile.account'),
                              style: currentTab == 3
                                  ? getPrimaryBoldStyle(
                                      color: const Color(0xff180B3C),
                                    )
                                  : getPrimaryRegularStyle(
                                      color: const Color(0xff71727A),
                                    ),
                            ),
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
