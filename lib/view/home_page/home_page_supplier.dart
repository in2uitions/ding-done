import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/job_details_supplier/job_details_supplier.dart';
import 'package:dingdone/view/widgets/custom/custom_status_dropdown.dart';
import 'package:dingdone/view/widgets/home_page_supplier/job_in_progress.dart';
import 'package:dingdone/view/widgets/home_page_supplier/job_requests.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';
import '../bottom_bar/bottom_bar.dart';

class HomePageSupplier extends StatefulWidget {
  const HomePageSupplier({super.key});

  @override
  State<HomePageSupplier> createState() => _HomePageSupplierState();
}

String? lang;

class _HomePageSupplierState extends State<HomePageSupplier> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();

  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    if(lang==null){
     setState(() {
       lang='en-US';
     });
    }
  }

  Future<void> _handleRefresh() async {
    try {
      String? role = await AppPreferences().get(key: userRoleKey, isModel: false);
      // Provider.of<ProfileViewModel>(context, listen: false).readJson();
      // debugPrint('current role $role');
      // await Provider.of<JobsViewModel>(context, listen: false).readJson();

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
    JobsViewModel jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
    jobsViewModel.getSupplierOpenJobs();

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: RefreshIndicator(
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
              child: Consumer<ProfileViewModel>(
                  builder: (context, profileViewModel, _) {
                return Column(
                  children: [
                    Container(
                      // decoration: BoxDecoration(
                      //   color: context.resources.color.btnColorBlue,
                      //   borderRadius: const BorderRadius.only(
                      //       bottomLeft: Radius.circular(20),
                      //       bottomRight: Radius.circular(20)),
                      // ),
                      child: SafeArea(
                          child: Padding(
                        padding: EdgeInsets.all(context.appValues.appPadding.p20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  translate('home_screen.hi'),
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff180C38),
                                    fontSize: 32,
                                  ),
                                ),
                                SizedBox(width: context.appValues.appSize.s5),
                                Text(
                                  profileViewModel.getProfileBody["user"] != null
                                      ? '${profileViewModel.getProfileBody["user"]["first_name"]}'
                                      : '',
                                  style: getPrimaryRegularStyle(
                                    color: const Color(0xff180C38),
                                    fontSize: 32,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                profileViewModel.getProfileBody["state"] ==
                                        'Available for hire'
                                    ? Container(
                                        width: 8,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      )
                                    : profileViewModel.getProfileBody["state"] ==
                                            'Job in Progress'
                                        ? Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: context
                                                  .resources.color.colorYellow,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          )
                                        : Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                SizedBox(width: context.appValues.appSize.s5),
                                CustomStatusDropDown(
                                    state: profileViewModel
                                                .profileBody["state"] !=
                                            null
                                        ? profileViewModel.getProfileBody["state"]
                                            .toString()
                                        : 'Available for hire')
                              ],
                            ),
                          ],
                        ),
                      )),
                    ),
                    JobInProgress(),
                  ],
                );
              }),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p20,
                context.appValues.appPadding.p20,
                context.appValues.appPadding.p20,
                context.appValues.appPadding.p20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    translate('home_screen.jobRequestsAroundMe'),
                    style: getPrimaryBoldStyle(
                      fontSize: 20,
                      color: const Color(0xff180C38),
                    ),
                  ),
                ],
              ),
            ),
            Consumer2<JobsViewModel, PaymentViewModel>(
                builder: (context, jobsViewModel, paymentViewModel, _) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: jobsViewModel.supplierOpenJobs.length,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  // var categoryTitle = jobsViewModel.jobsList[index][0]["category"]["title"];
                  // var servicesInCategory =widget.servicesViewModel.listOfServices[index];

                  Map<String, dynamic>? services;
                  for (Map<String, dynamic> translation in jobsViewModel
                      .supplierOpenJobs[index].service["translations"]) {
                    if (translation["languages_code"] == lang) {
                      services = translation;
                      break; // Break the loop once the translation is found
                    }
                  }

                  return
                  InkWell(
                    onTap: () async {
                      paymentViewModel.getCustomerPayments(
                          jobsViewModel.supplierOpenJobs[index].customer["id"]);
                      Navigator.of(context).push(_createRoute(
                          JobDetailsSupplier(
                            title:'${services!["title"]}',
                          data: jobsViewModel.supplierOpenJobs[index],
                          fromWhere: 'request')));
                    },
                    child: services!=null?
                    JobRequests(
                      title: '${services!["title"]}',
                      image:
                      '${jobsViewModel
                          .supplierOpenJobs[index].service['image']!=null?'${context.resources.image.networkImagePath2}${jobsViewModel
                          .supplierOpenJobs[index].service['image']}':'https://t3.ftcdn.net/jpg/00/27/61/68/360_F_27616800_mP42aLqY152iln3kHDTiAvlMrDoYU606.jpg'}',
                      location:
                          '${jobsViewModel.supplierOpenJobs[index].job_address["city"]},${jobsViewModel.supplierOpenJobs[index].job_address["street_name"]},${jobsViewModel.supplierOpenJobs[index].job_address["building_number"]}',
                      date: '${jobsViewModel.supplierOpenJobs[index].start_date}',
                      description:
                          '${jobsViewModel.supplierOpenJobs[index].job_description}',
                      id: jobsViewModel.supplierOpenJobs[index].id,
                    ):Container(),
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
        SvgPicture.asset('assets/img/service-popup-image.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            translate('home_screen.serviceRequestConfirmed'),
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
            translate('home_screen.serviceRequestConfirmedMsg'),
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
