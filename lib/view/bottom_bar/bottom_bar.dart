// ignore_for_file: must_be_immutable

import 'package:audioplayers/audioplayers.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/utils/country_helper.dart';
import 'package:dingdone/view/home_page/home_page.dart';
import 'package:dingdone/view/home_page/home_page_supplier.dart';
import 'package:dingdone/view/jobs_page/jobs_page.dart';
import 'package:dingdone/view/profile_page/profile_page.dart';
import 'package:dingdone/view/profile_page_supplier/profile_page_supplier.dart';
import 'package:dingdone/view/services_screen/services_screen.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/country_view_model/country_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui' as ui;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';
import '../edit_account/edit_account.dart';

class BottomBar extends StatefulWidget {
  var userRole;

  var currentTab;
  var initialServicesTabIndex;
  BottomBar({
    super.key,
    required this.userRole,
    required this.currentTab,
    this.initialServicesTabIndex,
  });

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar>
    with SingleTickerProviderStateMixin {
  // Properties & Variables needed
  String? lang;

  // int currentTab = 0;
  late Widget currentScreen;
  final PageStorageBucket bucket = PageStorageBucket();
  final JobsViewModel _jobsViewModel = JobsViewModel();
  bool hasNotifications = true; // Replace with your actual condition
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  String? _currentAddress;
  Position? _currentPosition;
  bool _countryPromptShown = false;
  @override
  void initState() {
    super.initState();
    getLanguage();
    Provider.of<CategoriesViewModel>(context, listen: false).readJson();
    getNotifications();
    _getCurrentPosition();
    _jobsViewModel.readJson();
    currentScreen = widget.currentTab == 0
        ? widget.userRole == Constants.supplierRoleId
            ? const HomePageSupplier()
            : const HomePage()
        : widget.currentTab == 1
            ? widget.initialServicesTabIndex != null
                ? ServicesScreen(
                    initialTabIndex: widget.initialServicesTabIndex)
                : const ServicesScreen(
                    initialTabIndex: 0,
                  )
            : Container();

    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Makes it pulse continuously

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    getProfileInfo();
  }

  bool _isCheckingProfile = false;

  Future<void> getProfileInfo() async {
    if (_isCheckingProfile) return;
    _isCheckingProfile = true;

    final profileViewModel =
        Provider.of<ProfileViewModel>(context, listen: false);
    final profileData = await profileViewModel.getProfiledata();
    if (mounted) {
      final countryViewModel =
          Provider.of<CountryViewModel>(context, listen: false);
      if (!countryViewModel.isLoaded) await countryViewModel.load();
      await profileViewModel.ensureCurrentAddressForCountry(
        countryViewModel,
      );
    }

    _isCheckingProfile = false;

    final user = profileData?["user"];

    final bool isProfileIncomplete = user?["first_name"] == null ||
            user["first_name"].toString().trim().isEmpty ||
            user?["last_name"] == null ||
            user["last_name"].toString().trim().isEmpty ||
            user?["phone"] == null ||
            user["phone"].toString().trim().isEmpty ||
            user?["email"] == null ||
            user["email"].toString().trim().isEmpty
        // ||
        // user?["dob"] == null || user["dob"].toString().trim().isEmpty
        ;

    if (isProfileIncomplete && mounted) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditAccount()),
      );

      if (!mounted) return;

      getProfileInfo();
    }
  }

  getNotifications() async {
    dynamic notifications =
        await Provider.of<JobsViewModel>(context, listen: false)
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

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      debugPrint('current location $position');
      if (!mounted) return;
      setState(() => _currentPosition = position);
      await Provider.of<ProfileViewModel>(context, listen: false)
          .changeCurrentLocation(position.latitude, position.longitude);
      if (!mounted) return;
      await _checkLiveCountry(position);
    } catch (e) {
      debugPrint('error getting position $e');
    }
  }

  Future<SupportedCountry?> _resolveLiveCountry(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final mark = placemarks.first;
        final fromIso = SupportedCountry.fromValue(mark.isoCountryCode);
        if (fromIso != null) return fromIso;
        final fromName = SupportedCountry.fromValue(mark.country);
        if (fromName != null) return fromName;
      }
    } catch (e) {
      debugPrint('reverse geocode for country failed $e');
    }
    // Fallback when placemarks are unavailable or locale-specific.
    return SupportedCountry.fromCoordinates(
      position.latitude,
      position.longitude,
    );
  }

  /// Wait out incomplete-profile / other stacked routes before prompting.
  Future<bool> _waitUntilSafeToPrompt() async {
    for (var attempt = 0; attempt < 30; attempt++) {
      if (!mounted) return false;
      final isTopRoute = ModalRoute.of(context)?.isCurrent == true;
      if (!_isCheckingProfile && isTopRoute) {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        if (!mounted) return false;
        if (!_isCheckingProfile &&
            ModalRoute.of(context)?.isCurrent == true) {
          return true;
        }
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }
    return mounted && ModalRoute.of(context)?.isCurrent == true;
  }

  Future<void> _checkLiveCountry(Position position) async {
    if (_countryPromptShown || !mounted) return;

    final countryViewModel =
        Provider.of<CountryViewModel>(context, listen: false);
    if (countryViewModel.locationPromptHandled) return;
    final selectedName =
        countryViewModel.selectedCountry ?? await countryViewModel.load();
    final selectedCountry = SupportedCountry.fromValue(selectedName);
    if (selectedCountry == null || !mounted) return;

    final liveCountry = await _resolveLiveCountry(position);
    if (liveCountry == selectedCountry) return;

    if (!await _waitUntilSafeToPrompt()) return;
    if (!mounted || _countryPromptShown || countryViewModel.locationPromptHandled) {
      return;
    }
    _countryPromptShown = true;
    countryViewModel.markLocationPromptHandled();

    SupportedCountry? countryToSelect;
    if (liveCountry != null) {
      final shouldSwitch = await _showCountryMismatchDialog(liveCountry);
      if (shouldSwitch == true) countryToSelect = liveCountry;
    } else {
      countryToSelect = await _showOutsideCountriesDialog();
    }

    if (countryToSelect == null || !mounted) return;
    await countryViewModel.selectCountry(countryToSelect.displayName);
    if (!mounted) return;
    await Provider.of<ProfileViewModel>(context, listen: false)
        .ensureCurrentAddressForCountry(countryViewModel);
    if (!mounted) return;
    await Provider.of<CategoriesViewModel>(context, listen: false)
        .getCategoriesAndServices();
  }

  Future<bool?> _showCountryMismatchDialog(
    SupportedCountry liveCountry,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_on_outlined,
              size: 48,
              color: Color(0xff4100E3),
            ),
            const Gap(20),
            Text(
              'country_location.mismatch'.tr(
                namedArgs: {'country': liveCountry.displayName},
              ),
              textAlign: TextAlign.center,
              style: getPrimaryMediumStyle(
                fontSize: 14,
                color: const Color(0xff180B3C),
              ),
            ),
            const Gap(24),
            _dialogButton(
              text: 'country_location.yesSwitch'.tr(),
              onTap: () => Navigator.pop(dialogContext, true),
              filled: true,
            ),
            const Gap(10),
            _dialogButton(
              text: 'country_location.no'.tr(),
              onTap: () => Navigator.pop(dialogContext, false),
              filled: false,
            ),
          ],
        ),
      ),
    );
  }

  Future<SupportedCountry?> _showOutsideCountriesDialog() {
    return showDialog<SupportedCountry>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.location_off_outlined,
              size: 48,
              color: Color(0xff4100E3),
            ),
            const Gap(20),
            Text(
              'country_location.outside'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryMediumStyle(
                fontSize: 14,
                color: const Color(0xff180B3C),
              ),
            ),
            const Gap(24),
            _dialogButton(
              text: 'Qatar',
              onTap: () => Navigator.pop(dialogContext, SupportedCountry.qatar),
              filled: true,
            ),
            const Gap(10),
            _dialogButton(
              text: 'Cyprus',
              onTap: () =>
                  Navigator.pop(dialogContext, SupportedCountry.cyprus),
              filled: true,
            ),
            const Gap(10),
            _dialogButton(
              text: 'country_location.notNow'.tr(),
              onTap: () => Navigator.pop(dialogContext),
              filled: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogButton({
    required String text,
    required VoidCallback onTap,
    required bool filled,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 44,
        width: double.infinity,
        decoration: BoxDecoration(
          color: filled ? const Color(0xff4100E3) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xff4100E3)),
        ),
        child: Center(
          child: Text(
            text,
            style: getPrimarySemiBoldStyle(
              fontSize: 12,
              color: filled ? Colors.white : const Color(0xff4100E3),
            ),
          ),
        ),
      ),
    );
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
                              widget.currentTab = 0;
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
                                widget.currentTab == 0
                                    ? 'assets/img/homeselected.svg'
                                    : 'assets/img/homeunselected.svg',
                                fit: BoxFit.contain,
                                height: context.appValues.appSizePercent.h3,
                              ),
                              SizedBox(height: context.appValues.appSize.s5),
                              Text(
                                'bottom_bar.home'.tr(),
                                style: widget.currentTab == 0
                                    ? getPrimarySemiBoldStyle(
                                        fontSize: 10,
                                        color: const Color(0xff180B3C),
                                      )
                                    : getPrimaryRegularStyle(
                                        fontSize: 10,
                                        color: const Color(0xff71727A),
                                      ),
                              ),
                            ],
                          ),
                        );
                      }),
                      if (widget.userRole != Constants.supplierRoleId)
                        Consumer<JobsViewModel>(
                            builder: (context, jobsViewModel, _) {
                          return MaterialButton(
                            minWidth: 40,
                            onPressed: () {
                              setState(() {
                                currentScreen =
                                    widget.initialServicesTabIndex != null
                                        ? ServicesScreen(
                                            initialTabIndex:
                                                widget.initialServicesTabIndex)
                                        : const ServicesScreen(
                                            initialTabIndex: 0,
                                          );
                                widget.currentTab = 1;
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
                                        widget.currentTab == 1
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
                                        'updateJob.services'.tr(),
                                        style: widget.currentTab == 1
                                            ? getPrimarySemiBoldStyle(
                                                fontSize: 10,
                                                color: const Color(0xff180B3C),
                                              )
                                            : getPrimaryRegularStyle(
                                                fontSize: 10,
                                                color: const Color(0xff71727A),
                                              ),
                                      ),
                                    ],
                                  ),
                                  // Notification bubble
                                  widget.userRole == Constants.supplierRoleId
                                      ? jobsViewModel
                                                  .supplierBookedJobs.length >
                                              0
                                          ? Container(
                                              child: Positioned(
                                                right: 0,
                                                bottom: 37,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration:
                                                      const BoxDecoration(
                                                    color: Colors
                                                        .red, // Choose your preferred background color
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Text(
                                                    '${jobsViewModel.supplierBookedJobs.length}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          : Container()
                                      : jobsViewModel.getcustomerJobs != null
                                          ? jobsViewModel.getcustomerJobs
                                                      .where((e) =>
                                                          e.status == 'booked')
                                                      .toList()
                                                      .length >
                                                  0
                                              ? Container()
                                              : Container()
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
                            widget.currentTab = 2;
                            // hasNotifications = false;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              widget.currentTab == 2
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
                              'bottom_bar.jobs'.tr(),
                              style: widget.currentTab == 2
                                  ? getPrimarySemiBoldStyle(
                                      fontSize: 10,
                                      color: const Color(0xff180B3C),
                                    )
                                  : getPrimaryRegularStyle(
                                      fontSize: 10,
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
                            widget.currentTab = 3;
                          });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              widget.currentTab == 3
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
                              'profile.account'.tr(),
                              style: widget.currentTab == 3
                                  ? getPrimarySemiBoldStyle(
                                      fontSize: 10,
                                      color: const Color(0xff180B3C),
                                    )
                                  : getPrimaryRegularStyle(
                                      fontSize: 10,
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
