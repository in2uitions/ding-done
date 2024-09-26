import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/jobs/CircleButton.dart';
import 'package:dingdone/view/widgets/jobs/jobs_cards.dart';
import 'package:dingdone/view/widgets/tabs/tabs.dart';
import 'package:dingdone/view/widgets/tabs/tabs_jobs.dart';
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
  final String userRole;
  final String lang;
  final String initialActiveTab;
  final int initialIndex;

  JobsPage({
    Key? key,
    required this.userRole,
    required this.lang,
    required this.initialActiveTab,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<JobsPage> createState() => _JobsPageState();
}

class _JobsPageState extends State<JobsPage> {
  late String _active;

  void active(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    super.initState();
    _active = widget.initialActiveTab;
    Provider.of<JobsViewModel>(context, listen: false).getCustomerJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffFEFEFE),
      backgroundColor: const Color(0xffFFFFFF),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p0),
                child: Stack(
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/jobimage.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h15,
                      decoration: ShapeDecoration(
                        gradient: LinearGradient(
                          begin: const Alignment(0.00, 1),
                          end: const Alignment(0, 0),
                          colors: [
                            const Color(0xffEECB0B).withOpacity(0),
                            const Color(0xffEECB0B).withOpacity(0.4),
                            const Color(0xffEECB0B).withOpacity(0.6),
                            const Color(0xffEECB0B).withOpacity(0.9),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p8,
                          left: context.appValues.appPadding.p20,
                          right: context.appValues.appPadding.p20,
                        ),
                        child: SafeArea(
                          child: Stack(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('bottom_bar.jobs'),
                                    style: getPrimaryBoldStyle(
                                      color: context.resources.color.colorWhite,
                                      fontSize: 28,
                                    ),
                                  ),
                                ],
                              ),
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: context.appValues.appPadding.p8,
                                  ),
                                  child: SvgPicture.asset(
                                      'assets/img/back-new.svg'),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 50,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w80,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title',
                                style: getPrimaryBoldStyle(
                                  fontSize: 18,
                                  color: context.resources.color.colorWhite,
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
            ],
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.80,
              minChildSize: 0.80,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                            Consumer<JobsViewModel>(
                              builder: (context, jobsViewModel, _) {
                                List<int> jobCounts =
                                    getJobCounts(jobsViewModel);
                                debugPrint('job counts  is $jobCounts');

                                return widget.userRole ==
                                        Constants.supplierRoleId
                                    ? SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: TabsJobs(
                                          tabtitle: [
                                            translate('jobs.bookedJobs'),
                                            translate('jobs.activeJobs'),
                                            translate('jobs.completedJobs'),
                                          ],
                                          tabContent: [
                                            JobsCards(
                                              active: "bookedJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            JobsCards(
                                              active: "activeJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            JobsCards(
                                              active: "completedJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                          ], // Ensure this is List<Widget>
                                          jobCounts: jobCounts,
                                          initialActiveTab: _active,
                                          initialIndex: widget.initialIndex,
                                        ),
                                      )
                                    : SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: TabsJobs(
                                          tabtitle: [
                                            translate('jobs.requestedJobs'),
                                            translate('jobs.confirmedJobs'),
                                            translate('jobs.activeJobs'),
                                            translate('jobs.completedJobs'),
                                          ],
                                          tabContent: [
                                            JobsCards(
                                              active: "requestedJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            JobsCards(
                                              active: "bookedJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            JobsCards(
                                              active: "activeJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                            JobsCards(
                                              active: "completedJobs",
                                              userRole: widget.userRole,
                                              jobsViewModel: jobsViewModel,
                                              lang: widget.lang,
                                              scrollController:
                                                  scrollController,
                                            ),
                                          ],
                                          jobCounts: jobCounts,
                                          initialActiveTab: _active,
                                          initialIndex: widget.initialIndex,
                                          // Pass the active tab here
                                          // content: buildHeader(context),
                                        ),
                                      );
                              },
                            ),
                          ],
                        );
                      }),
                );
              }),
        ],
      ),
    );
  }

  List<int> getJobCounts(JobsViewModel jobsViewModel) {
    List<int> a = Constants.supplierRoleId == widget.userRole
        ? [
            jobsViewModel.supplierBookedJobs.length,
            jobsViewModel.supplierInProgressJobs.length,
            jobsViewModel.supplierCompletedJobs.length,
          ]
        : [
            jobsViewModel.getcustomerJobs
                .where((e) => e.status == 'circulating' || e.status == 'draft')
                .toList()
                .length,
            jobsViewModel.getcustomerJobs
                .where((e) => e.status == 'booked')
                .toList()
                .length,
            jobsViewModel.getcustomerJobs
                .where((e) => e.status == 'inprogress')
                .toList()
                .length,
            jobsViewModel.getcustomerJobs
                .where((e) => e.status == 'completed')
                .toList()
                .length,
          ];
    return a;
  }

  Widget buildHeader(BuildContext context) {
    return Consumer<LoginViewModel>(
      builder: (context, loginViewModel, _) {
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

                      Navigator.of(context).push(
                        _createRoute(BottomBar(userRole: role)),
                      );
                    },
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p20,
              ),
              child: Text(
                translate('bottom_bar.jobs'),
                style: getPrimaryRegularStyle(
                  color: context.resources.color.btnColorBlue,
                  fontSize: 32,
                ),
              ),
            ),
          ],
        );
      },
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
