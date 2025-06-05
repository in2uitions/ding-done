import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JobRequests extends StatefulWidget {
  JobRequests({
    super.key,
    required this.title,
    required this.location,
    required this.date,
    required this.description,
    required this.id,
    required this.image,
    required this.severity_level,
  });

  String title, location, image, date, description, severity_level;
  int id;
  @override
  State<JobRequests> createState() => _JobRequestsState();
}

class _JobRequestsState extends State<JobRequests> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p0,
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p15,
        ),
        child: Container(
          width: 343,
          // height: 87,
          decoration: BoxDecoration(
            color: const Color(0xffEAEAFF).withOpacity(0.4),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p15,
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: const Color(0xffEAEAFF),
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.image,
                              ),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        const Gap(10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 200,
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryMediumStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180C38),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 200,
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.severity_level != null
                                            ? widget.severity_level
                                                        .toString()
                                                        .toLowerCase() ==
                                                    'major'
                                                ? 'Urgent'
                                                : 'Scheduled'
                                            : '',
                                        style: getPrimarySemiBoldStyle(
                                          fontSize: 10,
                                          color: widget.severity_level != null?
                                          widget.severity_level
                                              .toString()
                                              .toLowerCase() ==
                                              'major'?Colors.red:Colors.green:
                                          const Color(0xff6E6BE8),
                                          // color: widget.severity_level != null
                                          //     ? widget.severity_level
                                          //                 .toString()
                                          //                 .toLowerCase() ==
                                          //             'major'
                                          //         ? Colors.red
                                          //         : Colors.green
                                          //     : Colors.white,
                                        ),
                                      ),
                                      widget.severity_level
                                          .toString()
                                          .toLowerCase() ==
                                          'major'?Text(
                                        widget.severity_level != null
                                            ? widget.severity_level
                                            .toString()
                                            .toLowerCase() ==
                                            'major'
                                            ? ' (in less than 4 hours)'
                                            : ''
                                            : '',
                                        style: getPrimarySemiBoldStyle(
                                          fontSize: 10,
                                          color:const Color(0xff6E6BE8),

                                        ),
                                      ):Container(),
                                    ],
                                  ),

                                  ),

                              ],
                            ),
                          ],
                        ),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Color(0xff6E6BE8),
                          ),
                        ),
                      ],
                    ),
                    const Gap(20),
                    SizedBox(
                      width: 303,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/img/calendarjobs.svg',
                              ),
                              const Gap(5),
                              Text(
                                DateFormat('d MMMM yyyy').format(
                                    DateTime.parse(widget.date.toString())),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryRegularStyle(
                                  fontSize: 12,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/img/timejobs.svg',
                              ),
                              const Gap(5),
                              Text(
                                DateFormat('HH:mm').format(
                                    DateTime.parse(widget.date.toString())),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryRegularStyle(
                                  fontSize: 12,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Gap(10),
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/img/locationjobs.svg',
                        ),
                        const Gap(5),
                        Text(
                          widget.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: getPrimaryRegularStyle(
                            fontSize: 12,
                            color: const Color(0xff180B3C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
