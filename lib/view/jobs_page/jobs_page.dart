import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/jobs/CircleButton.dart';
import 'package:dingdone/view/widgets/jobs/jobs_cards.dart';
import 'package:dingdone/view/widgets/tabs/tabs.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/app_prefs.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../bottom_bar/bottom_bar.dart';

class JobsPage extends StatefulWidget {
  var userRole;
  var lang;

  JobsPage({super.key, required this.userRole, required this.lang});

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  String? _active;

  void active(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    active('bookedJobs');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: Tabs(
        tabtitle: [
          translate('jobs.activeJobs'),
          translate('jobs.bookedJobs'),
          translate('jobs.completedJobs'),
        ],
        tabContent: [
          Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
            return JobsCards(
                active: "activeJobs",
                userRole: widget.userRole,
                jobsViewModel: jobsViewModel,
                lang: widget.lang);
          }),
          Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
            return JobsCards(
                active: "bookedJobs",
                userRole: widget.userRole,
                jobsViewModel: jobsViewModel,
                lang: widget.lang);
          }),
          Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
            return JobsCards(
                active: "completedJobs",
                userRole: widget.userRole,
                jobsViewModel: jobsViewModel,
                lang: widget.lang);
          }),
        ],
        content: Consumer<LoginViewModel>(builder: (context, loginViewModel, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      child: InkWell(
                        child: SvgPicture.asset('assets/img/back.svg'),
                        onTap: () async {
                          Navigator.pop(context);

                              final prefs = await SharedPreferences.getInstance();
                              final role = prefs.getString(userRoleKey);


                          Navigator.of(context).push(_createRoute(
                              BottomBar(userRole:role)));
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: Text(
                    translate('bottom_bar.jobs'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue, fontSize: 32),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
    // return Scaffold(
    //   backgroundColor: const Color(0xffFEFEFE),
    //   body: ListView(
    //     padding: EdgeInsets.zero,
    //     children: [
    //       SafeArea(
    //           child: Padding(
    //         padding: EdgeInsets.all(context.appValues.appPadding.p20),
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Align(
    //               alignment: Alignment.centerLeft,
    //               child: Padding(
    //                 padding: EdgeInsets.all(context.appValues.appPadding.p20),
    //                 child: InkWell(
    //                   child: SvgPicture.asset('assets/img/back.svg'),
    //                   onTap: () {
    //                     Navigator.pop(context);
    //                   },
    //                 ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.symmetric(
    //                   horizontal: context.appValues.appPadding.p20),
    //               child: Text(
    //                 translate('bottom_bar.jobs'),
    //                 style: getPrimaryBoldStyle(
    //                   color: context.resources.color.btnColorBlue,
    //                   fontSize: 32,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(height: context.appValues.appSize.s15),
    //             Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: <CircleButton>[
    //                 CircleButton(
    //                   action: active, //pass data from child to parent
    //                   tag: "activeJobs", //specifies attribute of button
    //                   active: _active == "activeJobs"
    //                       ? true
    //                       : false, //set button active based on value in this parent
    //                   text: translate('jobs.activeJobs'),
    //                 ),
    //                 CircleButton(
    //                   action: active, //pass data from child to parent
    //                   tag: "bookedJobs", //specifies attribute of button
    //                   active: _active == "bookedJobs" ? true : false,
    //                   text: translate('jobs.bookedJobs'),
    //                 ),
    //                 CircleButton(
    //                   action: active,
    //                   tag: "completedJobs",
    //                   active: _active == "completedJobs" ? true : false,
    //                   text: translate('jobs.completedJobs'),
    //                 ),
    //               ],
    //             ),
    //           ],
    //         ),
    //       )),
    //       Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
    //         return JobsCards(
    //             active: _active,
    //             userRole: widget.userRole,
    //             jobsViewModel: jobsViewModel,
    //             lang: widget.lang);
    //       }),
    //     ],
    //   ),
    // );
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
