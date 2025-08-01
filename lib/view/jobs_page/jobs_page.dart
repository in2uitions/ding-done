import 'package:audioplayers/audioplayers.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/notifications_screen/notifications_screen.dart';
import 'package:dingdone/view/widgets/jobs/jobs_cards.dart';
import 'package:dingdone/view/widgets/tabs/tabs_jobs.dart';
import 'package:dingdone/view/widgets/tabs/tabs_jobs_supplier.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../res/app_prefs.dart';
import '../../view_model/categories_view_model/categories_view_model.dart';
import '../../view_model/profile_view_model/profile_view_model.dart';
import '../../view_model/services_view_model/services_view_model.dart';
import '../bottom_bar/bottom_bar.dart';
import '../widgets/pulsing_dot/pulsing_dot.dart';
import '../widgets/update_job_request_customer/rating_stars_widget.dart';
import '../widgets/update_job_request_customer/review_widget.dart';

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

  AudioPlayer _audioPlayer = AudioPlayer();
  Future<void> _handleRefresh() async {
    try {

      await Provider.of<JobsViewModel>(context, listen: false).readJson();

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
  void initState() {
    super.initState();
    _active = widget.initialActiveTab;
    Provider.of<JobsViewModel>(context, listen: false).getCustomerJobs();
    if (widget.userRole == Constants.customerRoleId) {
      var jobsViewModel = Provider.of<JobsViewModel>(context, listen: false);
      dynamic completedJobs = jobsViewModel.getcustomerJobs
          .where((e) => e.status == 'completed' && e.rating_stars == null)
          .toList();
      debugPrint('completed jobs $completedJobs');
      if (completedJobs.isNotEmpty)
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showReviewDialog(context, completedJobs[0], jobsViewModel);
        });
    }
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
              translate('updateJob.rateJob'),
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
              job.service!=null?job.service['translations'][0]['title']:'',
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s10),
          RatingStarsWidget(
            stars: jobsViewModel.updatedBody!=null && jobsViewModel.updatedBody["rating_stars"]!=null?jobsViewModel.updatedBody["rating_stars"]:0,
            userRole: Constants.customerRoleId,
          ),
          ReviewWidget(
            review: job.rating_comment ?? '',
          ),
          SizedBox(height: context.appValues.appSize.s10),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
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
                        builder: (BuildContext context) => _buildPopupDialogFailure(context,
                            '${jobsViewModel.errorMessage}'));
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
                  translate('button.ok'),
                  style: getPrimaryRegularStyle(
                    fontSize: 15,
                    color: context.resources.color.btnColorBlue,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: context.appValues.appSize.s20),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffFEFEFE),
      backgroundColor: const Color(0xffFFFFFF),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p0),
                    child: Stack(
                      children: [
                        Container(
                          width: context.appValues.appSizePercent.w100,
                          height: context.appValues.appSizePercent.h50,
                          decoration: const BoxDecoration(
                            // image: DecorationImage(
                            //   image: AssetImage('assets/img/jobimage.png'),
                            //   fit: BoxFit.cover,
                            // ),
                            color: Color(0xff4100E3),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: context.appValues.appPadding.p15,
                            left: context.appValues.appPadding.p20,
                            right: context.appValues.appPadding.p20,
                          ),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      translate('bottom_bar.jobs'),
                                      style: getPrimarySemiBoldStyle(
                                        color:
                                            context.resources.color.colorWhite,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Consumer<JobsViewModel>(
                                        builder: (context, jobsViewModel, _) {
                                        return  Stack(
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
                                                color: jobsViewModel.hasNotifications ?const Color(0xffFFC500) : null,
                                              ),
                                            ),
                                            // if (profileViewModel.hasNotifications)
                                            //   Positioned(
                                            //     right: 0,
                                            //     top: 0,
                                            //     child: PulsingDot(),
                                            //   ),
                                          ],
                                        );
                                      }
                                    ),
                                  ],
                                ),
                                // InkWell(
                                //   child: Padding(
                                //     padding: EdgeInsets.only(
                                //       top: context.appValues.appPadding.p8,
                                //     ),
                                //     child: SvgPicture.asset(
                                //         'assets/img/back-new.svg'),
                                //   ),
                                //   onTap: () {
                                //     Navigator.pop(context);

                                //     Navigator.push(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => BottomBar(
                                //             userRole: widget.userRole),
                                //       ),
                                //     );
                                //   },
                                // ),
                              ],
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
            ],
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.85,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return RefreshIndicator(
                  onRefresh: _handleRefresh,
                  child: Container(
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
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              const Gap(30),
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
                                          child: TabsJobsSupplier(
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
                  ),
                );
              }),
        ],
      ),
    );
  }

  List<int> getJobCounts(JobsViewModel jobsViewModel) {
    List<int> a = Constants.supplierRoleId == widget.userRole
        ? [
            jobsViewModel.supplierBookedJobs!=null?jobsViewModel.supplierBookedJobs.length:0,
            jobsViewModel.supplierInProgressJobs!=null?jobsViewModel.supplierInProgressJobs.length:0,
            jobsViewModel.supplierCompletedJobs!=null?jobsViewModel.supplierCompletedJobs.length:0,
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
                        _createRoute(BottomBar(
                          userRole: role,
                          currentTab: 0,
                        )),
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
Widget _buildPopupDialogFailure(BuildContext context,String message) {
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
            translate('button.failure'),
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
