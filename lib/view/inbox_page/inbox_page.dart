import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/inbox_page/skeleton_notifications.dart';
import 'package:dingdone/view/widgets/inbox_page/notification_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../view_model/profile_view_model/profile_view_model.dart';

class InboxPage extends StatefulWidget {
  var hasNotifications;

   InboxPage({super.key,required this.hasNotifications});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffFEFEFE),
      backgroundColor: const Color(0xffFFFFFF),
      body:
      Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p0),
                child: Stack(
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/img/inboxbg.png'),
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
                                    translate('notifications.notifications'),
                                    style: getPrimaryBoldStyle(
                                      color: context.resources.color.colorWhite,
                                      fontSize: 28,
                                    ),
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
                              //   },
                              // ),
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
            builder: (BuildContext context, ScrollController scrollController) {
              return  widget.hasNotifications?
              Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color(0xffFEFEFE),
                ),
                child: FutureBuilder(
                    future: Provider.of<ProfileViewModel>(
                        context, listen: false)
                        .getNotifications(),
                    builder: (context, AsyncSnapshot data) {
                      if (data.hasData) {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: data.data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                NotificationWidget(
                                  title: '${data.data[index]['subject']}',
                                  message: '${data.data[index]['body']}',
                                  time: '',
                                  onTap: () {},
                                ),
                              ],
                            );
                          },
                        );
                      }
                      else {
                        return ListView.builder(
                          controller: scrollController,
                          itemCount: 10 , // Show 10 skeletons while loading
                          itemBuilder: (BuildContext context, int index) {
                              return const NotificationSkeleton();

                          },
                        );
                      }
                    }),
              )
                  : Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  color: Color(0xffFEFEFE),

                ),
                child:NotificationWidget(
                  title: 'Notifications',
                  message: 'No Notifications',
                  time: '',
                  onTap: () {},
                ),);
            },
          ),
        ],
      ),
    );
  }
}
