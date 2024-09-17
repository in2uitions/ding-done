// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/book_a_service/payment_method.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/actual_end_time_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/actual_start_time_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/address_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/current_supplier_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/date_and_time_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/job_categorie_and_service_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/job_description_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/job_size_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/job_status_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/job_type_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/rating_stars_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/review_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/service_rate_and_currency.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class UpdateJobRequestCustomer extends StatefulWidget {
  var data;

  var fromWhere;
  var title;

  UpdateJobRequestCustomer({super.key, required this.data, this.fromWhere, this.title});

  @override
  State<UpdateJobRequestCustomer> createState() =>
      _UpdateJobRequestCustomerState();
}

class _UpdateJobRequestCustomerState extends State<UpdateJobRequestCustomer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFEFEFE),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.zero,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //   color: context.resources.color.btnColorBlue,
                    //   borderRadius: const BorderRadius.only(
                    //       bottomLeft: Radius.circular(20),
                    //       bottomRight: Radius.circular(20)),
                    // ),
                    child: SafeArea(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding:
                              EdgeInsets.all(context.appValues.appPadding.p20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                child: SvgPicture.asset('assets/img/back.svg'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              const Gap(20),
                              Text(
                                translate('jobDetails.jobDetails'),
                                style: getPrimaryRegularStyle(
                                  color: const Color(0xff180C38),
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p0,
                          vertical: context.appValues.appPadding.p10),
                      child: Text(
                        translate('bookService.jobTitle'),
                        style: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: const Color(0xff180C38),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p0,
                      ),
                      child:Padding(
                        padding:
                        EdgeInsets.fromLTRB(context.appValues.appPadding.p10,0,context.appValues.appPadding.p0,0),
                        child: Text(
                          widget.title.toString(),
                          style: getPrimaryRegularStyle(
                            // color: context.resources.color.colorYellow,
                            color: const Color(0xff180C38),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(20),
              widget.fromWhere==translate('jobs.completed') ||  widget.fromWhere==translate('jobs.active')?
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p0,
                          vertical: context.appValues.appPadding.p10),
                      child: Text(
                        translate('bookService.jobDescription'),
                        style: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: const Color(0xff180C38),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p0,
                      ),
                      child:Padding(
                        padding:
                        EdgeInsets.fromLTRB(context.appValues.appPadding.p10,0,context.appValues.appPadding.p0,0),
                        child: Text(
                          widget.data.service['description'],
                          style: getPrimaryRegularStyle(
                            // color: context.resources.color.colorYellow,
                            color: const Color(0xff180C38),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ):Container(),
              widget.fromWhere!=translate('jobs.active')?
              JobDescriptionWidget(
                description: widget.data.job_description, image: widget.data.service["uploaded_media"],
              ):Container(),
              widget.fromWhere!=translate('jobs.active') &&  widget.fromWhere!=translate('jobs.completed')?
              AddressWidget(address: widget.data.address)
              :Container(),
              // widget.fromWhere == translate('jobs.booked')
              //     ? Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: context.appValues.appPadding.p20,
              //     vertical: context.appValues.appPadding.p10,
              //   ),
              //   child: Container(
              //     width: context.appValues.appSizePercent.w90,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(
              //             context.appValues.appPadding.p0,
              //             context.appValues.appPadding.p10,
              //             context.appValues.appPadding.p0,
              //             context.appValues.appPadding.p0,
              //           ),
              //           child: Text(
              //             translate('jobs.estimatedDistance'),
              //             style: getPrimaryBoldStyle(
              //               fontSize: 20,
              //               color: const Color(0xff180C38),
              //             ),
              //           ),
              //         ),
              //         Padding(
              //           padding: EdgeInsets.fromLTRB(
              //             context.appValues.appPadding.p0,
              //             context.appValues.appPadding.p0,
              //             context.appValues.appPadding.p0,
              //             context.appValues.appPadding.p15,
              //           ),
              //           child: Row(
              //             children: [
              //               Text(
              //                 '${(widget.data.supplier_to_job_distance != null ? (widget.data.supplier_to_job_distance / 1000).toStringAsFixed(3) : "0")} km',
              //                 style: getPrimaryRegularStyle(
              //                   fontSize: 18,
              //                   color: const Color(0xff190C39),
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ),
              //
              //       ],
              //     ),
              //   ),
              // )
              //     :Container(),
              widget.fromWhere == translate('jobs.booked')
                  ? Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Container(
                  width: context.appValues.appSizePercent.w90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p10,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p0,
                        ),
                        child: Text(
                          translate('jobs.estimatedTime'),
                          style: getPrimaryBoldStyle(
                            fontSize: 20,
                            color: const Color(0xff180C38),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p15,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${widget.data.supplier_to_job_time ?? 0} ${translate('jobs.minutes')}',
                              style: getPrimaryRegularStyle(
                                fontSize: 18,
                                color: const Color(0xff190C39),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              )
                  : Container(),
              widget.fromWhere!=translate('jobs.booked') && widget.fromWhere!=translate('jobs.active')  &&  widget.fromWhere!=translate('jobs.completed')?
              DateAndTimeWidget(dateTime: widget.data.start_date)
              :Container(),

              widget.fromWhere!=translate('jobs.booked') && widget.fromWhere!=translate('jobs.active')   &&  widget.fromWhere!=translate('jobs.completed')?
              JobStatusWidget(
                status: widget.data.status,
              ):Container(),
              widget.fromWhere!=translate('jobs.requestedJobs')  &&  widget.fromWhere!=translate('jobs.booked')  &&  widget.fromWhere!=translate('jobs.completed') && widget.fromWhere!=translate('jobs.active')?
              JobTypeWidget(
                job_type: widget.data.job_type["code"],
                tab: widget.fromWhere,
                service: widget.data.service,
              )
              :Container(),

              widget.fromWhere!=translate('jobs.requestedJobs') &&  widget.fromWhere!=translate('jobs.booked')  &&  widget.fromWhere!=translate('jobs.completed') && widget.fromWhere!=translate('jobs.active')?
              JobCategorieAndServiceWidget(
                category: widget.data.service["category"]["title"],
                service: widget.data.service["title"],
              )
              :Container(),

              widget.fromWhere!=translate('jobs.requestedJobs') && widget.fromWhere!=translate('jobs.active')  &&  widget.fromWhere!=translate('jobs.completed')?
              ServiceRateAndCurrnecyWidget(
                  currency: widget.data.service["country_rates"][0]["country"]["curreny"],
                  // currency: widget.data.currency,
                  service_rate: widget.data.job_type=='inspection'?widget.data.service["country_rates"][0]['inspection_rate']:'${widget.data.service["country_rates"][0]['unit_rate']} ${widget.data.service["country_rates"][0]['unit_type']['code']}',

                  // currency: widget.data.currency,
                  // service_rate: widget.data.service["service_rates"],
                  fromWhere: widget.fromWhere,
                  userRole: Constants.customerRoleId)
              :Container(),

              widget.fromWhere!=translate('jobs.requestedJobs')  &&  widget.fromWhere!=translate('jobs.booked') && widget.fromWhere!=translate('jobs.active')  &&  widget.fromWhere!=translate('jobs.completed')?
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Consumer2<PaymentViewModel, JobsViewModel>(
                    builder: (context, paymentViewModel, jobsViewModel, _) {
                  return PaymentMethod(
                    fromWhere: widget.fromWhere,
                    payment_method: paymentViewModel.paymentList,
                    payment_card: widget.data.payment_card,
                    paymentViewModel: paymentViewModel,
                    jobsViewModel: jobsViewModel,
                    role: Constants.customerRoleId,
                  );
                }),
              )
              :Container(),


              widget.fromWhere!=translate('jobs.requestedJobs')  &&  widget.fromWhere!=translate('jobs.completed')?
              CurrentSupplierWidget(
                  user: widget.data.supplier != null
                      ? '${widget.data.supplier["first_name"]} ${widget.data.supplier["last_name"]}'
                      : "")
              :Container(),

              widget.fromWhere!=translate('jobs.requestedJobs')  &&  widget.fromWhere!=translate('jobs.booked')?
              JobSizeWidget(
                completed_units: widget.data.completed_units ?? '',
                number_of_units: widget.data.number_of_units ?? '',
                extra_fees: widget.data.extra_fees ?? '',
                extra_fees_reason: widget.data.extra_fees_reason ?? '',
                userRole: Constants.customerRoleId,
                fromWhere: widget.fromWhere,
              ):Container(),

              widget.fromWhere!=translate('jobs.requestedJobs') &&  widget.fromWhere!=translate('jobs.booked')?
              ActualStartTimeWidget(
                  actual_start_date: widget.data.actual_start_date,
                  actual_end_date: widget.data.finish_date)
              :Container(),
              widget.fromWhere==translate('jobs.completed')?
              ActualEndTimeWidget(
                  actual_start_date: widget.data.actual_start_date,
                  actual_end_date: widget.data.finish_date)
              :Container(),
              widget.fromWhere==translate('jobs.active') || widget.fromWhere==translate('jobs.completed')?
              Padding(
                padding:
                EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p0,
                          vertical: context.appValues.appPadding.p10),
                      child: Text(
                        translate('home_screen.totalPrice'),
                        style: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: const Color(0xff180C38),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.appValues.appPadding.p0,
                      ),
                      child:Padding(
                        padding:
                        EdgeInsets.fromLTRB(context.appValues.appPadding.p10,0,context.appValues.appPadding.p0,0),
                        child: Text(
                          widget.data.total_amount!=null? '${widget.data.total_amount} ${widget.data.service["country_rates"].isNotEmpty?
                          widget.data.service["country_rates"][0]["country"]["curreny"]:''}':'${widget.data.service["country_rates"][0]["unit_rate"]}  ${widget.data.service["country_rates"][0]["country"]["curreny"]} ${widget.data.service["country_rates"][0]["unit_type"]!=null?widget.data.service["country_rates"][0]["unit_type"]["code"]:''}',
                          style: getPrimaryRegularStyle(
                            // color: context.resources.color.colorYellow,
                            color: const Color(0xff180C38),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ):Container(),
              // SizedBox(height: context.appValues.appSizePercent.h2),

              //
              //
              //
              //
              //
              //
              Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
                return SizedBox(
                  height: context.appValues.appSizePercent.h10,
                  width: context.appValues.appSizePercent.w100,
                  // decoration: BoxDecoration(
                  //   borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       topRight: Radius.circular(20)),
                  //   color: context.resources.color.btnColorBlue,
                  // ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // widget.fromWhere!='completed'?

                      widget.fromWhere!=translate('jobs.requestedJobs') && widget.fromWhere!=translate('jobs.active') && widget.fromWhere!=translate('jobs.booked')?
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: context.appValues.appPadding.p10,
                            horizontal: context.appValues.appPadding.p15),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w40,
                          height: context.appValues.appSizePercent.h100,
                          child: ElevatedButton(
                            onPressed: () async {
                              widget.fromWhere == 'completed'
                                  ? await jobsViewModel.downloadInvoice(
                                              widget.data.id) ==
                                          true
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(context,
                                                  translate('button.success')))
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(context,
                                                  translate('button.failure')))
                                  : await jobsViewModel
                                              .updateJob(widget.data.id) ==
                                          true
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(context,
                                                  translate('button.success')))
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(context, translate('button.failure')));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff87795F),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: widget.fromWhere == 'completed'
                                ? Text(
                                    translate('button.invoice'),
                                    style: getPrimaryBoldStyle(
                                      fontSize: 18,
                                      color: context.resources.color.colorWhite,
                                    ),
                                  )
                                : Text(
                                    translate('button.update'),
                                    style: getPrimaryBoldStyle(
                                      fontSize: 18,
                                      color: context.resources.color.colorWhite,
                                    ),
                                  ),
                          ),
                        ),
                      )
                      :Container(),
                      //     :
                      // Container(),
                      widget.fromWhere!=translate('jobs.active')?
                      Consumer2<JobsViewModel, PaymentViewModel>(builder:
                          (context, jobsViewModel, paymentViewModel, _) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: context.appValues.appPadding.p10,
                              horizontal: context.appValues.appPadding.p15),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w40,
                            height: context.appValues.appSizePercent.h100,
                            child: ElevatedButton(
                              onPressed: () {
                                debugPrint(
                                    'payment_card ${widget.data.payment_card}');
                                widget.fromWhere == 'booked' || widget.fromWhere==translate('jobs.requestedJobs')
                                    ? showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            _buildPopupDialog(
                                                context,
                                                jobsViewModel,
                                                widget.data.id,
                                                widget.fromWhere),
                                      )
                                    : widget.fromWhere == 'completed'
                                        ? (widget.fromWhere == 'completed' &&
                                                !widget.data.is_paid)
                                            ? showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        payFees(
                                                          context,
                                                          jobsViewModel,
                                                        ))
                                            : ''
                                        : widget.fromWhere == 'active'
                                            ?
                                            // widget.data.payment_card!=null?
                                            // showDialog(
                                            //                 context: context,
                                            //                 builder: (BuildContext context) =>
                                            //                     payFees(
                                            //                         context, jobsViewModel))
                                            //             :showDialog(
                                            //     context: context,
                                            //     builder: (BuildContext context) =>
                                            //         simpleAlert(
                                            //             context, 'Make sure that you have payed by cash'))
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        review(context,
                                                            jobsViewModel))
                                            : '';
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF3D347),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child:
                              widget.fromWhere == 'active'
                                  ? Text(
                                      translate('button.finish'),
                                      style: getPrimaryBoldStyle(
                                        fontSize: 18,
                                        color:
                                            context.resources.color.colorWhite,
                                      ),
                                    )
                                  :
                              widget.fromWhere == 'completed'
                                      ? Text(
                                          widget.data.is_paid != null
                                              ? (widget.fromWhere ==
                                                          'completed' &&
                                                      !widget.data.is_paid)
                                                  ? translate('button.payFees')
                                                  : translate('button.paid')
                                              : '',
                                          style: getPrimaryBoldStyle(
                                            fontSize: 18,
                                            color: context
                                                .resources.color.colorWhite,
                                          ),
                                        )
                                      : Text(
                                          translate('button.cancel'),
                                          style: getPrimaryBoldStyle(
                                            fontSize: 18,
                                            color: context
                                                .resources.color.colorWhite,
                                          ),
                                        ),
                            ),
                          ),
                        );
                      })
                      :Container(),
                    ],
                  ),
                );
              })
            ],
          ),
          // widget.fromWhere == 'active' || widget.fromWhere == 'booked'
          //     ?

          // : Container(),
        ],
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, JobsViewModel jobsViewModel,
      int job_id, String tab) {
    String message = '';
    if (tab == 'booked') {
      message = translate('updateJob.provideReasonToCancel');
    } else if (tab == 'active') {
      message = translate('updateJob.provideReasonToCancelNote');
    }
    List<String> reasons = [
      translate('jobs.changeOfPlans'),
      translate('jobs.unexpectedEmergency'),
      translate('jobs.illnessOrHealthIssues'),
      translate('jobs.other')
    ];

    return AlertDialog(
      elevation: 15,
      content:SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p0,
          ),
          child: Column(
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
              SvgPicture.asset('assets/img/service-popup-image.svg'),
              SizedBox(height: context.appValues.appSize.s40),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p32,
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: getPrimaryRegularStyle(
                    fontSize: 17,
                    color: context.resources.color.btnColorBlue,
                  ),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s20),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p32,
                ),
                // child: CustomTextArea(
                //   index: 'cancellation_reason',
                //   viewModel: jobsViewModel.setInputValues,
                //   keyboardType: TextInputType.text,
                //   maxlines: 8,
                // ),

                child:
                    Consumer<JobsViewModel>(builder: (context, jobsViewModel1, _) {
                  return Column(
                    children: [
                      // Radio buttons
                      for (int i = 0; i < reasons.length; i++)
                        RadioListTile(
                          title: Text(reasons[i]),
                          value: reasons[i],
                          groupValue: jobsViewModel1.selectedReason,
                          onChanged: (value) {
                            setState(() {
                              // You can perform additional actions based on the selected reason if needed
                            });
                            jobsViewModel1.setInputValues(
                                index: 'cancellation_reason',
                                value: value.toString());
                            if (value == 'Other') {
                              // If "Other" is selected, show the CustomTextArea
                              jobsViewModel1.setShowCustomTextArea(true);
                            } else {
                              // If any other reason is selected, hide the CustomTextArea
                              jobsViewModel1.setShowCustomTextArea(false);
                            }
                          },
                        ),
                      // Your other widgets can go here
                      if (jobsViewModel1.showCustomTextArea)
                        CustomTextArea(
                          index: 'cancellation_reason',
                          viewModel: jobsViewModel.setInputValues,
                          keyboardType: TextInputType.text,
                          maxlines: 8,
                        ),
                    ],
                  );
                }),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p32,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (tab == 'booked' || tab==translate('jobs.requestedJobs')) {
                      if (await jobsViewModel.cancelJobWithPenalty(job_id) == true) {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                simpleAlert(context, translate('button.success')));
                      } else {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                simpleAlert(context, translate('button.failure')));
                      }
                    } else {
                      if (tab == 'active') {
                        if (await jobsViewModel.cancelJobWithPenalty(job_id) ==
                            true) {
                          Navigator.pop(context);

                          Future.delayed(const Duration(seconds: 0));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => simpleAlert(
                                  context, translate('button.success')));
                        } else {
                          Navigator.pop(context);

                          Future.delayed(const Duration(seconds: 0));
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => simpleAlert(
                                  context, translate('button.failure')));
                        }
                      }
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
                    translate('button.send'),
                    style: getPrimaryRegularStyle(
                      fontSize: 15,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget simpleAlert(BuildContext context, String message) {
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
                    Future.delayed(const Duration(seconds: 0));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          message == 'Success'
              ? SvgPicture.asset('assets/img/service-popup-image.svg')
              : SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s20),
        ],
      ),
    );
  }

  Widget payFees(BuildContext context, JobsViewModel jobsViewModel) {
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
                    Future.delayed(const Duration(seconds: 0));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          // message == 'Success'
          //     ?
          // SvgPicture.asset('assets/img/service-popup-image.svg')
          //     : SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s10),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              '${translate('updateJob.yourTotalAmountIs')} ${widget.data.total_amount} ${widget.data.currency}',
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 17,
                color: context.resources.color.btnColorBlue,
              ),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s10),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p10,
            ),
            child: widget.data.payment_card!=null?
            Row(
              children: [
                Text(
                  translate('updateJob.payUsingCard'),
                  textAlign: TextAlign.center,
                  style: getPrimaryRegularStyle(
                    fontSize: 17,
                    color: context.resources.color.btnColorBlue,
                  ),
                ),
                Text(
                  '${widget.data.payment_card["brand"]}',
                  textAlign: TextAlign.center,
                  style: getPrimaryRegularStyle(
                    fontSize: 17,
                    color: context.resources.color.colorYellow,
                  ),
                ),
              ],
            ) : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Make Sure to pay Cash',
              textAlign: TextAlign.center,
                  style: getPrimaryRegularStyle(
                    fontSize: 17,
                    color: context.resources.color.btnColorBlue,
                  ),
                ),

              ],
            ),
          ),
          SizedBox(height: context.appValues.appSize.s10),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: ElevatedButton(
              onPressed: () async {
               if (widget.data.payment_card!=null){
                 if (await jobsViewModel.payFees(widget.data.id) == true) {
                   showDialog(
                       context: context,
                       builder: (BuildContext context) =>
                           simpleAlert(context, translate('button.success')));
                 } else {
                   showDialog(
                       context: context,
                       builder: (BuildContext context) => simpleAlert(context,
                           '${translate('button.failure')} \n${jobsViewModel.errorMessage}'));
                 }
               }else{
                 showDialog(
                     context: context,
                     builder: (BuildContext context) =>
                         simpleAlert(context, translate('button.success')));
               }

                // Future.delayed(Duration(seconds: 0));
                // Navigator.pop(context);
                //
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
            ),
          ),

          SizedBox(height: context.appValues.appSize.s20),
        ],
      ),
    );
  }

  Widget review(BuildContext context, JobsViewModel jobsViewModel) {
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
                    Future.delayed(const Duration(seconds: 0));
                    widget.data.payment_card != null
                        ? showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                payFees(context, jobsViewModel))
                        : showDialog(
                            context: context,
                            builder: (BuildContext context) => simpleAlert(
                                context,
                                translate('updateJob.makeSureYouPayedByCash')));
                  },
                ),
              ],
            ),
          ),
          // message == 'Success'
          //     ?
          // SvgPicture.asset('assets/img/service-popup-image.svg')
          //     : SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s10),
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
          SizedBox(height: context.appValues.appSize.s10),
          RatingStarsWidget(
              stars: widget.data.rating_stars != null
                  ? widget.data.rating_stars
                  : 0),
          ReviewWidget(
            review: widget.data.rating_comment ?? '',
          ),
          SizedBox(height: context.appValues.appSize.s10),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: ElevatedButton(
              onPressed: () async {
                if (await jobsViewModel.updateJob(widget.data.id) == true) {
                  Navigator.of(context).pop();
                  Future.delayed(const Duration(seconds: 0));
                  widget.data.payment_card != null
                      ? showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              payFees(context, jobsViewModel))
                      : showDialog(
                          context: context,
                          builder: (BuildContext context) => simpleAlert(
                              context,
                              translate('updateJob.makeSureYouPayedByCash')));

                  // showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) =>
                  //         simpleAlert(context, 'Success'));
                } else {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => simpleAlert(context,
                          '${translate('button.failure')} \n${jobsViewModel.errorMessage}'));
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
            ),
          ),

          SizedBox(height: context.appValues.appSize.s20),
        ],
      ),
    );
  }
}
