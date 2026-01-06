import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/settings_screen/settings_screen.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../view_model/profile_view_model/profile_view_model.dart';
import '../widgets/inbox_page/notification_widget.dart';

class NotificationsScreen extends StatefulWidget {
  var jobsViewModel;

  NotificationsScreen({super.key, required this.jobsViewModel});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    debugPrint('wdehfw ${widget.jobsViewModel.notifications}');
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: context.appValues.appSizePercent.w100,
            height: context.appValues.appSizePercent.h50,
            decoration: const BoxDecoration(
              color: Color(0xff4100E3),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () async {
                            await widget.jobsViewModel.setNotificationsData(false);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'notifications.notifications'.tr(),
                          style: getPrimarySemiBoldStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(_createRoute(
                          const SettingsScreen(),
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p8,
                        ),
                        child: SvgPicture.asset('assets/img/settings.svg'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.85,
            minChildSize: 0.85,
            maxChildSize: 1,
            builder: (BuildContext context, ScrollController scrollController) {
              return FutureBuilder(
                  future: Provider.of<JobsViewModel>(context, listen: false)
                      .getNotifications(),
                  builder: (context, AsyncSnapshot data) {
                    if (data.hasData && data.data.isNotEmpty) {
                      return Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Color(0xffFEFEFE),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(),

                                  TextButton(
                                    onPressed: () async {
                                      await widget.jobsViewModel
                                          .clearAllNotifications();
                                      setState(() {});
                                    },
                                    child: Text(
                                      'notifications.clearAll'.tr(),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: Color(0xffFFC500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: widget
                                    .jobsViewModel.notifications.length,
                                padding: EdgeInsets.zero,
                                itemBuilder: (BuildContext context, int index) {
                                  final notification = data.data[index];
                                  return NotificationWidget(
                                    title: '${notification['subject']}',
                                    message: '${notification['body']}',
                                    time: '',
                                    onTap: () {},
                                    trailing: InkWell(
                                      onTap: () async {
                                        await widget.jobsViewModel.deleteNotificationById(notification['id']);
                                        setState(() {}); // Refresh the list
                                      },
                                      child: SvgPicture.asset(
                                        'assets/img/bin.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
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
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                const Gap(30),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    context.appValues.appPadding.p20,
                                    context.appValues.appPadding.p0,
                                    context.appValues.appPadding.p20,
                                    context.appValues.appPadding.p10,
                                  ),
                                  child: Column(
                                    children: [
                                      const Gap(150),
                                      SvgPicture.asset('assets/img/notif.svg'),
                                      const Gap(20),
                                      Text(
                                        'No Notifications',
                                        style: getPrimarySemiBoldStyle(
                                          color: const Color(0xff180B3C),
                                          fontSize: 24,
                                        ),
                                      ),
                                      const Gap(5),
                                      Text(
                                        "We’ll notify you when there’s\nsomething new",
                                        textAlign: TextAlign.center,
                                        style: getPrimaryRegularStyle(
                                          color: const Color(0xff71727A),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    }
                  });
            },
          ),
        ],
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
