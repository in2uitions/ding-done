// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_increment_number.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class JobSizeWidget extends StatefulWidget {
  var completed_units;
  var number_of_units;
  var extra_fees;
  var extra_fees_reason;
  var userRole;
  var fromWhere;

  JobSizeWidget({
    super.key,
    required this.completed_units,
    required this.number_of_units,
    required this.extra_fees,
    required this.extra_fees_reason,
    required this.userRole,
    required this.fromWhere,
  });

  @override
  State<JobSizeWidget> createState() => _JobSizeWidgetState();
}

class _JobSizeWidgetState extends State<JobSizeWidget> {
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
                context.appValues.appPadding.p10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.jobSize'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  const Gap(10),
                  widget.userRole == Constants.supplierRoleId
                      ? widget.fromWhere == 'completed'
                          ? Container(
                              width: context.appValues.appSizePercent.w100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.1),
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
                                  '${widget.completed_units}',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: const Color(0xff180C38),
                                  ),
                                ),
                              ),
                            )
                          : Consumer<JobsViewModel>(
                              builder: (context, jobsViewModel, _) {
                              return CustomIncrementField(
                                index: 'completed_units',
                                value: '${widget.completed_units}',
                                // hintText: 'Job Type',
                                viewModel: jobsViewModel.setUpdatedJob,
                              );
                            })
                      : Container(
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
                              '${widget.completed_units}',
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
                context.appValues.appPadding.p10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.currentNumberOfUnits'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  const Gap(10),
                  widget.userRole == Constants.supplierRoleId
                      ? widget.fromWhere == 'completed'
                          ? Container(
                              width: context.appValues.appSizePercent.w100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.1),
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
                                  '${widget.number_of_units}',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: const Color(0xff180C38),
                                  ),
                                ),
                              ),
                            )
                          : Consumer<JobsViewModel>(
                              builder: (context, jobsViewModel, _) {
                              return CustomIncrementField(
                                index: 'number_of_units',
                                value: '${widget.number_of_units}',
                                // hintText: 'Job Type',
                                viewModel: jobsViewModel.setUpdatedJob,
                              );
                            })
                      : Container(
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
                              '${widget.number_of_units}',
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
                context.appValues.appPadding.p10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.extraFees'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  const Gap(10),
                  widget.userRole == Constants.supplierRoleId
                      ? widget.fromWhere == 'completed'
                          ? Container(
                              width: context.appValues.appSizePercent.w100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.1),
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
                                  '${widget.extra_fees}',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: const Color(0xff180C38),
                                  ),
                                ),
                              ),
                            )
                          : Consumer<JobsViewModel>(
                              builder: (context, jobsViewModel, _) {
                              return CustomTextField(
                                index: 'extra_fees',
                                value: '${widget.extra_fees}',
                                // hintText: 'Job Type',
                                viewModel: jobsViewModel.setUpdatedJob,
                              );
                            })
                      : Container(
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
                              '${widget.extra_fees}',
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
                context.appValues.appPadding.p10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      left: context.appValues.appPadding.p10,
                      right: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.extraFeesReason'),
                      style: getPrimaryBoldStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  const Gap(10),
                  widget.userRole == Constants.supplierRoleId
                      ? widget.fromWhere == 'completed'
                          ? Container(
                              width: context.appValues.appSizePercent.w100,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xff000000)
                                        .withOpacity(0.1),
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
                                  '${widget.extra_fees_reason}',
                                  style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: const Color(0xff180C38),
                                  ),
                                ),
                              ),
                            )
                          : Consumer<JobsViewModel>(
                              builder: (context, jobsViewModel, _) {
                              return CustomTextField(
                                index: 'extra_fees_reason',
                                value: '${widget.extra_fees_reason}',
                                // hintText: 'Job Type',
                                viewModel: jobsViewModel.setUpdatedJob,
                              );
                            })
                      : Container(
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
                              '${widget.extra_fees_reason}',
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
