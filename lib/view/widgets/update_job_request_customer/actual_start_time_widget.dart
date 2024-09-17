import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

class ActualStartTimeWidget extends StatefulWidget {
  var actual_start_date;
  var actual_end_date;

  ActualStartTimeWidget(
      {super.key,
      required this.actual_start_date,
      required this.actual_end_date});

  @override
  State<ActualStartTimeWidget> createState() => _ActualStartTimeWidgetState();
}

class _ActualStartTimeWidgetState extends State<ActualStartTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            // height: context.appValues.appSizePercent.h10,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.appValues.appPadding.p10,
                      horizontal: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.actualStartTime'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  Container(
                    width: context.appValues.appSizePercent.w90,
                    height: context.appValues.appSizePercent.h7,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff000000).withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        // vertical: context.appValues.appPadding.p15,
                        horizontal: context.appValues.appPadding.p10,
                      ),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.actual_start_date != null
                              ? DateFormat('d MMMM yyyy, HH:mm').format(DateTime.parse(widget.actual_start_date.toString() + 'Z').toUtc().toLocal())
                              : '',

                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xff180C38),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Padding(
        //   padding: EdgeInsets.symmetric(
        //     horizontal: context.appValues.appPadding.p20,
        //     vertical: context.appValues.appPadding.p10,
        //   ),
        //   child: SizedBox(
        //     width: context.appValues.appSizePercent.w90,
        //     // height: context.appValues.appSizePercent.h10,
        //     // decoration: BoxDecoration(
        //     //   borderRadius: BorderRadius.circular(15),
        //     //   color: Colors.white,
        //     // ),
        //     child: Padding(
        //       padding: EdgeInsets.fromLTRB(
        //         context.appValues.appPadding.p0,
        //         context.appValues.appPadding.p0,
        //         context.appValues.appPadding.p0,
        //         context.appValues.appPadding.p20,
        //       ),
        //       child: Column(
        //         crossAxisAlignment: CrossAxisAlignment.start,
        //         children: [
        //           Padding(
        //             padding: EdgeInsets.symmetric(
        //               vertical: context.appValues.appPadding.p10,
        //               horizontal: context.appValues.appPadding.p10,
        //             ),
        //             child: Text(
        //               translate('updateJob.finishTime'),
        //               style: getPrimaryBoldStyle(
        //                 fontSize: 20,
        //                 color: const Color(0xff180C38),
        //               ),
        //             ),
        //           ),
        //           Container(
        //             width: context.appValues.appSizePercent.w90,
        //             height: context.appValues.appSizePercent.h7,
        //             decoration: BoxDecoration(
        //               boxShadow: [
        //                 BoxShadow(
        //                   color: const Color(0xff000000).withOpacity(0.1),
        //                   spreadRadius: 1,
        //                   blurRadius: 5,
        //                   offset:
        //                       const Offset(0, 3), // changes position of shadow
        //                 ),
        //               ],
        //               borderRadius: BorderRadius.circular(15),
        //               color: Colors.white,
        //             ),
        //             child: Align(
        //               alignment: Alignment.centerLeft,
        //               child: Padding(
        //                 padding: EdgeInsets.symmetric(
        //                   horizontal: context.appValues.appPadding.p10,
        //                 ),
        //                 child: Text(
        //                   '${widget.actual_end_date}',
        //                   style: getPrimaryRegularStyle(
        //                     fontSize: 20,
        //                     color: const Color(0xff180C38),
        //                   ),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
