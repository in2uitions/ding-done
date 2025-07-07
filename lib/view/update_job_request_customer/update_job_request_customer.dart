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
import 'package:dingdone/view/widgets/update_job_request_customer/job_type_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/rating_stars_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/review_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/service_rate_and_currency.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class UpdateJobRequestCustomer extends StatefulWidget {
  var data;

  var fromWhere;
  var title;
  var lang;

  UpdateJobRequestCustomer(
      {super.key,
      required this.data,
      required this.lang,
      this.fromWhere,
      this.title});

  @override
  State<UpdateJobRequestCustomer> createState() =>
      _UpdateJobRequestCustomerState();
}

class _UpdateJobRequestCustomerState extends State<UpdateJobRequestCustomer> {
  bool _isLoading = false;
  bool _isLoading2 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFEFEFE),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            children: [
              // Header with back button and title
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p0),
                    child: Stack(
                      children: [
                        Container(
                          width: context.appValues.appSizePercent.w100,
                          height: context.appValues.appSizePercent.h50,
                          decoration: const BoxDecoration(
                            // image: DecorationImage(
                            //   image: AssetImage('assets/img/homepagebg.png'),
                            //   fit: BoxFit.cover,
                            // ),
                            color: Color(0xff4100E3),
                          ),
                          child: SafeArea(
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 5,
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.arrow_back_ios_new_sharp,
                                      color: context.resources.color.colorWhite,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 55,
                                    top: 3,
                                  ),
                                  child: Text(
                                    translate('jobDetails.jobDetails'),
                                    style: getPrimarySemiBoldStyle(
                                      color: context.resources.color.colorWhite,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.85,
              minChildSize: 0.85,
              maxChildSize: 1,
              builder:
                  (BuildContext context, ScrollController scrollController) {
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: context.appValues.appPadding.p20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p0,
                                        vertical:
                                            context.appValues.appPadding.p0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          translate('updateJob.jobStatus'),
                                          style: getPrimaryRegularStyle(
                                            fontSize: 14,
                                            color: context
                                                .resources.color.btnColorBlue,
                                          ),
                                        ),
                                        Text(
                                  widget.data.status=='inprogress'?'in progress':widget.data.status,
                                          style: getPrimarySemiBoldStyle(
                                            color: const Color(0xff4100E3),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Gap(20),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p0,
                                        vertical:
                                            context.appValues.appPadding.p10),
                                    child: Text(
                                      translate('bookService.jobTitle'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180C38),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          context.appValues.appPadding.p0,
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          context.appValues.appPadding.p0,
                                          0,
                                          context.appValues.appPadding.p0,
                                          0),
                                      child: Text(
                                        widget.title.toString(),
                                        style: getPrimaryRegularStyle(
                                          // color: context.resources.color.colorYellow,
                                          color: const Color(0xff71727A),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Gap(20),

                                  widget.fromWhere == translate('jobs.completed') ||
                                      widget.fromWhere == translate('jobs.active')
                                      ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                        context.appValues.appPadding.p0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: context
                                                  .appValues.appPadding.p0,
                                              vertical: context
                                                  .appValues.appPadding.p0),
                                          child: Text(
                                            translate(
                                                'bookService.jobDescription'),

                                            style: getPrimaryRegularStyle(
                                              fontSize: 14,
                                              color: const Color(0xff180C38),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal:
                                            context.appValues.appPadding.p0,
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                              context.appValues.appPadding.p0,
                                              0,
                                              context.appValues.appPadding.p0,
                                              0,
                                            ),
                                            child: Builder(
                                              builder: (context) {
                                                String? description;
                                                for (var translation in widget
                                                    .data
                                                    .service['translations']) {
                                                  if (translation[
                                                  'languages_code'] ==
                                                      widget.lang) {
                                                    description = translation[
                                                    'description'];
                                                    break; // Exit loop once the match is found
                                                  }
                                                }

                                                // Display the description if found, otherwise fallback to default
                                                return Text(
                                                  description ??
                                                      'No description available',
                                                  // Fallback text if no matching translation is found
                                                  style: getPrimaryRegularStyle(
                                                    color:
                                                    const Color(0xff71727A),
                                                    fontSize: 14,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                      : Container(),
                                ],
                              ),
                            ),

                            // widget.fromWhere!=translate('jobs.active')?
                            JobDescriptionWidget(
                              description: widget.data.job_description,
                              image: widget.data.uploaded_media,
                            ),
                            // :Container(),
                            widget.fromWhere != translate('jobs.active') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed')
                                ? AddressWidget(
                                    address: widget.data.job_address)
                                : Container(),
                            widget.fromWhere == translate('jobs.booked')
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          context.appValues.appPadding.p20,
                                      vertical:
                                          context.appValues.appPadding.p10,
                                    ),
                                    child: SizedBox(
                                      width:
                                          context.appValues.appSizePercent.w90,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              style: getPrimaryRegularStyle(
                                                fontSize: 14,
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
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xff71727A),
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
                            widget.fromWhere != translate('jobs.booked') &&
                                    widget.fromWhere !=
                                        translate('jobs.active') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed')
                                ? DateAndTimeWidget(
                                    dateTime: widget.data.start_date)
                                : Container(),

                            // widget.fromWhere != translate('jobs.booked') &&
                            //         widget.fromWhere !=
                            //             translate('jobs.active') &&
                            //         widget.fromWhere !=
                            //             translate('jobs.completed')
                            //     ? JobStatusWidget(
                            //         status: widget.data.status,
                            //       )
                            //     : Container(),
                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                                    widget.fromWhere !=
                                        translate('jobs.booked') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed') &&
                                    widget.fromWhere != translate('jobs.active')&&
                                    widget.fromWhere != 'notifications'
                                ? JobTypeWidget(
                                    job_type: widget.data.job_type["code"],
                                    tab: widget.fromWhere,
                                    service: widget.data.service,
                                  )
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                                    widget.fromWhere !=
                                        translate('jobs.booked') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed') &&
                                    widget.fromWhere != translate('jobs.active')&&
                                    widget.fromWhere != 'notifications'
                                ? JobCategorieAndServiceWidget(
                                    category: widget.data.service["category"]
                                        ["title"],
                                    service: widget.data.service["title"],
                                  )
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                                    widget.fromWhere !=
                                        translate('jobs.active') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed') &&
                                    widget.fromWhere !=
                                       'notifications'
                                ? ServiceRateAndCurrnecyWidget(
                                    currency: widget.data.job_address["country"]
                                        ["currency"],
                                    // currency: widget.data.currency,
                                    service_rate: _getServiceRate(),

                                    // currency: widget.data.currency,
                                    // service_rate: widget.data.service["service_rates"],
                                    fromWhere: widget.fromWhere,
                                    userRole: Constants.customerRoleId)
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                                    widget.fromWhere !=
                                        translate('jobs.booked') &&
                                    widget.fromWhere !=
                                        translate('jobs.active') &&
                                    widget.fromWhere !=
                                        translate('jobs.completed') &&
                                    widget.fromWhere !=
                                        'notifications'
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          context.appValues.appPadding.p10,
                                    ),
                                    child: Consumer2<PaymentViewModel,
                                            JobsViewModel>(
                                        builder: (context, paymentViewModel,
                                            jobsViewModel, _) {
                                      return PaymentMethod(
                                        fromWhere: widget.fromWhere,
                                        payment_method:
                                            paymentViewModel.paymentList,
                                        tap_payments_card:
                                            widget.data.tap_payments_card,
                                        paymentViewModel: paymentViewModel,
                                        jobsViewModel: jobsViewModel,
                                        role: Constants.customerRoleId,
                                      );
                                    }),
                                  )
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                            widget.fromWhere !=
                                        'notifications' &&
                                    widget.fromWhere !=
                                        translate('jobs.completed')
                                ? CurrentSupplierWidget(
                                    user: widget.data.supplier != null
                                        ? '${widget.data.supplier["first_name"]} ${widget.data.supplier["last_name"]}'
                                        : "")
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                            widget.fromWhere !=
                                        'notifications' &&
                                    widget.fromWhere != translate('jobs.booked')
                                ? JobSizeWidget(
                                    completed_units:
                                        widget.data.completed_units ?? '',
                                    number_of_units:
                                        widget.data.number_of_units ?? '',
                                    extra_fees: widget.data.extra_fees ?? '',
                                    extra_fees_reason:
                                        widget.data.extra_fees_reason ?? '',
                                    userRole: Constants.customerRoleId,
                                    fromWhere: widget.fromWhere,
                                  )
                                : Container(),

                            widget.fromWhere !=
                                        translate('jobs.requestedJobs') &&
                            widget.fromWhere !=
                                        'notifications' &&
                                    widget.fromWhere != translate('jobs.booked')
                                ? ActualStartTimeWidget(
                                    actual_start_date:
                                        widget.data.actual_start_date,
                                    actual_end_date: widget.data.finish_date)
                                : Container(),
                            widget.fromWhere == translate('jobs.completed')
                                ? ActualEndTimeWidget(
                                    actual_start_date:
                                        widget.data.actual_start_date,
                                    actual_end_date: widget.data.finish_date)
                                : Container(),
                            widget.fromWhere == translate('jobs.active') ||
                                    widget.fromWhere ==
                                        translate('jobs.completed')
                                ? Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            context.appValues.appPadding.p20),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            translate('home_screen.totalPrice'),
                                            style: getPrimaryRegularStyle(
                                              fontSize: 14,
                                              color: const Color(0xff180C38),
                                            ),
                                          ),
                                          Text(
                                            widget.data.total_amount != null
                                                ? '${widget.data.total_amount} ${widget.data.service!=null?widget.data.service["country_rates"].isNotEmpty ? widget.data.service["country_rates"][0]["country"]["currency"] : '':''}'
                                                : '${widget.data.service["country_rates"][0]["unit_rate"]}  ${widget.data.service["country_rates"][0]["country"]["curreny"] ?? ''} ${widget.data.service["country_rates"][0]["unit_type"] != null ? widget.data.service["country_rates"][0]["unit_type"]["code"] : ''}',
                                            style: getPrimarySemiBoldStyle(
                                              color: const Color(0xff4100E3),
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            // SizedBox(height: context.appValues.appSizePercent.h2),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                              ),
                              child: Divider(
                                color: const Color(0xffEAEAFF),
                                thickness: 1.5,
                                height: context.appValues.appSizePercent.h2,
                              ),
                            ),

                            //
                            //
                            //
                            //
                            //
                            //
                            Consumer<JobsViewModel>(
                                builder: (context, jobsViewModel, _) {
                              return SizedBox(
                                // height: context.appValues.appSizePercent.h,
                                width: context.appValues.appSizePercent.w100,
                                // decoration: BoxDecoration(
                                //   borderRadius: const BorderRadius.only(
                                //       topLeft: Radius.circular(20),
                                //       topRight: Radius.circular(20)),
                                //   color: context.resources.color.btnColorBlue,
                                // ),
                                child: Column(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    // widget.fromWhere!='completed'?

                                    widget.fromWhere !=
                                                translate(
                                                    'jobs.requestedJobs') &&
                                    widget.fromWhere !=
                                                'notifications' &&
                                            widget.fromWhere !=
                                                translate('jobs.active') &&
                                            widget.fromWhere !=
                                                translate('jobs.booked')
                                        ? Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: context
                                                    .appValues.appPadding.p10,
                                                horizontal: context
                                                    .appValues.appPadding.p15),
                                            child: SizedBox(
                                              width: context.appValues
                                                  .appSizePercent.w100,
                                              // height: context.appValues
                                              //     .appSizePercent.h1,
                                              height: 44,
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  setState(() {
                                                    _isLoading2 = true;
                                                  });
                                                  widget.fromWhere ==
                                                          translate(
                                                              'jobs.completed')
                                                      ? await jobsViewModel.downloadInvoice(widget.data.id) !=
                                                              null
                                                          ? await Navigator
                                                              .push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          Scaffold(
                                                                              appBar:
                                                                                  AppBar(
                                                                                title: const Text('Invoice'),
                                                                              ),
                                                                              body: SfPdfViewer.memory(jobsViewModel
                                                                                  .file))))
                                                          : showDialog(
                                                              context: context,
                                                              builder: (BuildContext context) =>
                                                                  simpleAlert(
                                                                      context,
                                                                      translate(
                                                                          'button.failure')))
                                                      : await jobsViewModel.updateJob(widget.data.id) ==
                                                              true
                                                          ? showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext context) =>
                                                                      simpleAlert(context, translate('button.success')))
                                                          : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure')));
                                                  setState(() {
                                                    _isLoading2 = false;
                                                  });
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xff4100E3),
                                                  elevation: 0,
                                                  shadowColor:
                                                      Colors.transparent,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                ),
                                                child: widget.fromWhere ==
                                                        translate(
                                                            'jobs.completed')
                                                    ? _isLoading2
                                                        ? const CircularProgressIndicator()
                                                        : Text(
                                                            translate(
                                                                'button.invoice'),
                                                            style:
                                                                getPrimarySemiBoldStyle(
                                                              fontSize: 12,
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .colorWhite,
                                                            ),
                                                          )
                                                    : _isLoading2
                                                        ? const CircularProgressIndicator()
                                                        : Text(
                                                            translate(
                                                                'button.update'),
                                                            style:
                                                                getPrimarySemiBoldStyle(
                                                              fontSize: 12,
                                                              color: context
                                                                  .resources
                                                                  .color
                                                                  .colorWhite,
                                                            ),
                                                          ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    const Gap(10),
                                    //     :
                                    // Container(),
                                    widget.fromWhere !=
                                                translate('jobs.active') &&
                                            widget.fromWhere !=
                                                translate('jobs.completed') && widget.fromWhere!='notifications'
                                        ? Consumer2<JobsViewModel,
                                                PaymentViewModel>(
                                            builder: (context, jobsViewModel,
                                                paymentViewModel, _) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: context
                                                      .appValues.appPadding.p13,
                                                  horizontal: context.appValues
                                                      .appPadding.p15),
                                              child: SizedBox(
                                                width: context.appValues
                                                    .appSizePercent.w100,
                                                // height: context.appValues
                                                //     .appSizePercent.h15,
                                                height: 44,
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _isLoading = true;
                                                    });
                                                    debugPrint(
                                                        'tap_payments_card ${widget.data.tap_payments_card}');
                                                    widget.fromWhere ==
                                                                'booked' ||
                                                            widget.fromWhere ==
                                                                translate(
                                                                    'jobs.requestedJobs')
                                                        ? showDialog(
                                                            context: context,
                                                            builder: (BuildContext
                                                                    context) =>
                                                                _buildPopupDialog(
                                                                    context,
                                                                    jobsViewModel,
                                                                    widget.data
                                                                        .id,
                                                                    widget
                                                                        .fromWhere),
                                                          )
                                                        // : widget.fromWhere == translate('jobs.completed')
                                                        //     ? (widget.fromWhere == translate('jobs.completed') &&
                                                        //             !widget.data.is_paid)
                                                        //         ? showDialog(
                                                        //             context: context,
                                                        //             builder:
                                                        //                 (BuildContext context) =>
                                                        //                     payFees(
                                                        //                       context,
                                                        //                       jobsViewModel,
                                                        //                     ))
                                                        //         : ''
                                                        : widget.fromWhere ==
                                                                translate(
                                                                    'jobs.active')
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
                                                                context:
                                                                    context,
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    review(
                                                                        context,
                                                                        jobsViewModel))
                                                            : '';
                                                    setState(() {
                                                      _isLoading = false;
                                                    });
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    elevation: 0,
                                                    shadowColor:
                                                        Colors.transparent,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                        color:
                                                            Color(0xff4100E3),
                                                        width: 1.5,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                    ),
                                                  ),
                                                  child: widget.fromWhere ==
                                                          translate(
                                                              'jobs.active')
                                                      ? _isLoading
                                                          ? const CircularProgressIndicator()
                                                          : Text(
                                                              translate(
                                                                  'button.finish'),
                                                              style:
                                                                  getPrimaryRegularStyle(
                                                                fontSize: 16,
                                                                color: const Color(
                                                                    0xff4100E3),
                                                              ),
                                                            )
                                                      : widget.fromWhere ==
                                                              translate(
                                                                  'jobs.completed')
                                                          ? _isLoading
                                                              ? const CircularProgressIndicator()
                                                              : Text(
                                                                  widget.data.is_paid !=
                                                                          null
                                                                      ? (widget.fromWhere == translate('jobs.completed') &&
                                                                              !widget
                                                                                  .data.is_paid)
                                                                          ? translate(
                                                                              'button.payFees')
                                                                          : translate(
                                                                              'button.paid')
                                                                      : '',
                                                                  style:
                                                                      getPrimaryRegularStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: const Color(
                                                                        0xff4100E3),
                                                                  ),
                                                                )
                                                          : Text(
                                                              translate(
                                                                  'button.cancel'),
                                                              style:
                                                                  getPrimarySemiBoldStyle(
                                                                fontSize: 12,
                                                                color: const Color(
                                                                    0xff4100E3),
                                                              ),
                                                            ),
                                                ),
                                              ),
                                            );
                                          })
                                        : Container(),
                                  ],
                                ),
                              );
                            }),
                            const Gap(10),
                          ],
                        );
                      }),
                );
              }),
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
    } else if (tab == translate('jobs.active')) {
      message = translate('updateJob.provideReasonToCancelNote');
    }
    List<String> reasons = [
      translate('jobs.changeOfPlans'),
      translate('jobs.unexpectedEmergency'),
      translate('jobs.illnessOrHealthIssues'),
      translate('jobs.other')
    ];

    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 15,
      content: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(bottom: context.appValues.appPadding.p8),
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
              SvgPicture.asset('assets/img/cancelation-icon.svg'),
              SizedBox(height: context.appValues.appSize.s40),
              Text(
                'Important!',
                textAlign: TextAlign.center,
                style: getPrimarySemiBoldStyle(
                  fontSize: 16,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
              const Gap(10),
              Text(
                'Cancellations made within 4 hours of the job start time will incur a 50 QAR fee.',
                textAlign: TextAlign.center,
                style: getPrimaryRegularStyle(
                  fontSize: 12,
                  color: const Color(0xff71727A),
                ),
              ),
              const Gap(10),
              Text(
                'Would you like to continue with the cancellation?',
                textAlign: TextAlign.center,
                style: getPrimaryRegularStyle(
                  fontSize: 12,
                  color: const Color(0xff71727A),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Cancelation reason',
                  textAlign: TextAlign.left,
                  style: getPrimaryRegularStyle(
                    fontSize: 12,
                    color: const Color(0xff71727A),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p0,
                ),
                // child: CustomTextArea(
                //   index: 'cancellation_reason',
                //   viewModel: jobsViewModel.setInputValues,
                //   keyboardType: TextInputType.text,
                //   maxlines: 8,
                // ),

                child: Consumer<JobsViewModel>(
                    builder: (context, jobsViewModel1, _) {
                  return Column(
                    children: [
                      const Gap(10),
                      // Radio buttons
                      for (int i = 0; i < reasons.length; i++)
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          visualDensity: const VisualDensity(vertical: -4),
                          title: Text(
                            reasons[i],
                            style: getPrimaryRegularStyle(fontSize: 12),
                          ),
                          value: reasons[i],
                          groupValue: jobsViewModel.selectedReason,
                          activeColor: Theme.of(context).primaryColor,
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
                      const Gap(10),
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
                  horizontal: context.appValues.appPadding.p0,
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (tab == 'booked' ||
                        tab == translate('jobs.requestedJobs')) {
                      if (tab == 'booked') {
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
                      } else {
                        if (tab == translate('jobs.requestedJobs')) {
                          if (await jobsViewModel.cancelJobNoPenalty(job_id) ==
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
                    } else {
                      if (tab == translate('jobs.active')) {
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
                    backgroundColor: const Color(0xff4100E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(
                      context.appValues.appSizePercent.w100,
                      context.appValues.appSizePercent.h5,
                    ),
                  ),
                  child: Text(
                    translate('button.submit'),
                    style: getPrimarySemiBoldStyle(
                      fontSize: 12,
                      color: context.resources.color.colorWhite,
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
      backgroundColor: Colors.white,
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
          message == translate('button.success')
              ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
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

  // Widget payFees(BuildContext context, JobsViewModel jobsViewModel) {
  //   return AlertDialog(
  //     elevation: 15,
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       // crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               InkWell(
  //                 child: SvgPicture.asset('assets/img/x.svg'),
  //                 onTap: () {
  //                   Navigator.pop(context);
  //                   Future.delayed(const Duration(seconds: 0));
  //                   Navigator.pop(context);
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         // message == 'Success'
  //         //     ?
  //         // SvgPicture.asset('assets/img/service-popup-image.svg')
  //         //     : SvgPicture.asset('assets/img/failure.svg'),
  //         SizedBox(height: context.appValues.appSize.s10),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             '${translate('updateJob.yourTotalAmountIs')} ${widget.data.total_amount} ${widget.data.currency}',
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: context.appValues.appSize.s10),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p10,
  //           ),
  //           child: widget.data.payment_card!=null?
  //           Row(
  //             children: [
  //               Text(
  //                 translate('updateJob.payUsingCard'),
  //                 textAlign: TextAlign.center,
  //                 style: getPrimaryRegularStyle(
  //                   fontSize: 17,
  //                   color: context.resources.color.btnColorBlue,
  //                 ),
  //               ),
  //               Text(
  //                 '${widget.data.payment_card["brand"]}',
  //                 textAlign: TextAlign.center,
  //                 style: getPrimaryRegularStyle(
  //                   fontSize: 17,
  //                   color: context.resources.color.colorYellow,
  //                 ),
  //               ),
  //             ],
  //           ) : Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Text(
  //                 'Make Sure to pay Cash',
  //             textAlign: TextAlign.center,
  //                 style: getPrimaryRegularStyle(
  //                   fontSize: 17,
  //                   color: context.resources.color.btnColorBlue,
  //                 ),
  //               ),
  //
  //             ],
  //           ),
  //         ),
  //         SizedBox(height: context.appValues.appSize.s10),
  //
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: ElevatedButton(
  //             onPressed: () async {
  //              if (widget.data.payment_card!=null){
  //                if (await jobsViewModel.payFees(widget.data.id) == true) {
  //                  showDialog(
  //                      context: context,
  //                      builder: (BuildContext context) =>
  //                          simpleAlert(context, translate('button.success')));
  //                } else {
  //                  showDialog(
  //                      context: context,
  //                      builder: (BuildContext context) => simpleAlert(context,
  //                          '${translate('button.failure')} \n${jobsViewModel.errorMessage}'));
  //                }
  //              }else{
  //                showDialog(
  //                    context: context,
  //                    builder: (BuildContext context) =>
  //                        simpleAlert(context, translate('button.success')));
  //              }
  //
  //               // Future.delayed(Duration(seconds: 0));
  //               // Navigator.pop(context);
  //               //
  //             },
  //             style: ElevatedButton.styleFrom(
  //               elevation: 0.0,
  //               shadowColor: Colors.transparent,
  //               backgroundColor: const Color(0xffFFD105),
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //               fixedSize: Size(
  //                 context.appValues.appSizePercent.w30,
  //                 context.appValues.appSizePercent.h5,
  //               ),
  //             ),
  //             child: Text(
  //               translate('button.ok'),
  //               style: getPrimaryRegularStyle(
  //                 fontSize: 15,
  //                 color: context.resources.color.btnColorBlue,
  //               ),
  //             ),
  //           ),
  //         ),
  //
  //         SizedBox(height: context.appValues.appSize.s20),
  //       ],
  //     ),
  //   );
  // }

  Widget review(BuildContext context, JobsViewModel jobsViewModel) {
    return AlertDialog(
      backgroundColor: Colors.white,
      elevation: 15,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
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
              userRole: Constants.customerRoleId,
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

  String _getServiceRate() {
    // Extract the currency from job address
    try {
      String currency = widget.data.job_address["country"]["currency"];

      // Find the rate from country_rates where currency matches
      var matchingRate = widget.data.service["country_rates"].firstWhere(
            (rate) => rate["country"]['currency'] == currency,
        orElse: () => null, // If no match is found, return null
      );

      if (matchingRate != null) {
        // Check the job type and return the appropriate rate
        if (widget.data.job_type == 'inspection') {
          return matchingRate['inspection_rate'] ?? 'No rate available';
        } else {
          return '${matchingRate['unit_rate']} ${matchingRate['unit_type']['code']}';
        }
      } else {
        return 'Rate not found'; // Fallback if no matching currency is found
      }
    }catch(error){
      return 'Rate not found';
    }
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
