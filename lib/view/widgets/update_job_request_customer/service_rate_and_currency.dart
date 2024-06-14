import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
              vertical: context.appValues.appPadding.p10),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p10,
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
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.serviceRate'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  Consumer2<JobsViewModel, LoginViewModel>(
                      builder: (context, jobsViewModel, loginViewModel, _) {
                    return
                        // widget.fromWhere=='completed'?

                        Container(
                      width: context.appValues.appSizePercent.w100,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xff000000).withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: context.appValues.appPadding.p15,
                          horizontal: context.appValues.appPadding.p20,
                        ),
                        child: Text(
                          // widget.service_rate!=null?widget.service_rate[0]["unit_rate"].toString():'',
                          '${widget.service_rate}',
                          style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: const Color(0xff180C38),
                          ),
                        ),
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
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p10,
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
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.currency'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  Container(
                    width: context.appValues.appSizePercent.w100,
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
                        vertical: context.appValues.appPadding.p15,
                        horizontal: context.appValues.appPadding.p20,
                      ),
                      child: Text(
                        '${widget.currency}',
                        style: getPrimaryRegularStyle(
                          fontSize: 20,
                          color: const Color(0xff180C38),
                        ),
                      ),
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
