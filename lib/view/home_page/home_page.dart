// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/categories/parent_categories.dart';
import 'package:dingdone/view/notifications_screen/notifications_screen.dart';
import 'package:dingdone/view/services_screen/services_screen.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../book_a_service/book_a_service.dart';
import '../bottom_bar/bottom_bar.dart';
import '../widgets/categories_screen/categories_screen_cards.dart';

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

  @override
  void initState() {
    super.initState();
    getLanguage();
    Provider.of<CategoriesViewModel>(context, listen: false)
        .getCategoriesAndServices();
    // Provider.of<CategoriesViewModel>(context, listen: false).sortCategories(
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    searchController.addListener(_filterServices);
    // Initially display all services
    filteredServices = categoriesViewModel.servicesList2;
  }

  @override
  void dispose() {
    searchController.removeListener(_filterServices);
    searchController.dispose();
    super.dispose();
  }

  void _filterServices() {
    String searchText = searchController.text.toLowerCase();
    var categoriesViewModel =
        Provider.of<CategoriesViewModel>(context, listen: false);
    categoriesViewModel.searchData(index: 'search_services', value: searchText);
    debugPrint('categories search result ${categoriesViewModel.servicesList2}');

    setState(() {
      if (searchText.isEmpty) {
        // Display all services if search text is empty
        filteredServices = categoriesViewModel.servicesList2;
      } else {
        filteredServices = categoriesViewModel.servicesList2;
      }
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
                                                ? '${translate('home_screen.Hi')} '
                                                : '',
                                            style: getPrimaryBoldStyle(
                                              color: const Color(0xffFFC500),
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            profileViewModel.getProfileBody[
                                                        "user"] !=
                                                    null
                                                ? '${profileViewModel.getProfileBody["user"]["first_name"]}'
                                                : '',
                                            style: getPrimaryBoldStyle(
                                              color: context
                                                  .resources.color.colorWhite,
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
                                              color: const Color(0xffFFC500),
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(_createRoute(
                                        const NotificationsScreen(),
                                      ));
                                    },
                                    child: SvgPicture.asset(
                                        'assets/img/yellowbell.svg'),
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
                                  horizontal: context.appValues.appPadding.p20,
                                  vertical: context.appValues.appPadding.p15,
                                ),
                                child: TextFormField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xffEAEAFF),
                                    prefixIcon: const Icon(
                                      Icons.search,
                                      color: Color(0xFF6E6BE8),
                                    ),
                                    hintText: "I’m done with...",
                                    hintStyle: const TextStyle(
                                      color: Color(0xFF6E6BE8),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6E6BE8),
                                      ),
                                    ),
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
                      initialChildSize: 0.73,
                      minChildSize: 0.73,
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
                              itemBuilder: (BuildContext context, int index) {
                                return Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        context.appValues.appPadding.p20,
                                        context.appValues.appPadding.p0,
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
                                            translate('home_screen.categories'),
                                            style: getPrimarySemiBoldStyle(
                                              fontSize: 16,
                                              color: context
                                                  .resources.color.btnColorBlue,
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
                                      onTap: () {
                                        Navigator.of(context).push(_createRoute(
                                          const ServicesScreen(),
                                        ));
                                      },
                                      child: ParentCategoriesWidget(
                                          servicesViewModel: servicesViewModel),
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
                                        horizontal:
                                            context.appValues.appPadding.p20,
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
                                            translate(
                                                'home_screen.featuredServices'),
                                            style: getPrimarySemiBoldStyle(
                                              fontSize: 16,
                                              color: context
                                                  .resources.color.btnColorBlue,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Text(
                                                  translate(
                                                      'home_screen.seeAll'),
                                                  style: getPrimaryBoldStyle(
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xff4100E3),
                                                  ),
                                                ),
                                                const Gap(5),
                                                const Icon(
                                                  Icons.arrow_forward_ios_sharp,
                                                  color: Color(0xff4100E3),
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p20,
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
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 700),
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  },
                                                ),
                                                items: imgList
                                                    .map((item) => Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            image:
                                                                const DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                'https://media.istockphoto.com/id/1158769712/photo/professional-furniture-assembly-worker-assembles-shelf-professional-handyman-doing-assembly.jpg?s=612x612&w=0&k=20&c=BBvngif9SB8VbAb1gSD4DaBzob6Chnm0KZpP09lCLrc=',
                                                              ),
                                                            ),
                                                          ),
                                                          // color:
                                                          //     context.resources.color.btnColorBlue,
                                                          child: Center(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Align(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        EdgeInsets
                                                                            .only(
                                                                      left: context
                                                                          .appValues
                                                                          .appPadding
                                                                          .p10,
                                                                      bottom: context
                                                                          .appValues
                                                                          .appPadding
                                                                          .p35,
                                                                    ),
                                                                    child: Text(
                                                                      'Bed Frames Assembly',
                                                                      style:
                                                                          getPrimaryBoldStyle(
                                                                        fontSize:
                                                                            20,
                                                                        color: context
                                                                            .resources
                                                                            .color
                                                                            .colorWhite,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ))
                                                    .toList(),
                                              ),
                                              Positioned(
                                                bottom: 15,
                                                left: 0,
                                                right: 0,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: imgList
                                                      .asMap()
                                                      .entries
                                                      .map((entry) {
                                                    return GestureDetector(
                                                      onTap: () => _controller
                                                          .animateToPage(
                                                              entry.key),
                                                      child: Container(
                                                        width: 12.0,
                                                        height: 12.0,
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            vertical: 8.0,
                                                            horizontal: 4.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: _current ==
                                                                  entry.key
                                                              ? Colors.white
                                                              : Colors.white
                                                                  .withOpacity(
                                                                      0.4),
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
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Column(
                                              children: [
                                                Center(
                                                  child: Text(
                                                    translate(
                                                        'home_screen.availability'),
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        getPrimaryRegularStyle(
                                                      fontSize: 14,
                                                      color: const Color(
                                                          0xff71727A),
                                                    ),
                                                  ),
                                                ),
                                                const Gap(15),
                                                InkWell(
                                                  onTap: () {
                                                    jobsViewModel
                                                        .launchWhatsApp();
                                                  },
                                                  child: Container(
                                                    width: 127,
                                                    height: 44,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: context
                                                          .appValues
                                                          .appPadding
                                                          .p0,
                                                      vertical: context
                                                          .appValues
                                                          .appPadding
                                                          .p0,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                          0xff25D366),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
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
                                                            'CONTACT US',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style:
                                                                getPrimaryBoldStyle(
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
                                            width: context
                                                .appValues.appSizePercent.w50,
                                            padding: const EdgeInsets.all(8.0),
                                            color: Colors.white,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                IconButton(
                                                  icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .facebook),
                                                  color:
                                                      const Color(0xff8F9098),
                                                  onPressed: () {
                                                    // Handle Facebook tap
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .instagram),
                                                  color:
                                                      const Color(0xff8F9098),
                                                  onPressed: () {
                                                    // Handle Instagram tap
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const FaIcon(
                                                      FontAwesomeIcons
                                                          .xTwitter),
                                                  color:
                                                      const Color(0xff8F9098),
                                                  // X (Twitter)
                                                  onPressed: () {
                                                    // Handle X (Twitter) tap
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
                                    'description': service["xdescription"] ?? ''
                                  };
                                }
                                debugPrint('translation si $translation');

                                return Consumer2<JobsViewModel,
                                    ProfileViewModel>(
                                  builder: (context, jobsViewModel,
                                      profileViewModel, _) {
                                    return CategoriesScreenCards(
                                      category: service["category"],
                                      title: translation != null
                                          ? translation["title"]
                                          : '',
                                      cost: 0,
                                      // '${service["country_rates"][0]["unit_rate"]} ${service["country_rates"][0]["country"]["curreny"]}',
                                      image: service["image"] != null
                                          ? '${context.resources.image.networkImagePath2}${service["image"]}'
                                          : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      onTap: () {
                                        _handleServiceSelection(service,
                                            jobsViewModel, profileViewModel);
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
      if (value != null) changeLocale(context, value);
    });
  }

  void _onActionSheetPress(BuildContext context) {
    showDemoActionSheet(
      context: context,
      child: CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
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
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context, 'Cancel');
          },
        ),
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
