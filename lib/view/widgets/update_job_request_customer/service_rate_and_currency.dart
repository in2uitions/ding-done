import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceRateAndCurrnecyWidget extends StatefulWidget {
  var service_rate;
  var fromWhere;
  var userRole;
  var currency;

  ServiceRateAndCurrnecyWidget(
      {super.key,
      required this.service_rate,
      required this.currency,
      required this.fromWhere,
      required this.userRole});

  @override
  State<ServiceRateAndCurrnecyWidget> createState() =>
      _ServiceRateAndCurrnecyWidgetState();
}

class _ServiceRateAndCurrnecyWidgetState
    extends State<ServiceRateAndCurrnecyWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p0),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      bottom: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p0,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      'updateJob.serviceRate'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
                      ),
                    ),
                  ),
                  Consumer2<JobsViewModel, LoginViewModel>(
                      builder: (context, jobsViewModel, loginViewModel, _) {
                    return
                        // widget.fromWhere=='completed'?

                        Text(
                      // widget.service_rate!=null?widget.service_rate[0]["unit_rate"].toString():'',
                      '${widget.service_rate}',
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff71727A),
                      ),
                    );
                    //     :widget.userRole==Constants.customerRoleId?
                    // CustomTextField(
                    //   value:widget.service_rate!=null?widget.service_rate[0]["unit_rate"].toString():'',
                    //   index: 'service_rate',
                    //   // hintText: 'Service Rate',
                    //   viewModel: jobsViewModel.setUpdatedJob,
                    // ): Text(
                    //     widget.service_rate!=null?widget.service_rate[0]["unit_rate"].toString():'',
                    //     style: getPrimaryRegularStyle(
                    //     fontSize: 13,
                    //     color: context.resources.color.colorBlack[50],
                    // ));
                    // :Text(
                    //   widget.service_rate!=null?widget.service_rate[0]["unit_rate"].toString():'',
                    //   style: getPrimaryRegularStyle(
                    //     fontSize: 13,
                    //     color: context.resources.color.colorBlack[50],
                    //   ),
                    // );
                  }),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p0,
              vertical: context.appValues.appPadding.p0),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      bottom: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p0,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      'updateJob.currency'.tr(),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
                      ),
                    ),
                  ),
                  Text(
                    '${widget.currency}',
                    style: getPrimaryRegularStyle(
                      fontSize: 14,
                      color: const Color(0xff71727A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
