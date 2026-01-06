// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/job_details_supplier/job_details_supplier.dart';
import 'package:dingdone/view/notifications_screen/notifications_screen.dart';
import 'package:dingdone/view/widgets/home_page_supplier/job_in_progress.dart';
import 'package:dingdone/view/widgets/home_page_supplier/job_requests.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';
import '../../view_model/categories_view_model/categories_view_model.dart';
import '../bottom_bar/bottom_bar.dart';
import '../widgets/pulsing_dot/pulsing_dot.dart';
import '../widgets/restart/restart_widget.dart';

class HomePageSupplier extends StatefulWidget {
  const HomePageSupplier({super.key});

  @override
  State<HomePageSupplier> createState() => _HomePageSupplierState();
}

String? lang;

class _HomePageSupplierState extends State<HomePageSupplier> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _verificationDialogShown = false;

  @override
  void initState() {
    super.initState();
    getLanguage();
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
      // Provider.of<ProfileViewModel>(context, listen: false).readJson();
      // debugPrint('current role $role');
      // await Provider.of<JobsViewModel>(context, listen: false).readJson();

      // Simulate network fetch or database query
      await Future.delayed(const Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.of(context).push(_createRoute(BottomBar(
        userRole: role,
        currentTab: 0,
      )));
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
    JobsViewModel jobsViewModel =
        Provider.of<JobsViewModel>(context, listen: false);
    jobsViewModel.getSupplierOpenJobs();

    return Consumer2<CategoriesViewModel, ProfileViewModel>(
        builder: (context, categoriesViewModel, profileViewModel, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final status = profileViewModel.getProfileBody['status'];
            final firstName =
                profileViewModel.getProfileBody['user']?['first_name'] ?? '';

            if (
            !_verificationDialogShown &&
                status != 'published' &&
                firstName.isNotEmpty
            ) {
              _verificationDialogShown = true;
              showAccountNotVerifiedDialog(context, firstName);
            }
          });
      return Scaffold(
        key: _scaffoldKey,
        backgroundColor: const Color(0xffFEFEFE),
        // drawer: Drawer(
        //   child: Container(
        //     color: Colors.white,
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         const Gap(60),
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
        //                   userRole: Constants.supplierRoleId,
        //                   lang: lang!,
        //                   initialActiveTab: 'completedJobs',
        //                   initialIndex: 2,
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
        //             Navigator.of(context)
        //                 .push(_createRoute(SupplierAgreement(index: null)));
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
        //                   content: const Text('Are you sure you want to delete your account?'),
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
        //               String? lang =
        //               await AppPreferences().get(key: language, isModel: false);
        //               AppPreferences().clear();
        //               AppProviders.disposeAllDisposableProviders(context);
        //               Navigator.of(context).push(_createRoute(const LoginScreen()));
        //               await AppPreferences().save(key: language, value: lang, isModel: false);
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
        //             right: context.appValues.appPadding.p40,
        //           ),
        //           child: InkWell(
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.end,
        //               children: [
        //                 Row(
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
                        height: context.appValues.appSizePercent.h60,
                        decoration: const BoxDecoration(
                          // image: DecorationImage(
                          //   image: AssetImage('assets/img/homepagebgsupp.png'),
                          //   fit: BoxFit.cover,
                          // ),
                          color: Color(0xff4100E3),
                        ),
                      ),
                      // Gradient overlay
                      Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p8,
                          left: context.appValues.appPadding.p0,
                          right: context.appValues.appPadding.p0,
                        ),
                        child: SafeArea(
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: context.appValues.appPadding.p20,
                                ),
                                child: Row(
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
                                        Text(
                                          'home_screen.Hi'.tr(),
                                          style: getPrimaryBoldStyle(
                                            color: const Color(0xffFFC500),
                                            fontSize: 32,
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                context.appValues.appSize.s5),
                                        Text(
                                          profileViewModel
                                                      .getProfileBody["user"] !=
                                                  null
                                              ? '${profileViewModel.getProfileBody["user"]["first_name"]}!'
                                              : '',
                                          style: getPrimaryBoldStyle(
                                            color: context
                                                .resources.color.colorWhite,
                                            fontSize: 32,
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //     profileViewModel
                                    //                 .getProfileBody["state"] ==
                                    //             'Available for hire'
                                    //         ? Container(
                                    //             width: 8,
                                    //             height: 8,
                                    //             decoration: BoxDecoration(
                                    //               color: Colors.green,
                                    //               borderRadius:
                                    //                   BorderRadius.circular(10),
                                    //             ),
                                    //           )
                                    //         : profileViewModel.getProfileBody[
                                    //                     "state"] ==
                                    //                 'Job in Progress'
                                    //             ? Container(
                                    //                 width: 8,
                                    //                 height: 8,
                                    //                 decoration: BoxDecoration(
                                    //                   color: context.resources
                                    //                       .color.colorYellow,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           10),
                                    //                 ),
                                    //               )
                                    //             : Container(
                                    //                 width: 8,
                                    //                 height: 8,
                                    //                 decoration: BoxDecoration(
                                    //                   color: Colors.red,
                                    //                   borderRadius:
                                    //                       BorderRadius.circular(
                                    //                           10),
                                    //                 ),
                                    //               ),
                                    //     SizedBox(
                                    //         width:
                                    //             context.appValues.appSize.s5),
                                    //     CustomStatusDropDown(
                                    //         state: profileViewModel
                                    //                     .profileBody["state"] !=
                                    //                 null
                                    //             ? profileViewModel
                                    //                 .getProfileBody["state"]
                                    //                 .toString()
                                    //             : 'Available for hire')
                                    //   ],
                                    // ),
                                    Stack(
                                      children: [
                                        InkWell(
                                          onTap: () {

                                            Navigator.of(context).push(
                                              _createRoute(
                                                NotificationsScreen(jobsViewModel: jobsViewModel),
                                              ),
                                            ).then((_) {
                                              setState(() {}); // Triggers rebuild after pop
                                            });


                                          },
                                          child: SvgPicture.asset(
                                            jobsViewModel.hasNotifications
                                                ? 'assets/img/notification.svg'
                                                : 'assets/img/white-bell.svg',
                                            color: jobsViewModel.hasNotifications  ?const Color(0xffFFC500) : null,
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
                                  ],
                                ),
                              ),
                              jobsViewModel.supplierInProgressJobs.isNotEmpty && jobsViewModel.supplierOpenJobs.toString()!='null'?Container():Gap(20),
                              jobsViewModel.supplierInProgressJobs.isNotEmpty && jobsViewModel.supplierOpenJobs.toString()!='null'?
                              SizedBox(
                                height: context.appValues.appSizePercent.h35,
                                child: SingleChildScrollView(
                                    child:
                                    const JobInProgress()
                                ),
                              ):
                              Center(child: Text(
                                'No jobs in progress',
                                style: getPrimaryRegularStyle(
                                  fontSize: 16,
                                  color: Color(0xffEAEAFF),
                                ),
                              ),),
                              const Gap(15),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // Column(
              //   children: [
              //     SafeArea(
              //       child: Padding(
              //         padding: EdgeInsets.all(context.appValues.appPadding.p20),
              //         child:
              //       ),
              //     ),

              //   ],
              // ),
              DraggableScrollableSheet(
                  initialChildSize:jobsViewModel
                      .supplierInProgressJobs.isNotEmpty && jobsViewModel.supplierOpenJobs.toString()!='null'? 0.43:0.75,
                  minChildSize: 0.43,
                  maxChildSize: 1,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return  jobsViewModel.supplierOpenJobs.toString()!='null' && jobsViewModel.supplierOpenJobs.isNotEmpty ?
                    Container(
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
                                    context.appValues.appPadding.p20,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(

                                            'home_screen.jobRequestsAroundMe'.tr(),
                                        style: getPrimaryBoldStyle(
                                          fontSize: 16,
                                          color: const Color(0xff180C38),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                            Consumer2<JobsViewModel, PaymentViewModel>(
                                    builder: (context, jobsViewModel,
                                        paymentViewModel, _) {
                                  return ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    itemCount:
                                        jobsViewModel.supplierOpenJobs.length,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      // var categoryTitle = jobsViewModel.jobsList[index][0]["category"]["title"];
                                      // var servicesInCategory =widget.servicesViewModel.listOfServices[index];

                                      Map<String, dynamic>? services;
                                      for (Map<String, dynamic> translation
                                          in jobsViewModel
                                              .supplierOpenJobs[index]
                                              .service["translations"]) {
                                        if (translation["languages_code"] ==
                                            lang) {
                                          services = translation;
                                          break; // Break the loop once the translation is found
                                        }
                                      }

                                      return InkWell(
                                        onTap: () async {
                                          paymentViewModel.getCustomerPayments(
                                              jobsViewModel
                                                  .supplierOpenJobs[index]
                                                  .customer["id"]);
                                          Navigator.of(context).push(
                                              _createRoute(JobDetailsSupplier(
                                            title: '${services!["title"]}',
                                            data: jobsViewModel
                                                .supplierOpenJobs[index],
                                            fromWhere: 'request',
                                            lang: lang,
                                          )));
                                          debugPrint(
                                              'ejkwfhoweihfowef ${jobsViewModel.supplierOpenJobs[index].severity_level}');
                                        },
                                        child: services != null
                                            ? JobRequests(
                                                title: '${services["title"]}',
                                                image: jobsViewModel
                                                            .supplierOpenJobs[
                                                                index]
                                                            .service['image'] !=
                                                        null
                                                    ? '${context.resources.image.networkImagePath2}${jobsViewModel.supplierOpenJobs[index].service['image']}'
                                                    : 'https://t3.ftcdn.net/jpg/00/27/61/68/360_F_27616800_mP42aLqY152iln3kHDTiAvlMrDoYU606.jpg',
                                                location:
                                                    '${jobsViewModel.supplierOpenJobs[index].job_address["city"]},${jobsViewModel.supplierOpenJobs[index].job_address["street_number"]},${jobsViewModel.supplierOpenJobs[index].job_address["zone"]}',
                                                date:
                                                    '${jobsViewModel.supplierOpenJobs[index].start_date}',
                                                description:
                                                    '${jobsViewModel.supplierOpenJobs[index].job_description}',
                                                id: jobsViewModel
                                                    .supplierOpenJobs[index].id,
                                                severity_level: jobsViewModel
                                                        .supplierOpenJobs[index]
                                                        .severity_level ??
                                                    '',
                                              )
                                            : Container(),
                                      );
                                    },
                                  );
                                }),

                                // JobRequests(
                                //   title: 'Leaks Repair',
                                //   location: 'Oktovriou 28, Larnaca 6055',
                                //   date: '04:45 PM, May 15 2023',
                                //   description:
                                //       'I have a problem with the pipelines under the sink of the kitchen',
                                // ),
                                // JobRequests(
                                //   title: 'Leaks Repair',
                                //   location: 'Oktovriou 28, Larnaca 6055',
                                //   date: '04:45 PM, May 15 2023',
                                //   description:
                                //       'I have a problem with the pipelines under the sink of the kitchen',
                                // ),
                              ],
                            );
                          }),
                    ):Container(
                      decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color(0xffFEFEFE),
                    ),child:  ListView.builder(
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
                                context.appValues.appPadding.p20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(

                                        'home_screen.jobRequestsAroundMe'.tr(),
                                    style: getPrimaryBoldStyle(
                                      fontSize: 16,
                                      color: const Color(0xff180C38),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.appValues.appPadding.p20,
                                context.appValues.appPadding.p0,
                                context.appValues.appPadding.p20,
                                context.appValues.appPadding.p20,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'No jobs around you',
                                    style: getPrimaryRegularStyle(
                                      fontSize: 16,
                                      color:  Color(0xffFFC500)
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    ),);
                  }),
            ],
          ),
        ),
      );
    });
  }
}

void showDemoActionSheet(
    {required BuildContext context, required Widget child}) {
  showCupertinoModalPopup<String>(
    context: context,
    builder: (BuildContext context) => child,
  ).then((String? value) {
    if (value != null) context.setLocale(Locale(value));

  });
}
void showAccountNotVerifiedDialog(
    BuildContext context,
    String firstName,
    ) {
  showDialog(
    context: context,
    barrierDismissible: false, // user must tap OK
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/img/failure.svg',
              height: 80,
            ),
            const Gap(20),
            Text(
              'Hello $firstName,',
              textAlign: TextAlign.center,
              style: getPrimaryBoldStyle(
                fontSize: 18,
                color: const Color(0xff4100E3),
              ),
            ),
            const Gap(10),
            Text(
              'Your account is currently under review and has not been verified yet.\n\n'
                  'Please be patient — we will notify you by email as soon as your account is approved.',
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 15,
                color: const Color(0xff180D38),
              ),
            ),
            const Gap(20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff4100E3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'button.ok'.tr(),
                style: getPrimaryBoldStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
void _onActionSheetPress(BuildContext context) {
  showDemoActionSheet(
    context: context,
    child: CupertinoActionSheet(
      title: const Text('Title'),
      message: const Text('Message'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: Text('language.name.en-US'.tr()),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'en', isModel: false);
            Navigator.pop(context, 'en');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.ar-SA'.tr()),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'ar', isModel: false);
            Navigator.pop(context, 'ar');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.el-GR'.tr()),
          onPressed: () async {
            await AppPreferences()
                .save(key: language, value: 'el', isModel: false);
            Navigator.pop(context, 'el');
            RestartWidget.restartApp(context);
          },
        ),
        CupertinoActionSheetAction(
          child: Text('language.name.ru-RU'.tr()),
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

Widget _buildPopupDialog(BuildContext context) {
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
        SvgPicture.asset('assets/img/booking-confirmation-icon.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            'home_screen.serviceRequestConfirmed'.tr(),
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
           'home_screen.serviceRequestConfirmedMsg'.tr(),
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
