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
            color: context.resources.color.colorWhite,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              context.appValues.appPadding.p0,
              context.appValues.appPadding.p0,
              context.appValues.appPadding.p0,
              context.appValues.appPadding.p0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: context.appValues.appSizePercent.w10,
                  width: 159,
                  // width: 109,
                  // height: context.appValues.appSizePercent.h10,
                  height: 185,
                  // height: 118,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.image,
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(50)),
                    // color: Colors.red,
                  ),
                ),
                const Gap(10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: context.appValues.appSizePercent.w40,
                              child: Text(
                                widget.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryBoldStyle(
                                  fontSize: 18,
                                  color: const Color(0xff180C38),
                                ),
                              ),
                            ),
                            SizedBox(height: context.appValues.appSize.s2),
                          ],
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          child: Text(
                            'Working Day',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryBoldStyle(
                              fontSize: 14,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          child: Text(
                            DateFormat('d MMMM yyyy, HH:mm')
                                .format(DateTime.parse(widget.date.toString())),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryRegularStyle(
                              fontSize: 12,
                              color: const Color(0xff38385E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Gap(10),
                    Column(
                      children: [
                        SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          child: Text(
                            'Location',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryBoldStyle(
                              fontSize: 14,
                              color: const Color(0xff1F1F39),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          child: Text(
                            widget.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryRegularStyle(
                              fontSize: 12,
                              color: const Color(0xff38385E),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          child: Text(
                            widget.severity_level != null
                                ? widget.severity_level
                                            .toString()
                                            .toLowerCase() ==
                                        'major'
                                    ? 'Urgent'
                                    : 'Normal'
                                : '',
                            style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: widget.severity_level != null
                                    ? widget.severity_level
                                                .toString()
                                                .toLowerCase() ==
                                            'major'
                                        ? Colors.red
                                        : Colors.green
                                    : Colors.white),
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
