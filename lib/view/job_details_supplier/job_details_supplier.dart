import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/actual_start_time_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/address_widget.dart';
import 'package:dingdone/view/widgets/update_job_request_customer/date_and_time_widget.dart';
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
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../widgets/update_job_request_customer/actual_end_time_widget.dart';

class JobDetailsSupplier extends StatefulWidget {
  var data;
  var fromWhere;
  var title;
  var lang;

  JobDetailsSupplier(
      {super.key,
      required this.data,
      required this.fromWhere,
      required this.lang,
      required this.title});

  @override
  State<JobDetailsSupplier> createState() => _JobDetailsSupplierState();
}

class _JobDetailsSupplierState extends State<JobDetailsSupplier> {
  bool _isLoading = false;
  bool _isLoading2 = false;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _pdfViewerKey.currentState?.openBookmarkView();
  }

  String _getServiceRate() {
    // Extract the currency from job address
    String currency = widget.data.job_address["country"];

    // Find the rate from country_rates where currency matches
    var matchingRate = widget.data.service["country_rates"].firstWhere(
      (rate) => rate["country"]['code'] == currency,
      orElse: () => null, // If no match is found, return null
    );

    if (matchingRate != null) {
      // Check the job type and return the appropriate rate
      if (widget.data.job_type == 'inspection') {
        return matchingRate['inspection_rate'].toString() ??
            'No rate available';
      } else {
        return '${matchingRate["country"]["currency"]}';
      }
    } else {
      return 'Rate not found'; // Fallback if no matching currency is found
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('job type ${widget.data.job_type}');

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
                          height: context.appValues.appSizePercent.h20,
                          color: const Color(0xff4100E3),
                        ),
                        SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          height: context.appValues.appSizePercent.h50,
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: context.appValues.appPadding.p8,
                              left: context.appValues.appPadding.p20,
                              right: context.appValues.appPadding.p20,
                            ),
                            child: SafeArea(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                          top: context.appValues.appPadding.p8,
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        )),
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  const Gap(10),
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: context.appValues.appPadding.p6,
                                    ),
                                    child: Text(
                                      translate('jobDetails.jobDetails'),
                                      style: getPrimarySemiBoldStyle(
                                        color:
                                            context.resources.color.colorWhite,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
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
            ],
          ),
          DraggableScrollableSheet(
              initialChildSize: 0.87,
              minChildSize: 0.87,
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
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: context.appValues.appPadding.p20,
                            horizontal: context.appValues.appPadding.p20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('updateJob.jobStatus'),
                              style: getPrimaryRegularStyle(
                                fontSize: 14,
                                color: const Color(0xff180B3C),
                              ),
                            ),
                            Text(
                              widget.data.status,
                              // Fallback text if no matching translation is found
                              style: getPrimarySemiBoldStyle(
                                color: const Color(0xff4100E3),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.fromWhere == translate('jobs.active') ||
                              widget.fromWhere == translate('jobs.booked')
                          ? Padding(
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
                                          context.appValues.appPadding.p10,
                                    ),
                                    child: Text(
                                      translate('bookService.customerName'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
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
                                      child: Text(
                                        widget.data.customer != null
                                            ? '${widget.data.customer["first_name"]} ${widget.data.customer["last_name"]}'
                                            : '',
                                        style: getPrimaryRegularStyle(
                                          fontSize: 14,
                                          color: const Color(0xff180B3C),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                      widget.fromWhere == translate('jobs.active')
                          ? const Gap(20)
                          : Container(),

                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p0,
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: Text(
                                translate('bookService.jobTitle'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 14,
                                  color: const Color(0xff180B3C),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p0,
                              ),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    context.appValues.appPadding.p0,
                                    0,
                                    context.appValues.appPadding.p0,
                                    0),
                                child: Text(
                                  widget.title,
                                  style: getPrimaryRegularStyle(
                                    fontSize: 14,
                                    color: const Color(0xff71727A),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(20),
                      widget.fromWhere == translate('jobs.completed')
                          ? Padding(
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
                                            context.appValues.appPadding.p10),
                                    child: Text(
                                      translate('bookService.jobDescription'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
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
                                              .data.service['translations']) {
                                            if (translation['languages_code'] ==
                                                widget.lang) {
                                              description =
                                                  translation['description'];
                                              break; // Exit loop once the match is found
                                            }
                                          }

                                          // Display the description if found, otherwise fallback to default
                                          return Text(
                                            description ??
                                                'No description available', // Fallback text if no matching translation is found
                                            style: getPrimaryRegularStyle(
                                              fontSize: 14,
                                              color: const Color(0xff71727A),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                      JobDescriptionWidget(
                          image: widget.data.uploaded_media,
                          description: widget.data.job_description),
                      // const Gap(20),
                      AddressWidget(address: widget.data.job_address),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked')
                          ? ActualStartTimeWidget(
                              actual_start_date:
                                  widget.data.actual_start_date ?? '',
                              actual_end_date: widget.data.finish_date ?? '')
                          : Container(),
                      widget.fromWhere == translate('jobs.completed')
                          ? ActualEndTimeWidget(
                              actual_start_date:
                                  widget.data.actual_start_date ?? '',
                              actual_end_date: widget.data.finish_date ?? '')
                          : Container(),
                      widget.fromWhere == translate('jobs.completed')
                          ? Padding(
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
                                            context.appValues.appPadding.p10),
                                    child: Text(
                                      translate('bookService.job_duration'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _getFormattedDuration(
                                        widget.data.actual_start_date,
                                        widget.data.finish_date),
                                    style: getPrimaryRegularStyle(
                                      fontSize: 14,
                                      color: const Color(0xff71727A),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked') &&
                              widget.fromWhere != translate('jobs.active') &&
                              widget.fromWhere != translate('jobs.completed')
                          ? JobStatusWidget(status: widget.data.status)
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked') &&
                              widget.fromWhere != translate('jobs.active') &&
                              widget.fromWhere != translate('jobs.completed')
                          ? JobTypeWidget(
                              service: widget.data.service,
                              job_type: widget.data.job_type,
                              tab: widget.fromWhere,
                            )
                          : Container(),
                      // JobCategorieAndServiceWidget(category:widget.data.service["category"]["title"],service:widget.data.service["title"]),
                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked') &&
                              widget.fromWhere != translate('jobs.active') &&
                              widget.fromWhere != translate('jobs.completed')
                          ? ServiceRateAndCurrnecyWidget(
                              currency: widget
                                      .data.service["country_rates"].isNotEmpty
                                  ? _getServiceRate()
                                  : '',
                              // currency: widget.data.currency,
                              service_rate: widget.data.job_type == 'inspection'
                                  ? _getServiceRate()
                                  : widget.data.service["country_rates"]
                                          .isNotEmpty
                                      ? '${widget.data.service["country_rates"][0]['unit_rate']} ${widget.data.service["country_rates"][0]['unit_type']}'
                                      : '',
                              fromWhere: widget.fromWhere,
                              userRole: Constants.supplierRoleId,
                            )
                          : Container(),
                      widget.fromWhere != translate('jobs.active') &&
                              widget.fromWhere != translate('jobs.completed')
                          ? DateAndTimeWidget(dateTime: widget.data.start_date)
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked') &&
                              widget.fromWhere != translate('jobs.active') &&
                              widget.fromWhere != translate('jobs.completed')
                          ? Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: Consumer2<PaymentViewModel, JobsViewModel>(
                                  builder: (context, paymentViewModel,
                                      jobsViewModel, _) {
                                debugPrint(
                                    'payment method ${paymentViewModel.paymentList}');
                                debugPrint(
                                    'payment card ${widget.data.tap_payments_card}');
                                // paymentViewModel.getPaymentMethods();
                                return PaymentMethodButtons(
                                    payment_method:
                                        paymentViewModel.paymentList,
                                    tap_payments_card:
                                        widget.data.tap_payments_card,
                                    jobsViewModel: jobsViewModel,
                                    fromWhere: widget.fromWhere,
                                    role: Constants.supplierRoleId);
                                // return PaymentMethod(
                                //     payment_method:
                                //     paymentViewModel.paymentList,
                                //   paymentViewModel: paymentViewModel,
                                //   jobsViewModel:jobsViewModel ,);
                              }),
                            )
                          : Container(),

                      // CustomerFullNameWidget(
                      //   user:
                      //       '${widget.data.customer["first_name"]} ${widget.data.customer["last_name"]}',
                      // ),
                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked')
                          ? JobSizeWidget(
                              completed_units:
                                  widget.data.completed_units ?? '',
                              number_of_units:
                                  widget.data.number_of_units ?? '',
                              extra_fees: widget.data.extra_fees ?? '',
                              extra_fees_reason:
                                  widget.data.extra_fees_reason ?? '',
                              userRole: Constants.supplierRoleId,
                              fromWhere: widget.fromWhere,
                            )
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere == translate('jobs.completed')
                          ? RatingStarsWidget(
                              stars: widget.data.rating_stars ?? 0.0,
                              userRole: Constants.supplierRoleId,
                            )
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != translate('jobs.booked') &&
                              widget.fromWhere != translate('jobs.active')
                          ? ReviewWidget(
                              review: widget.data.rating_comment ?? '')
                          : Container(),
                      widget.fromWhere == translate('jobs.active') ||
                              widget.fromWhere == translate('jobs.completed')
                          ? Padding(
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
                                            context.appValues.appPadding.p10),
                                    child: Text(
                                      // translate('home_screen.totalPrice'),
                                      translate('jobs.cost'),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          context.appValues.appPadding.p0,
                                    ),
                                    child: Text(
                                      widget.data.total_amount != null
                                          ? '${widget.data.total_amount} ${widget.data.service["country_rates"] != null && widget.data.service["country_rates"].isNotEmpty ? _getServiceRate() : ''}'
                                          : '',
                                      style: getPrimarySemiBoldStyle(
                                        color: const Color(0xff4100E3),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                      widget.fromWhere == 'request'
                          ? Padding(
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
                                            context.appValues.appPadding.p10),
                                    child: Text(
                                      widget.data.severity_level != null
                                          ? widget.data.severity_level
                                                      .toString()
                                                      .toLowerCase() ==
                                                  'major'
                                              ? 'Urgent'
                                              : 'Normal'
                                          : '',
                                      style: getPrimaryRegularStyle(
                                          fontSize: 18,
                                          color:
                                              widget.data.severity_level != null
                                                  ? widget.data.severity_level
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
                            )
                          : Container(),
                      SizedBox(height: context.appValues.appSizePercent.h2),
                      Consumer<JobsViewModel>(
                          builder: (context, jobsViewModel, _) {
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                widget.fromWhere == translate('jobs.active')
                                    ? SizedBox(
                                        width: context
                                            .appValues.appSizePercent.w35,
                                        height:
                                            context.appValues.appSizePercent.h6,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (await jobsViewModel.updateJob(
                                                    widget.data.id) ==
                                                true) {
                                              setState(() {
                                                _isLoading2 = true;
                                              });
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      simpleAlert(
                                                          context,
                                                          translate(
                                                              'button.success'),
                                                          translate(
                                                              'jobDetails.jobUpdated')));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      simpleAlert(
                                                          context,
                                                          translate(
                                                              'button.failure'),
                                                          translate(
                                                              'jobDetails.notUpdated')));
                                            }
                                            setState(() {
                                              _isLoading2 = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                            side: const BorderSide(
                                              color: Color(0xFF4100E3),
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            elevation: 0,
                                          ),
                                          child: _isLoading2
                                              ? const CircularProgressIndicator()
                                              : Text(
                                                  translate('button.update'),
                                                  style:
                                                      getPrimarySemiBoldStyle(
                                                    fontSize: 12,
                                                    color:
                                                        const Color(0xff4100E3),
                                                  ),
                                                ),
                                        ),
                                      )
                                    : widget.fromWhere == 'request'
                                        ? SizedBox(
                                            width: context
                                                .appValues.appSizePercent.w35,
                                            height: context
                                                .appValues.appSizePercent.h6,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading2 = true;
                                                });
                                                if (await jobsViewModel
                                                        .ignoreJob(
                                                            widget.data.id) ==
                                                    true) {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          simpleAlert(
                                                              context,
                                                              translate(
                                                                  'button.success'),
                                                              translate(
                                                                  'jobDetails.jobIgnored')));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          simpleAlert(
                                                              context,
                                                              translate(
                                                                  'button.failure'),
                                                              translate(
                                                                  'jobDetails.couldNotIgnored')));
                                                }
                                                setState(() {
                                                  _isLoading2 = false;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                backgroundColor:
                                                    const Color(0xffF4F3FD),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: _isLoading2
                                                  ? const CircularProgressIndicator()
                                                  : Text(
                                                      translate(
                                                          'jobDetails.ignore'),
                                                      style:
                                                          getPrimaryRegularStyle(
                                                        fontSize: 15,
                                                        color: const Color(
                                                            0xff6F6BE8),
                                                      ),
                                                    ),
                                            ),
                                          )
                                        : Container(),
                                // widget.fromWhere == translate('jobs.completed')?
                                //     Container():
                                Consumer<ProfileViewModel>(
                                    builder: (context, profileViewModel, _) {
                                  return widget.fromWhere ==
                                              translate('jobs.completed') &&
                                          profileViewModel
                                                  .getProfileBody["company"] ==
                                              null
                                      ? SizedBox(
                                          width: context
                                              .appValues.appSizePercent.w35,
                                          height: context
                                              .appValues.appSizePercent.h6,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              setState(() {
                                                _isLoading = true;
                                              });
                                              widget.fromWhere == 'request'
                                                  ? await jobsViewModel.acceptJob(
                                                              widget.data) ==
                                                          true
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => simpleAlert(
                                                              context,
                                                              translate(
                                                                  'button.success'),
                                                              translate(
                                                                  'jobDetails.jobAccepted')))
                                                      : showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) =>
                                                              simpleAlert(
                                                                  context,
                                                                  translate(
                                                                      'button.failure'),
                                                                  '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                  : widget.fromWhere ==
                                                          translate(
                                                              'jobs.active')
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) =>
                                                              showFinalData(
                                                                  context,
                                                                  jobsViewModel))
                                                      : widget.fromWhere ==
                                                              'booked'
                                                          ? await jobsViewModel.startJob(widget.data.id) ==
                                                                  true
                                                              ? showDialog(
                                                                  context:
                                                                      context,
                                                                  builder: (BuildContext context) =>
                                                                      simpleAlert(context, translate('button.success'), translate('jobDetails.jobStarted')))
                                                              : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                          : widget.fromWhere == translate('jobs.completed')
                                                              ? await jobsViewModel.downloadInvoice(widget.data.id) != null
                                                                  ? await Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => Scaffold(
                                                                              appBar: AppBar(
                                                                                title: const Text('Invoice'),
                                                                              ),
                                                                              body: SfPdfViewer.memory(jobsViewModel.file))))
                                                                  : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                              : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'));
                                              setState(() {
                                                _isLoading = false;
                                              });
                                            },
                                            style: ElevatedButton.styleFrom(
                                              elevation: 0,
                                              backgroundColor:
                                                  const Color(0xff4100E3),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: _isLoading
                                                ? const CircularProgressIndicator()
                                                : Text(
                                                    widget.fromWhere ==
                                                            'request'
                                                        ? translate(
                                                            'button.accept')
                                                        : widget.fromWhere ==
                                                                translate(
                                                                    'jobs.active')
                                                            ? translate(
                                                                'button.finish')
                                                            : widget.fromWhere ==
                                                                    'booked'
                                                                ? translate(
                                                                    'button.start')
                                                                : widget.fromWhere ==
                                                                        translate(
                                                                            'jobs.completed')
                                                                    ? translate(
                                                                        'button.invoice')
                                                                    : '',
                                                    style:
                                                        getPrimarySemiBoldStyle(
                                                      fontSize: 12,
                                                      color: context.resources
                                                          .color.colorWhite,
                                                    ),
                                                  ),
                                          ),
                                        )
                                      : Container();
                                }),
                                widget.fromWhere != translate('jobs.completed')
                                    ? SizedBox(
                                        width: context
                                            .appValues.appSizePercent.w35,
                                        height:
                                            context.appValues.appSizePercent.h6,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            widget.fromWhere == 'request'
                                                ? await jobsViewModel.acceptJob(
                                                            widget.data) ==
                                                        true
                                                    ? showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            simpleAlert(
                                                                context,
                                                                translate(
                                                                    'button.success'),
                                                                translate(
                                                                    'jobDetails.jobAccepted')))
                                                    : showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            simpleAlert(
                                                                context,
                                                                translate(
                                                                    'button.failure'),
                                                                '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                : widget.fromWhere ==
                                                        translate('jobs.active')
                                                    ? showDialog(
                                                        context: context,
                                                        builder: (BuildContext context) =>
                                                            showFinalData(
                                                                context,
                                                                jobsViewModel))
                                                    : widget.fromWhere ==
                                                            'booked'
                                                        ? await jobsViewModel.startJob(widget.data.id) ==
                                                                true
                                                            ? showDialog(
                                                                context:
                                                                    context,
                                                                builder: (BuildContext context) =>
                                                                    simpleAlert(context, translate('button.success'), translate('jobDetails.jobStarted')))
                                                            : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                        : widget.fromWhere == translate('jobs.completed')
                                                            ? await jobsViewModel.downloadInvoice(widget.data.id) != null
                                                                ? await Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder: (context) => Scaffold(
                                                                            appBar: AppBar(
                                                                              title: const Text('Invoice'),
                                                                            ),
                                                                            body: SfPdfViewer.memory(jobsViewModel.file))))
                                                                : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                                            : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'));
                                            setState(() {
                                              _isLoading = false;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            backgroundColor:
                                                const Color(0xff4100E3),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: _isLoading
                                              ? const CircularProgressIndicator()
                                              : Text(
                                                  widget.fromWhere == 'request'
                                                      ? translate(
                                                          'button.accept')
                                                      : widget.fromWhere ==
                                                              translate(
                                                                  'jobs.active')
                                                          ? translate(
                                                              'button.finish')
                                                          : widget.fromWhere ==
                                                                  'booked'
                                                              ? translate(
                                                                  'button.start')
                                                              : widget.fromWhere ==
                                                                      translate(
                                                                          'jobs.completed')
                                                                  ? translate(
                                                                      'button.invoice')
                                                                  : '',
                                                  style:
                                                      getPrimarySemiBoldStyle(
                                                    fontSize: 12,
                                                    color: context.resources
                                                        .color.colorWhite,
                                                  ),
                                                ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ));
                      }),
                    ],
                  ),
                );
              }),
        ],
      ),
    );
  }

  String _getFormattedDuration(String startDateStr, String endDateStr) {
    final DateTime startDate = DateTime.parse(startDateStr);
    final DateTime endDate = DateTime.parse(endDateStr);

    final Duration difference = endDate.difference(startDate);

    final int hours = difference.inHours;
    final int minutes = difference.inMinutes.remainder(60);

    return '$hours ${translate('jobs.hours')} $minutes ${translate('jobs.minutes')}';
  }

  Widget simpleAlert(BuildContext context, String message, String message2) {
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
                    Future.delayed(const Duration(seconds: 0),
                        () => Navigator.of(context).pop());
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
              message2,
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

  Widget showFinalData(BuildContext context, JobsViewModel jobsViewModel) {
    return jobsViewModel.jobUpdated
        ? AlertDialog(
            backgroundColor: Colors.white,
            elevation: 15,
            content: Column(
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
                          Future.delayed(const Duration(seconds: 0),
                              () => Navigator.of(context).pop());
                        },
                      ),
                    ],
                  ),
                ),
                // message == 'Success'
                //     ?
                // SvgPicture.asset('assets/img/service-popup-image.svg')
                //     : SvgPicture.asset('assets/img/failure.svg'),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Completed Units: ${jobsViewModel.updatedBody["completed_units"] ?? widget.data.completed_units}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Current number of units: ${jobsViewModel.updatedBody["number_of_units"] ?? widget.data.number_of_units}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Extra Fees: ${jobsViewModel.updatedBody["extra_fees"] ?? widget.data.extra_fees}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Extra Fees Reason: ${jobsViewModel.updatedBody["extra_fees_reason"] ?? widget.data.extra_fees_reason}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: context.resources.color.btnColorBlue,
                    ),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s20),
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('data in finish ${widget.data.customer['id']}');
                    // if(await jobsViewModel.payFees(widget.data.id,widget.data.customer['id']) == true) {
                    if (await jobsViewModel
                            .finishJobAndCollectPayment(widget.data.id) ==
                        true) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              simpleAlert(context, 'Success', 'Job finished'));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => simpleAlert(
                              context,
                              'Failure',
                              'Something went wrong while finishing job \n${jobsViewModel.errorMessage}'));
                    }
                    // }else {
                    //   showDialog(
                    //       context: context,
                    //       builder: (BuildContext context) => simpleAlert(
                    //           context,
                    //           'Failure',
                    //           'Something went wrong while paying job\n${jobsViewModel.errorMessage}'));
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Color(0xff4100E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(
                      context.appValues.appSizePercent.w30,
                      context.appValues.appSizePercent.h5,
                    ),
                  ),
                  child: Text(
                    'Finish',
                    style: getPrimaryRegularStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: context.appValues.appSize.s20),
              ],
            ),
          )
        : AlertDialog(
            backgroundColor: Colors.white,
            elevation: 15,
            content: Column(
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
                // message == 'Success'
                //     ?
                // SvgPicture.asset('assets/img/service-popup-image.svg')
                //     : SvgPicture.asset('assets/img/failure.svg'),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Make sure to update data before finishing',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Gap(7),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Completed Units: ${widget.data.completed_units ?? ''}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      // color: context.resources.color.btnColorBlue,
                      color: Color(0xff4100E3),
                    ),
                  ),
                ),
                const Gap(7),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Current number of units: ${widget.data.number_of_units ?? ''}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: Color(0xff4100E3),
                    ),
                  ),
                ),
                const Gap(7),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Extra Fees: ${widget.data.extra_fees ?? ''}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: Color(0xff4100E3),
                    ),
                  ),
                ),
                const Gap(7),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Extra Fees Reason: ${widget.data.extra_fees_reason ?? ''}',
                    textAlign: TextAlign.center,
                    style: getPrimaryRegularStyle(
                      fontSize: 17,
                      color: Color(0xff4100E3),
                    ),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s20),
                ElevatedButton(
                  onPressed: () async {
                    if (await jobsViewModel
                            .finishJobAndCollectPayment(widget.data.id) ==
                        true) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              simpleAlert(context, 'Success', 'Job finished'));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => simpleAlert(
                              context,
                              'Failure \n${jobsViewModel.errorMessage}',
                              'Something went wrong'));
                    }

                    // await jobsViewModel.finishJob(widget.data.id);
                    // Navigator.pop(context);
                    //
                    // new Future.delayed(const Duration(seconds: 0), () =>
                    //     showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             simpleAlert(
                    //                 context,'Success' ,'Job finished')));
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Color(0xff4100E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(
                      context.appValues.appSizePercent.w30,
                      context.appValues.appSizePercent.h5,
                    ),
                  ),
                  child: Text(
                    'Finish Job',
                    style: getPrimaryRegularStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: context.appValues.appSize.s20),
              ],
            ),
          );
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
