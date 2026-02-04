// ignore_for_file: use_build_context_synchronously

import 'package:audioplayers/audioplayers.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/categories/parent_categories.dart';
import 'package:dingdone/view/notifications_screen/notifications_screen.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../res/constants.dart';
import '../book_a_service/book_a_service.dart';
import '../bottom_bar/bottom_bar.dart';
import '../categories_screen/categories_screen.dart';
import '../my_address_book/my_address_book.dart';
import '../widgets/categories_screen/categories_screen_cards.dart';
import '../widgets/pulsing_dot/pulsing_dot.dart';
import '../widgets/update_job_request_customer/rating_stars_widget.dart';
import '../widgets/update_job_request_customer/review_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

String? lang;

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredServices = [];
  List<dynamic> featuredServices = [];
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    getLanguage();
    _getCustomerJobs();

    Provider.of<CategoriesViewModel>(context, listen: false)
        .getCategoriesAndServices();
    // Provider.of<CategoriesViewModel>(context, listen: false).sortCategories(
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    // searchController.addListener(_filterServices);
    // Initially display all services
    filteredServices = categoriesViewModel.servicesList2;

    setState(() {});
  }

  @override
  void dispose() {
    // searchController.removeListener(_filterServices);
    searchController.dispose();
    super.dispose();
  }

  Future<void> _getCustomerJobs() async {
    await Provider.of<JobsViewModel>(context, listen: false).getCustomerJobs();
    var jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
    debugPrint(
        'completed jobs in bottom bafr ${jobsViewModel.getcustomerJobs}');

    dynamic completedJobs = jobsViewModel.getcustomerJobs
        .where((e) => e.status == 'completed' && e.rating_stars == null)
        .toList();
    for (var i in jobsViewModel.getcustomerJobs) {
      debugPrint('completed jobs ${i.status} ${i.rating_stars}');
    }
    debugPrint('completed jobs $completedJobs');
    if (completedJobs.isNotEmpty)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showReviewDialog(context, completedJobs[0], jobsViewModel);
      });
  }

  Future<void> playSound() async {
    String soundPath =
        "DingDone Hybrid.wav"; // Update with the actual path to your .wav file

    await _audioPlayer.play(AssetSource(soundPath));
  }

  void _showReviewDialog(
      BuildContext context, dynamic job, JobsViewModel jobsViewModel) {
    playSound();
    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing by tapping outside
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Prevents back button closing
          child: review(context, job, jobsViewModel),
        );
      },
    );
  }

  Widget review(
      BuildContext context, dynamic job, JobsViewModel jobsViewModel) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
             'updateJob.rateJob'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              job.service != null
                  ? job.service['translations'][0]['title']
                  : '',
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s10),
          RatingStarsWidget(
            stars: jobsViewModel.updatedBody != null &&
                    jobsViewModel.updatedBody["rating_stars"] != null
                ? jobsViewModel.updatedBody["rating_stars"]
                : 0,
            userRole: Constants.customerRoleId,
          ),
          ReviewWidget(
            review: job.rating_comment ?? '',
          ),
          SizedBox(height: context.appValues.appSize.s10),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p8,
                ),
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (await jobsViewModel.rateJob(job.id) == true) {
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(seconds: 0));
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogFailure(context,
                                    'Please make sure to rate the job'));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: const Color(0xffFFD105),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(
                        context.appValues.appSizePercent.w30,
                        context.appValues.appSizePercent.h5,
                      ),
                    ),
                    child: Text(
                      'button.ok'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.btnColorBlue,
                      ),
                    ),
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p8,
                ),
                child: Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () async {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      backgroundColor: const Color(0xff4100E3),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: Size(
                        context.appValues.appSizePercent.w30,
                        context.appValues.appSizePercent.h5,
                      ),
                    ),
                    child: Text(
                      'button.cancel'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: context.appValues.appSize.s20),
        ],
      ),
    );
  }

  Widget _buildPopupDialogFailure(BuildContext context, String message) {
    return AlertDialog(
      elevation: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: SvgPicture.asset('assets/img/x.svg'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              'button.failure'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                  fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 15,
                color: context.resources.color.secondColorBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _filterServices(String searchText) async {
    // String searchText = searchController.text.toLowerCase();
    String searchText0 = searchText.toLowerCase();
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    await categoriesViewModel.searchData(
        index: 'search_services', value: searchText0);
    debugPrint('categories search result ${categoriesViewModel.servicesList2}');
    setState(() {
      // if (_searchText.isEmpty) {
      // Display all services if search text is empty
      filteredServices = categoriesViewModel.servicesList2;
      // } else {
      //   filteredServices = categoriesViewModel.servicesList2;
      // }
    });
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    if (lang == null) {
      setState(() {
        lang = 'en-US';
      });
    }
  }

  Future<void> _handleRefresh() async {
    try {
      String? role =
          await AppPreferences().get(key: userRoleKey, isModel: false);
      // Simulate network fetch or database query
      await Future.delayed(const Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.of(context).push(_createRoute(BottomBar(
        userRole: role,
        currentTab: 0,
      )));
      Provider.of<CategoriesViewModel>(context, listen: false).readJson();
      Provider.of<CategoriesViewModel>(context, listen: false).sortCategories(
          Provider.of<ServicesViewModel>(context, listen: false)
              .searchBody['search_services']);
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  final List<String> imgList = [
    'https://via.placeholder.com/800x400.png?text=Image+1',
    'https://via.placeholder.com/800x400.png?text=Image+2',
    'https://via.placeholder.com/800x400.png?text=Image+3',
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer4<ProfileViewModel, ServicesViewModel, CategoriesViewModel,
            JobsViewModel>(
        builder: (context, profileViewModel, servicesViewModel,
            categoriesViewModel, jobsViewModel, _) {
      featuredServices = categoriesViewModel.getItDoneData.toList();
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffFEFEFE),
        // drawer: Drawer(
        //   child: Container(
        //     color: Colors.white,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         const Gap(120),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/img/orderHistory.svg',
        //                 width: context.appValues.appSizePercent.w4,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.orderHistory'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () {
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(
        //                 builder: (context) => JobsPage(
        //                   userRole: Constants.customerRoleId,
        //                   lang: lang!,
        //                   initialActiveTab: 'completedJobs',
        //                   initialIndex: 3,
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/img/addressBook.svg',
        //                 width: context.appValues.appSizePercent.w4,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.myAddressBook'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () {
        //             Navigator.of(context).push(_createRoute(ConfirmAddress()));
        //           },
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/img/headphone.svg',
        //                 width: context.appValues.appSizePercent.w5,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.support'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () {
        //             // Handle Help! tap
        //             // Navigator.pop(context);
        //             jobsViewModel.launchWhatsApp();
        //           },
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/img/aboutDingDone.svg',
        //                 width: context.appValues.appSizePercent.w5,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.aboutDingDone'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () {
        //             // Handle About DingDone tap
        //             Navigator.of(context).push(_createRoute(About()));
        //           },
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/img/termofuse.svg',
        //                 width: context.appValues.appSizePercent.w5,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.termsAndConditions'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () {
        //             // Handle Terms and Conditions tap
        //             Navigator.of(context)
        //                 .push(_createRoute(UserAgreement(index: null)));
        //           },
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               const Icon(
        //                 Icons.language,
        //                 size: 20,
        //                 color: Colors.deepPurple,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.chooseLanguage'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () => _onActionSheetPress(context),
        //         ),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: const Divider(
        //             height: 25,
        //             thickness: 2,
        //             color: Color(0xffEAEAFF),
        //           ),
        //         ),
        //         ListTile(
        //           title: Row(
        //             children: [
        //               const Icon(
        //                 Icons.delete,
        //                 size: 20,
        //                 color: Colors.deepPurple,
        //               ),
        //               const Gap(10),
        //               Text(
        //                 translate('drawer.deleteAccount'),
        //                 style: getPrimaryRegularStyle(
        //                   fontSize: 16,
        //                   color: const Color(0xff1F1F39),
        //                 ),
        //               ),
        //             ],
        //           ),
        //           onTap: () async {
        //             // Show a confirmation dialog before executing deletion
        //             final bool? confirmed = await showDialog<bool>(
        //               context: context,
        //               builder: (BuildContext context) {
        //                 return AlertDialog(
        //                   backgroundColor: Colors.white,
        //                   title: const Text('Confirm Deletion'),
        //                   content: const Text(
        //                       'Are you sure you want to delete your account?'),
        //                   actions: <Widget>[
        //                     TextButton(
        //                       onPressed: () => Navigator.of(context).pop(false),
        //                       child: const Text('Cancel'),
        //                     ),
        //                     TextButton(
        //                       onPressed: () => Navigator.of(context).pop(true),
        //                       child: const Text('Yes'),
        //                     ),
        //                   ],
        //                 );
        //               },
        //             );

        //             if (confirmed == true) {
        //               // Execute deletion logic if the user confirmed
        //               await profileViewModel.patchUserData({'status': 'draft'});
        //               String? lang = await AppPreferences()
        //                   .get(key: language, isModel: false);
        //               AppPreferences().clear();
        //               AppProviders.disposeAllDisposableProviders(context);
        //               Navigator.of(context)
        //                   .push(_createRoute(const LoginScreen()));
        //               await AppPreferences()
        //                   .save(key: language, value: lang, isModel: false);
        //               if (lang == null) {
        //                 lang = "en";
        //                 await AppPreferences()
        //                     .save(key: language, value: "en", isModel: false);
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'en-US', isModel: false);
        //               }
        //               if (lang == 'en') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'en-US', isModel: false);
        //               }
        //               if (lang == 'ar') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'ar-SA', isModel: false);
        //               }
        //               if (lang == 'ru') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'ru-RU', isModel: false);
        //               }
        //               if (lang == 'el') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'el-GR', isModel: false);
        //               }
        //             }
        //           },
        //         ),
        //         const Spacer(),
        //         Padding(
        //           padding: EdgeInsets.only(
        //             top: context.appValues.appPadding.p5,
        //             left: context.appValues.appPadding.p15,
        //             right: context.appValues.appPadding.p15,
        //           ),
        //           child: InkWell(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.end,
        //               children: [
        //                 Row(
        //                   mainAxisAlignment: MainAxisAlignment.end,
        //                   children: [
        //                     SvgPicture.asset(
        //                       'assets/img/logout.svg',
        //                       width: context.appValues.appSizePercent.w4,
        //                     ),
        //                     const Gap(10),
        //                     Text(
        //                       translate('profile.logOut'),
        //                       style: getPrimaryRegularStyle(
        //                         fontSize: 16,
        //                         color: const Color(0xff78789D),
        //                       ),
        //                     ),
        //                   ],
        //                 ),
        //                 const Gap(50)
        //               ],
        //             ),
        //             onTap: () async {
        //               String? lang = await AppPreferences()
        //                   .get(key: language, isModel: false);
        //               AppPreferences().clear();
        //               AppProviders.disposeAllDisposableProviders(context);
        //               Navigator.of(context)
        //                   .push(_createRoute(const LoginScreen()));
        //               await AppPreferences()
        //                   .save(key: language, value: lang, isModel: false);
        //               if (lang == null) {
        //                 lang = "en";
        //                 await AppPreferences()
        //                     .save(key: language, value: "en", isModel: false);
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'en-US', isModel: false);
        //               }

        //               if (lang == 'en') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'en-US', isModel: false);
        //               }
        //               if (lang == 'ar') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'ar-SA', isModel: false);
        //               }
        //               if (lang == 'ru') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'ru-RU', isModel: false);
        //               }
        //               if (lang == 'el') {
        //                 await AppPreferences()
        //                     .save(key: dblang, value: 'el-GR', isModel: false);
        //               }
        //             },
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Container(
            color: const Color(0xff4100E3),
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // Header with back button and title
                      Stack(
                        children: [
                          // Background image
                          Container(
                            width: context.appValues.appSizePercent.w100,
                            height: context.appValues.appSizePercent.h50,
                            decoration: const BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage('assets/img/homepagebg.png'),
                              //   fit: BoxFit.cover,
                              // ),
                              color: Color(0xff4100E3),
                            ),
                          ),
                          // Gradient overlay
                          Padding(
                            padding: EdgeInsets.only(
                              top: context.appValues.appPadding.p8,
                              left: context.appValues.appPadding.p20,
                              right: context.appValues.appPadding.p20,
                            ),
                            child: SafeArea(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          // IconButton(
                                          //   icon: Icon(
                                          //     Icons.menu,
                                          //     size: 30,
                                          //     color: context
                                          //         .resources.color.colorWhite,
                                          //   ),
                                          //   onPressed: () {
                                          //     _scaffoldKey.currentState
                                          //         ?.openDrawer();
                                          //   },
                                          // ),
                                          const Gap(7),
                                          Row(
                                            children: [
                                              Text(
                                                profileViewModel.getProfileBody[
                                                            "user"] !=
                                                        null
                                                    ? '${'home_screen.Hi'.tr()} '
                                                    : '',
                                                style: getPrimarySemiBoldStyle(
                                                  color:
                                                      const Color(0xffFFC500),
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text(
                                                profileViewModel.getProfileBody[
                                                            "user"] !=
                                                        null
                                                    ? '${profileViewModel.getProfileBody["user"]["first_name"]}'
                                                    : '',
                                                style: getPrimarySemiBoldStyle(
                                                  color: context.resources.color
                                                      .colorWhite,
                                                  fontSize: 24,
                                                ),
                                              ),
                                              Text(
                                                profileViewModel.getProfileBody[
                                                            "user"] !=
                                                        null
                                                    ? '!'
                                                    : '',
                                                style: getPrimaryBoldStyle(
                                                  color:
                                                      const Color(0xffFFC500),
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),

                                      Stack(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context)
                                                  .push(
                                                _createRoute(
                                                  NotificationsScreen(
                                                      jobsViewModel:
                                                          jobsViewModel),
                                                ),
                                              )
                                                  .then((_) {
                                                setState(
                                                    () {}); // Triggers rebuild after pop
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              jobsViewModel.hasNotifications
                                                  ? 'assets/img/notification.svg'
                                                  : 'assets/img/white-bell.svg',
                                              color:
                                                  jobsViewModel.hasNotifications
                                                      ? const Color(0xffFFC500)
                                                      : null,
                                            ),
                                          ),
                                          // if (profileViewModel.hasNotifications)
                                          //   Positioned(
                                          //     right: 0,
                                          //     top: 0,
                                          //     child: PulsingDot(),
                                          //   ),
                                        ],
                                      ),
                                      // Container(
                                      //   width:
                                      //       context.appValues.appSizePercent.w10p5,
                                      //   height:
                                      //       context.appValues.appSizePercent.h5p1,
                                      //   decoration: BoxDecoration(
                                      //     borderRadius: BorderRadius.circular(50),
                                      //     image: DecorationImage(
                                      //       fit: BoxFit.cover,
                                      //       image: NetworkImage(
                                      //         profileViewModel.getProfileBody[
                                      //                         'user'] !=
                                      //                     null &&
                                      //                 profileViewModel
                                      //                             .getProfileBody[
                                      //                         'user']['avatar'] !=
                                      //                     null
                                      //             ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                                      //             : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          context.appValues.appPadding.p7,
                                      vertical:
                                          context.appValues.appPadding.p15,
                                    ),
                                    child: TextFormField(
                                      controller: searchController,
                                      onChanged: (value) {
                                        _filterServices(searchController.text);
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: const Color(0xffEAEAFF),
                                        prefixIcon: const Icon(
                                          Icons.search,
                                          color: Color(0xFF6E6BE8),
                                        ),
                                        hintText:
                                            'home_screen.hintSearch'.tr(),
                                        hintStyle: getPrimaryRegularStyle(
                                          color: const Color(0xFF6E6BE8),
                                          fontSize: 14,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: BorderSide.none,
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          borderSide: const BorderSide(
                                            color: Color(0xFF6E6BE8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      // Navigator.of(context).push(
                                      //   _createRoute(ConfirmAddress()),
                                      // );
                                      _onActionSheetPress(context);
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p7,
                                        vertical:
                                            context.appValues.appPadding.p5,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              // Location SVG icon
                                              SvgPicture.asset(
                                                'assets/img/location_white.svg',
                                                width: 20,
                                                height: 20,
                                                // color: const Color(0xffFFC500),
                                              ),
                                              const Gap(10),
                                              // Column with a title and the current location or hint
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    // '${profileViewModel
                                                    //     .getProfileBody['current_address']["street_number"]} ${profileViewModel
                                                    //     .getProfileBody['current_address']["building_number"]}, ${profileViewModel
                                                    //     .getProfileBody['current_address']['apartment_number']}, ${profileViewModel
                                                    //     .getProfileBody['current_address']["floor"]}',
                                                    profileViewModel.getProfileBody !=
                                                                null &&
                                                            profileViewModel
                                                                        .getProfileBody[
                                                                    'current_address'] !=
                                                                null
                                                        ? '${profileViewModel.getProfileBody['current_address']["address_label"]}'
                                                        : '',

                                                    style:
                                                        getPrimaryRegularStyle(
                                                      fontSize: 16,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          // Trailing arrow icon
                                          const Icon(
                                            Icons.keyboard_arrow_down_sharp,
                                            size: 20,
                                            color: const Color(0xffFFC500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  searchController.text.isEmpty
                      ? DraggableScrollableSheet(
                          initialChildSize: 0.75,
                          minChildSize: 0.75,
                          maxChildSize: 1,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                color: Color(0xffFEFEFE),
                              ),
                              child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: 1,
                                  padding: EdgeInsets.zero,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p10,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // servicesViewModel.chosenParent
                                                //     ? translate(
                                                //         'home_screen.servicesCategories')
                                                //     :
                                                'updateJob.services'.tr(),
                                                style: getPrimarySemiBoldStyle(
                                                  fontSize: 16,
                                                  color: context.resources.color
                                                      .btnColorBlue,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () {},
                                              //   child: Row(
                                              //     children: [
                                              //       Text(
                                              //         translate(
                                              //             'home_screen.seeAll'),
                                              //         style: getPrimaryBoldStyle(
                                              //           fontSize: 12,
                                              //           color:
                                              //               const Color(0xff4100E3),
                                              //         ),
                                              //       ),
                                              //       const Gap(5),
                                              //       const Icon(
                                              //         Icons.arrow_forward_ios_sharp,
                                              //         color: Color(0xff4100E3),
                                              //         size: 12,
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                              // servicesViewModel.chosenParent
                                              //     ? InkWell(
                                              //         child: Text(
                                              //           translate(
                                              //               'home_screen.seeAll'),
                                              //           style: getPrimaryBoldStyle(
                                              //             fontSize: 18,
                                              //             color: const Color(
                                              //                 0xff9E9BB8),
                                              //           ),
                                              //         ),
                                              //         onTap: () {
                                              //           Navigator.of(context)
                                              //               .push(_createRoute(
                                              //             CategoriesScreen(
                                              //                 categoriesViewModel:
                                              //                     categoriesViewModel,
                                              //                 initialTabIndex: 0,
                                              //                 serviceViewModel:
                                              //                     servicesViewModel),
                                              //           ));
                                              //         },
                                              //       )
                                              //     : Container(),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            String? role =
                                                await AppPreferences().get(
                                                    key: userRoleKey,
                                                    isModel: false);
                                            // Simulate network fetch or database query
                                            await Future.delayed(
                                                const Duration(seconds: 2));
                                            // Update the list of items and refresh the UI
                                            Navigator.of(context)
                                                .push(_createRoute(BottomBar(
                                              userRole: role,
                                              currentTab: 1,
                                            )));
                                          },
                                          child: ParentCategoriesWidget(
                                              servicesViewModel:
                                                  servicesViewModel),
                                        ),
                                        // servicesViewModel.chosenParent
                                        //     ? CategoriesWidget(
                                        //         servicesViewModel:
                                        //             servicesViewModel)
                                        //     : ParentCategoriesWidget(
                                        //         servicesViewModel:
                                        //             servicesViewModel),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context
                                                .appValues.appPadding.p20,
                                          ),
                                          child: const Divider(
                                            color: Color(0xffD4D6DD),
                                            height: 1,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p20,
                                            context.appValues.appPadding.p20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                // servicesViewModel.searchBody["search_services"] != null &&
                                                //     servicesViewModel.searchBody["search_services"] != ''
                                                //     ? servicesViewModel.searchBody["search_services"]
                                                //     :

                                                    'home_screen.getItDone'.tr(),
                                                style: getPrimarySemiBoldStyle(
                                                  fontSize: 16,
                                                  color: context.resources.color
                                                      .btnColorBlue,
                                                ),
                                              ),
                                              // InkWell(
                                              //   onTap: () {
                                              //     Navigator.of(context)
                                              //         .push(_createRoute(
                                              //       BottomBar(
                                              //         userRole: Constants
                                              //             .customerRoleId,
                                              //         currentTab: 1,
                                              //       ),
                                              //     ));
                                              //   },
                                              //   child: Row(
                                              //     children: [
                                              //       Text(
                                              //         translate(
                                              //             'home_screen.seeAll'),
                                              //         style:
                                              //             getPrimarySemiBoldStyle(
                                              //           fontSize: 12,
                                              //           color: const Color(
                                              //               0xff4100E3),
                                              //         ),
                                              //       ),
                                              //       const Gap(5),
                                              //       const Icon(
                                              //         Icons
                                              //             .arrow_forward_ios_sharp,
                                              //         color: Color(0xff4100E3),
                                              //         size: 12,
                                              //       ),
                                              //     ],
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: context
                                                .appValues.appPadding.p20,
                                          ),
                                          child: Column(
                                            children: [
                                              Stack(
                                                children: [
                                                  CarouselSlider(
                                                    options: CarouselOptions(
                                                      height: 200,
                                                      autoPlay: true,
                                                      enlargeCenterPage: true,
                                                      viewportFraction: 1.0,
                                                      autoPlayAnimationDuration: const Duration(milliseconds: 700),
                                                      onPageChanged: (index, reason) {
                                                        setState(() {
                                                          _current = index;
                                                        });
                                                      },
                                                    ),
                                                    items: featuredServices.map((service) {
                                                      dynamic trans;
                                                      dynamic imageUrl;

                                                      if (service != null) {
                                                        imageUrl = service['featured_image'] != null
                                                            ? '${context.resources.image.networkImagePath2}${service['featured_image']['filename_disk']}'
                                                            : 'https://via.placeholder.com/800x400';
                                                      }

                                                      return GestureDetector(
                                                        onTap: () async {
                                                          final parentCategory = service["parent_category"];
                                                          final subCategory = service["sub_category"];
                                                          final serviceId = service["service"];
                                                          final externalLink = service["external_link"];

                                                          // 1️⃣ If parent_category exists → Go to BottomBar
                                                          if (parentCategory != null) {

                                                            // Safely extract translations
                                                            List translations = parentCategory['translations'] as List? ?? [];
                                                            trans = translations.isNotEmpty
                                                                ? translations.firstWhere(
                                                                  (t) => t['languages_code'] == lang,
                                                              orElse: () => translations.first,
                                                            )
                                                                : {"title": ""};

                                                            // Find the REAL index inside parentCategoriesList
                                                            final categoriesViewModel =
                                                            Provider.of<CategoriesViewModel>(context, listen: false);

                                                            int realIndex = categoriesViewModel.parentCategoriesList.indexWhere(
                                                                  (item) => item["id"] == parentCategory["id"],
                                                            );

                                                            if (realIndex == -1) realIndex = 0; // fallback to prevent crashes

                                                            // Apply your filters EXACTLY like before
                                                            servicesViewModel.setParentCategoryExistence(true);
                                                            servicesViewModel.filterData(
                                                                index: 'search_services', value: trans["title"]);
                                                            servicesViewModel.setInputValues(
                                                                index: 'search_services', value: trans["title"]);
                                                            servicesViewModel.setParentCategory(trans["title"]);
                                                            categoriesViewModel.sortCategories(trans["title"]);

                                                            Navigator.of(context).push(
                                                              _createRoute(
                                                                BottomBar(
                                                                  userRole: Constants.customerRoleId,
                                                                  currentTab: 1,
                                                                  initialServicesTabIndex: realIndex,
                                                                ),
                                                              ),
                                                            );

                                                            return;
                                                          }

                                                          // 2️⃣ If sub_category exists → Go to CategoriesScreen
                                                          if (subCategory != null) {

                                                            // Safely extract translations
                                                            List translations = subCategory['translations'] as List? ?? [];
                                                            trans = translations.isNotEmpty
                                                                ? translations.firstWhere(
                                                                  (t) => t['languages_code'] == lang,
                                                              orElse: () => translations.first,
                                                            )
                                                                : {"title": ""};

                                                            // Access CategoriesViewModel
                                                            final categoriesViewModel =
                                                            Provider.of<CategoriesViewModel>(context, listen: false);

                                                            // Find REAL index of this subcategory inside categoriesList
                                                            int realIndex = categoriesViewModel.categoriesList.indexWhere(
                                                                  (item) => item["id"] == subCategory["id"],
                                                            );

                                                            if (realIndex == -1) realIndex = 0; // fallback safe

                                                            // Apply your internal filters
                                                            servicesViewModel.filterData(
                                                              index: 'search_services',
                                                              value: trans["title"],
                                                            );
                                                            servicesViewModel
                                                                .setParentCategory(trans["title"]);

                                                            Navigator.of(context).push(
                                                              _createRoute(
                                                                CategoriesScreen(
                                                                  categoriesViewModel: categoriesViewModel,
                                                                  initialTabIndex: realIndex,
                                                                  serviceViewModel: servicesViewModel,
                                                                ),
                                                              ),
                                                            );

                                                            return;
                                                          }


                                                          // 3️⃣ If service exists → Go to BookAService
                                                          if (serviceId != null) {
                                                            trans = (serviceId['translations'] as List)
                                                                .cast<Map<String, dynamic>>()
                                                                .firstWhere(
                                                                  (t) => t['languages_code'] == lang,
                                                              orElse: () => serviceId['translations'][0],
                                                            );
                                                            jobsViewModel.setInputValues(index: 'service', value: service["id"]);
                                                            jobsViewModel.setInputValues(
                                                              index: 'job_address',
                                                              value: profileViewModel.getProfileBody['current_address'],
                                                            );

                                                            jobsViewModel.setInputValues(
                                                              index: 'address',
                                                              value:
                                                              '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
                                                            );
                                                            jobsViewModel.setInputValues(
                                                                index: 'latitude',
                                                                value: profileViewModel.getProfileBody['current_address']['latitude']);
                                                            jobsViewModel.setInputValues(
                                                                index: 'longitude',
                                                                value: profileViewModel.getProfileBody['current_address']['longitude']);
                                                            jobsViewModel.setInputValues(index: 'payment_method', value: 'Card');
                                                            // jobsViewModel.setInputValues(index: 'number_of_units',value:service['country_rates'][0]['minimum_order'].toString() );
                                                            servicesViewModel
                                                                .setParentCategory(trans["title"]);
                                                            debugPrint('service id $serviceId');
                                                            debugPrint('lang service id $lang');
                                                            debugPrint('image service id ${serviceId["image"]}');
                                                            debugPrint('translations service id ${serviceId["translations"][0]['languages_code']}');
                                                            Navigator.of(context).push(
                                                              _createRoute(
                                                                BookAService(
                                                                  service: serviceId,
                                                                  lang: lang,
                                                                  image: serviceId["image"] != null
                                                                      ? '${context.resources.image.networkImagePath2}${serviceId["image"]["filename_disk"]}'
                                                                      : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
                                                                ),
                                                              ),
                                                            );
                                                            return;
                                                          }

                                                          // 4️⃣ If external link exists → Launch URL
                                                          if (externalLink != null && externalLink.isNotEmpty) {
                                                            if (await canLaunch(externalLink)) {
                                                              await launch(externalLink);
                                                            } else {
                                                              debugPrint('Could not launch external link.');
                                                            }
                                                            return;
                                                          }

                                                          debugPrint("No valid navigation action found.");
                                                        },
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(20),
                                                            image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(imageUrl),
                                                            ),
                                                          ),
                                                          child: Stack(
                                                            children: [
                                                              Positioned(
                                                                bottom: 0,
                                                                child: Padding(
                                                                  padding: EdgeInsets.symmetric(
                                                                    horizontal: context.appValues.appPadding.p0,
                                                                  ),
                                                                  child: Container(
                                                                    width: context.appValues.appSizePercent.w90,
                                                                    height: 200,
                                                                    decoration: BoxDecoration(
                                                                      gradient: LinearGradient(
                                                                        begin: Alignment.bottomCenter,
                                                                        end: Alignment.topCenter,
                                                                        colors: [
                                                                          Colors.black.withOpacity(0.2),
                                                                          Colors.black.withOpacity(0.1),
                                                                        ],
                                                                      ),
                                                                      borderRadius: BorderRadius.circular(20),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),

                                                              service['show_featured_services_title'] == true
                                                                  ? Align(
                                                                alignment: Alignment.bottomLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets.only(
                                                                    left: context.appValues.appPadding.p10,
                                                                    bottom: context.appValues.appPadding.p35,
                                                                  ),
                                                                  child: Text(
                                                                    trans['title'] ?? '',
                                                                    style: getPrimarySemiBoldStyle(
                                                                      fontSize: 20,
                                                                      color: context.resources.color.colorWhite,
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                                  : Container(),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                  Positioned(
                                                    bottom: 10,
                                                    left: 0,
                                                    right: 0,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: imgList
                                                          .asMap()
                                                          .entries
                                                          .map((entry) {
                                                        return GestureDetector(
                                                          onTap: () =>
                                                              _controller
                                                                  .animateToPage(
                                                                      entry
                                                                          .key),
                                                          child: Container(
                                                            width: 5.0,
                                                            height: 5.0,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        8.0,
                                                                    horizontal:
                                                                        4.0),
                                                            decoration:
                                                                BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color: _current ==
                                                                      entry.key
                                                                  ? const Color(
                                                                      0xffFFC500)
                                                                  : const Color(
                                                                      0xff180B3C),
                                                            ),
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const Gap(10),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: context
                                                      .appValues.appPadding.p20,
                                                ),
                                                child: const Divider(
                                                  color: Color(0xffD4D6DD),
                                                  height: 40,
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    // Center(
                                                    //   child: Text(
                                                    //     translate(
                                                    //         'home_screen.availability'),
                                                    //     textAlign:
                                                    //         TextAlign.center,
                                                    //     style:
                                                    //         getPrimaryRegularStyle(
                                                    //       fontSize: 14,
                                                    //       color: const Color(
                                                    //           0xff71727A),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    // const Gap(15),
                                                    InkWell(
                                                      onTap: () {
                                                        jobsViewModel
                                                            .launchWhatsApp();
                                                      },
                                                      child: Container(
                                                        width: 127,
                                                        height: 44,
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                          horizontal: context
                                                              .appValues
                                                              .appPadding
                                                              .p0,
                                                          vertical: context
                                                              .appValues
                                                              .appPadding
                                                              .p0,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color(
                                                              0xff25D366),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SvgPicture.asset(
                                                                  'assets/img/wp.svg'),
                                                              const Gap(5),
                                                              Text(
                                                                'settings.contactUs'.tr(),
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style:
                                                                    getPrimarySemiBoldStyle(
                                                                  color: context
                                                                      .resources
                                                                      .color
                                                                      .colorWhite,
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const Gap(10),
                                              Container(
                                                width: context.appValues
                                                    .appSizePercent.w50,
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                color: Colors.white,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    IconButton(
                                                      icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .tiktok),
                                                      color: const Color(
                                                          0xff8F9098),
                                                      onPressed: () async {
                                                        // Handle Facebook tap
                                                        if (await canLaunch(
                                                            'https://www.tiktok.com/@itsdingdone')) {
                                                          await launch(
                                                              'https://www.tiktok.com/@itsdingdone');
                                                        } else {
                                                          debugPrint(
                                                              'Could not launch tiktok.');
                                                        }
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .facebook),
                                                      color: const Color(
                                                          0xff8F9098),
                                                      onPressed: () async {
                                                        // Handle Instagram tap
                                                        if (await canLaunch(
                                                            'https://www.facebook.com/share/1F4rNiwE7d/?mibextid=wwXIfr')) {
                                                          await launch(
                                                              'https://www.facebook.com/share/1F4rNiwE7d/?mibextid=wwXIfr');
                                                        } else {
                                                          debugPrint(
                                                              'Could not launch facebook.');
                                                        }
                                                      },
                                                    ),
                                                    IconButton(
                                                      icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .instagram),
                                                      color: const Color(
                                                          0xff8F9098),
                                                      onPressed: () async {
                                                        // Handle Instagram tap
                                                        if (await canLaunch(
                                                            'https://www.instagram.com/itsdingdone')) {
                                                          await launch(
                                                              'https://www.instagram.com/itsdingdone');
                                                        } else {
                                                          debugPrint(
                                                              'Could not launch instagram.');
                                                        }
                                                      },
                                                    ),

                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          })
                      : DraggableScrollableSheet(
                          initialChildSize: 0.70,
                          minChildSize: 0.70,
                          maxChildSize: 1,
                          builder: (BuildContext context,
                              ScrollController scrollController) {
                            return Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30),
                                  ),
                                  color: Color(0xffFEFEFE),
                                ),
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: filteredServices.length,
                                  itemBuilder: (context, index) {
                                    var service = filteredServices[index];

                                    // Find the translation where language_code == lang
                                    // var lang = 'ar-SA'; // Replace this with the actual language code you're using
                                    var translation =
                                        service['translations'].firstWhere(
                                      (t) => t['languages_code'] == lang,
                                      orElse: () => null,
                                    );

                                    // If no translation is found, fallback to default
                                    if (translation == null) {
                                      translation = {
                                        'title': service["xtitle"] ?? '',
                                        'description':
                                            service["xdescription"] ?? ''
                                      };
                                    }
                                    debugPrint('translation si $translation');
                                    final rate = service['country_rates'][0];
                                    final cost =
                                        '${rate['unit_rate']} ${rate['country']['currency']}';
                                    return Consumer2<JobsViewModel,
                                        ProfileViewModel>(
                                      builder: (context, jobsViewModel,
                                          profileViewModel, _) {
                                        return CategoriesScreenCards(
                                          category: service["category"],
                                          title: translation != null
                                              ? translation["title"]
                                              : '',
                                          cost: cost,
                                          // '${service["country_rates"][0]["unit_rate"]} ${service["country_rates"][0]["country"]["curreny"]}',
                                          image: service["image"] != null
                                              ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                              : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                          onTap: () {
                                            _handleServiceSelection(
                                                service,
                                                jobsViewModel,
                                                profileViewModel);
                                          },
                                        );
                                      },
                                    );
                                  },
                                )

                                // child: ListView.builder(
                                //   controller: scrollController,
                                //   itemCount: filteredServices.length,
                                //   itemBuilder: (BuildContext context, int index) {
                                //     var service = filteredServices[index];
                                //     return ListTile(
                                //       title: Text(service.title),
                                //       subtitle: Text(service!=null && service.description !=null ?service.description:''),
                                //     );
                                //   },
                                // ),
                                );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _handleServiceSelection(dynamic service, JobsViewModel jobsViewModel,
      ProfileViewModel profileViewModel) {
    // Logic to handle service selection and navigation to next screen
    if (lang == null) {
      lang = 'en-US';
    }
    jobsViewModel.setInputValues(index: 'service', value: service["id"]);
    jobsViewModel.setInputValues(
      index: 'job_address',
      value: profileViewModel.getProfileBody['current_address'],
    );

    jobsViewModel.setInputValues(
      index: 'address',
      value:
          '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
    );
    jobsViewModel.setInputValues(
        index: 'latitude',
        value: profileViewModel.getProfileBody['current_address']['latitude']);
    jobsViewModel.setInputValues(
        index: 'longitude',
        value: profileViewModel.getProfileBody['current_address']['longitude']);
    jobsViewModel.setInputValues(index: 'payment_method', value: 'Card');
    jobsViewModel.setInputValues(
        index: 'number_of_units',
        value: service['country_rates'][0]['minimum_order'].toString());

    Navigator.of(context).push(_createRoute(BookAService(
      service: service,
      lang: lang,
      image: service["image"] != null
          ? '${context.resources.image.networkImagePath2}${service["image"]}'
          : 'https://www.shutterstock.com/image-vector/incognito-icon-browse-private-vector-260nw-1462596698.jpg',
    )));
  }

  void showDemoActionSheet(
      {required BuildContext context, required Widget child}) {
    showCupertinoModalPopup<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String? value) {
      if (value != null)   context.setLocale(Locale(value));

    });
  }

  // void _onActionSheetPress(BuildContext context) {
  //   showDemoActionSheet(
  //     context: context,
  //     child: CupertinoActionSheet(
  //       title: const Text('Title'),
  //       message: const Text('Message'),
  //       actions: <Widget>[
  //         CupertinoActionSheetAction(
  //           child: Text(translate('language.name.en-US')),
  //           onPressed: () async {
  //             await AppPreferences()
  //                 .save(key: language, value: 'en', isModel: false);
  //             Navigator.pop(context, 'en');
  //             RestartWidget.restartApp(context);
  //           },
  //         ),
  //         CupertinoActionSheetAction(
  //           child: Text(translate('language.name.ar-SA')),
  //           onPressed: () async {
  //             await AppPreferences()
  //                 .save(key: language, value: 'ar', isModel: false);
  //             Navigator.pop(context, 'ar');
  //             RestartWidget.restartApp(context);
  //           },
  //         ),
  //         CupertinoActionSheetAction(
  //           child: Text(translate('language.name.el-GR')),
  //           onPressed: () async {
  //             await AppPreferences()
  //                 .save(key: language, value: 'el', isModel: false);
  //             Navigator.pop(context, 'el');
  //             RestartWidget.restartApp(context);
  //           },
  //         ),
  //         CupertinoActionSheetAction(
  //           child: Text(translate('language.name.ru-RU')),
  //           onPressed: () async {
  //             await AppPreferences()
  //                 .save(key: language, value: 'ru', isModel: false);
  //             Navigator.pop(context, 'ru');
  //             RestartWidget.restartApp(context);
  //           },
  //         ),
  //       ],
  //       cancelButton: CupertinoActionSheetAction(
  //         child: const Text('Cancel'),
  //         onPressed: () {
  //           Navigator.pop(context, 'Cancel');
  //         },
  //       ),
  //     ),
  //   );
  // }
  void _onActionSheetPress(BuildContext context) {
    final addresses = (Provider.of<ProfileViewModel>(context, listen: false)
            .getProfileBody['address'] as List<dynamic>)
        .cast<Map<String, dynamic>>();

    int selectedIndex = addresses.indexWhere((addr) =>
        addr['id'] ==
        Provider.of<ProfileViewModel>(context, listen: false)
            .getProfileBody['current_address']['id']);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      // important!
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.85,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Gap(15),

                      // --- List of addresses
                      ...List.generate(addresses.length, (i) {
                        final addr = addresses[i];
                        final isSelected = i == selectedIndex;

                        return Consumer<JobsViewModel>(
                          builder: (ctx, jobsVM, _) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.appValues.appPadding.p12,
                                horizontal: context.appValues.appPadding.p20,
                              ),
                              child: InkWell(
                                onTap: () {
                                  setState(() => selectedIndex = i);
                                  jobsVM.setInputValues(
                                      index: 'job_address', value: addr);
                                  jobsVM.setInputValues(
                                      index: 'address',
                                      value:
                                          '${addr['street_number']} ${addr['building_number']}, ${addr['apartment_number']}, ${addr['floor']}');
                                  jobsVM.setInputValues(
                                      index: 'latitude',
                                      value: addr['latitude']);
                                  jobsVM.setInputValues(
                                      index: 'longitude',
                                      value: addr['longitude']);
                                  jobsVM.setInputValues(
                                      index: 'payment_method', value: 'Card');
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.circle_rounded
                                          : Icons.circle_outlined,
                                      color: isSelected
                                          ? const Color(0xff4100E3)
                                          : const Color(0xffC5C6CC),
                                      size: 16,
                                    ),
                                    const Gap(10),
                                    SvgPicture.asset(
                                      'assets/img/locationbookservice.svg',
                                      width: 20,
                                      height: 20,
                                    ),
                                    const Gap(10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${addr["address_label"]}',
                                            // translate('bookService.location'),
                                            style: getPrimaryRegularStyle(
                                              fontSize: 16,
                                              color: context
                                                  .resources.color.btnColorBlue,
                                            ),
                                          ),
                                          Text(
                                            '${addr["street_name"] ?? addr["street_number"]}',
                                            style: getPrimaryRegularStyle(
                                              fontSize: 12,
                                              color: const Color(0xff71727A),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      }),

                      const Gap(5),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: const Divider(color: Color(0xffD4D6DD)),
                      ),

                      // --- Bottom Buttons
                      Consumer2<JobsViewModel, ProfileViewModel>(
                        builder: (ctx, jobsVM, profVM, _) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: context.appValues.appPadding.p12,
                              horizontal: context.appValues.appPadding.p20,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      var addr = profVM
                                          .getProfileBody['current_address'];
                                      jobsVM.setInputValues(
                                          index: 'job_address', value: addr);
                                      jobsVM.setInputValues(
                                          index: 'address',
                                          value:
                                              '${addr['street_number']} ${addr['building_number']}, ${addr['apartment_number']}, ${addr['floor']}');
                                      jobsVM.setInputValues(
                                          index: 'latitude',
                                          value: addr['latitude']);
                                      jobsVM.setInputValues(
                                          index: 'longitude',
                                          value: addr['longitude']);
                                      jobsVM.setInputValues(
                                          index: 'payment_method',
                                          value: 'Card');

                                      Navigator.of(context).push(
                                        _createRoute(const MyaddressBook()),
                                      );
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color:
                                            context.resources.color.colorWhite,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        border: Border.all(
                                          color: const Color(0xff4100E3),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Add / Edit Address",
                                          style: getPrimarySemiBoldStyle(
                                            fontSize: 12,
                                            color: const Color(0xff4100E3),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(15),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      Provider.of<ProfileViewModel>(context,
                                              listen: false)
                                          .setCurrentAddress(
                                              addresses[selectedIndex]);
                                      Navigator.pop(ctx);
                                    },
                                    child: Container(
                                      height: 44,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff4100E3),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Select",
                                          style: getPrimarySemiBoldStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
