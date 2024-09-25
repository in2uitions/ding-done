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
              children: [
                Container(
                  // width: context.appValues.appSizePercent.w10,
                  width: 109,
                  // height: context.appValues.appSizePercent.h10,
                  height: 118,
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
                    ),
                    // color: Colors.red,
                  ),
                ),
                Gap(10),
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
                              width: context.appValues.appSizePercent.w50,
                              child: Text(
                                widget.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryBoldStyle(
                                  fontSize: 18,
                                  color: const Color(0xff180C38),
                                ),
                              ),
                            ),

                            SizedBox(height: context.appValues.appSize.s2),
                            Row(
                              children: [
                                SvgPicture.asset('assets/img/map-marker.svg'),
                                SizedBox(width: context.appValues.appSize.s5),
                                SizedBox(
                                  width: context.appValues.appSizePercent.w50,
                                  child: Text(
                                    widget.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: getPrimaryRegularStyle(
                                      fontSize: 10,
                                      color: context
                                          .resources.color.secondColorBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                      ],
                    ),
                    Row(
                      children: [
                        SvgPicture.asset('assets/img/calendar-week.svg'),
                        SizedBox(width: context.appValues.appSize.s5),
                        SizedBox(
                          width: context.appValues.appSizePercent.w50,
                          child: Text(
                            '${DateFormat('d MMMM yyyy, HH:mm').format(DateTime.parse(widget.date.toString()))}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getPrimaryRegularStyle(
                              fontSize: 10,
                              color: context.resources.color.secondColorBlue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [

                        SizedBox(
                          width: context.appValues.appSizePercent.w50,
                          child:  Text(
                            widget.severity_level!=null?widget.severity_level.toString().toLowerCase()=='major'?'Urgent':'Normal':'',
                            style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: widget.severity_level!=null?widget.severity_level.toString().toLowerCase()=='major'?Colors.red:Colors.green:Colors.white),
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
