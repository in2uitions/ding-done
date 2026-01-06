import 'dart:io';

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
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
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
    try {
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
    }catch(error){
      return 'Rate not found'; // Fallback if no matching currency is found

    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('job country_rates ${ widget.data.service['country_rates'][0]['minimum_order']}');

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
                                      'jobDetails.jobDetails'.tr(),
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
                              'updateJob.jobStatus'.tr(),
                              style: getPrimaryRegularStyle(
                                fontSize: 14,
                                color: const Color(0xff180B3C),
                              ),
                            ),
                            Text(
                              widget.data.status=='inprogress'?'in progress':widget.data.status,
                              // Fallback text if no matching translation is found
                              style: getPrimarySemiBoldStyle(
                                color: const Color(0xff4100E3),
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      widget.fromWhere == 'jobs.active'.tr() ||
                              widget.fromWhere =='jobs.booked'.tr()
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
                                      'bookService.customerName'.tr(),
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

                      widget.fromWhere == 'jobs.active'.tr()
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
                                'bookService.jobTitle'.tr(),
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
                      widget.fromWhere == 'jobs.completed'.tr()
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
                                      'bookService.jobDescription'.tr(),
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
                      // const Gap(20),
                      widget.fromWhere =='jobs.completed'.tr()
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
                                  context.appValues.appPadding.p0),
                              child: Text(
                              'bookService.customerName'.tr(),
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
                                child:
                                     Text(
                                     '${ widget.data.customer['first_name']} ${widget.data.customer['last_name']}' ??
                                          '', // Fallback text if no matching translation is found
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff71727A),
                                      ),
                                    ),

                              ),
                            ),
                          ],
                        ),
                      )
                          : Container(),

                      AddressWidget(address: widget.data.job_address),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != 'jobs.booked'.tr()
                          ? ActualStartTimeWidget(
                              actual_start_date:
                                  widget.data.actual_start_date ?? '',
                              actual_end_date: widget.data.finish_date ?? '')
                          : Container(),
                      widget.fromWhere == 'jobs.completed'.tr()
                          ? ActualEndTimeWidget(
                              actual_start_date:
                                  widget.data.actual_start_date ?? '',
                              actual_end_date: widget.data.finish_date ?? '')
                          : Container(),
                      widget.fromWhere == 'jobs.completed'.tr()
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
                                      'bookService.job_duration'.tr(),
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    _getFormattedDuration(
                                        widget.data.actual_start_date??DateTime.now().toString(),
                                        widget.data.finish_date??DateTime.now().toString()),
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
                              widget.fromWhere != 'jobs.booked'.tr() &&
                              widget.fromWhere != 'jobs.active'.tr() &&
                              widget.fromWhere != 'jobs.completed'.tr()
                          ? JobStatusWidget(status: widget.data.status)
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != 'jobs.booked'.tr() &&
                              widget.fromWhere !='jobs.active'.tr() &&
                              widget.fromWhere != 'jobs.completed'.tr()
                          ? JobTypeWidget(
                              service: widget.data.service,
                              job_type: widget.data.job_type,
                              tab: widget.fromWhere,
                            )
                          : Container(),
                      // JobCategorieAndServiceWidget(category:widget.data.service["category"]["title"],service:widget.data.service["title"]),
                      widget.fromWhere != 'request' &&
                              widget.fromWhere != 'jobs.booked'.tr() &&
                              widget.fromWhere != 'jobs.active'.tr() &&
                              widget.fromWhere != 'jobs.completed'.tr()
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
                      widget.fromWhere != 'jobs.active'.tr() &&
                              widget.fromWhere != 'jobs.completed'.tr()
                          ? DateAndTimeWidget(dateTime: widget.data.start_date)
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != 'jobs.booked'.tr() &&
                              widget.fromWhere != 'jobs.active'.tr() &&
                              widget.fromWhere != 'jobs.completed'.tr()
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
                              widget.fromWhere != 'jobs.booked'.tr()
                          ? JobSizeWidget(
                        minimum_order:widget.data.service['country_rates'][0]['minimum_order']!=0 && widget.data.service['country_rates'][0]['minimum_order']!=null ?int.parse(widget.data.service['country_rates'][0]['minimum_order'].toString()) : 1,
                              completed_units:widget.data.completed_units!=0 && widget.data.completed_units!=null?widget.data.completed_units:
                                  widget.data.service['country_rates'][0]['minimum_order']!=0 && widget.data.service['country_rates'][0]['minimum_order']!=null ?int.parse(widget.data.service['country_rates'][0]['minimum_order'].toString()) : 1,
                              number_of_units:
                                  widget.data.number_of_units ?? 1,
                              extra_fees: widget.data.extra_fees ?? '',
                              extra_fees_reason:
                                  widget.data.extra_fees_reason ?? '',
                              userRole: Constants.supplierRoleId,
                              fromWhere: widget.fromWhere,
                            )
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere == 'jobs.completed'.tr()
                          ? RatingStarsWidget(
                              stars: widget.data.rating_stars ?? 0.0,
                              userRole: Constants.supplierRoleId,
                            )
                          : Container(),

                      widget.fromWhere != 'request' &&
                              widget.fromWhere != 'jobs.booked'.tr() &&
                              widget.fromWhere != 'jobs.active'.tr()
                          ? ReviewWidget(
                              review: widget.data.rating_comment ?? '')
                          : Container(),
                      widget.fromWhere == 'jobs.active'.tr() ||
                              widget.fromWhere == 'jobs.completed'.tr()
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
                                      'jobs.cost'.tr(),
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
                                      widget.data.total_amount != null && widget.data.total_amount.toString()!=''
                                          ? '${widget.data.total_amount} ${widget.data.service["country_rates"] != null && widget.data.service["country_rates"].isNotEmpty ?  widget.data.service["country_rates"][0]["country"] is String?widget.data.service["country_rates"][0]["country"]:widget.data.service["country_rates"][0]["country"]["currency"] : ''}'
                                          : '${widget.data.service["country_rates"] != null ? widget.data.number_of_units != null ? ( widget.data.service["country_rates"][0]["unit_rate"] *  widget.data.number_of_units) : ( widget.data.service["country_rates"][0]["unit_rate"] * widget.data.service["country_rates"][0]["minimum_order"]) : ''} ${ widget.data.service["country_rates"] != null ?  widget.data.service["country_rates"][0]["country"] is String?widget.data.service["country_rates"][0]["country"]:widget.data.service["country_rates"][0]["country"]["currency"] : ''}',
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
                                              : 'Scheduled'
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
                                widget.fromWhere == 'jobs.active'.tr()
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
                                                      _buildPopupDialogSuccess(
                                                          context,
                                                              'jobDetails.jobUpdated'.tr()
                                                          ));
                                            } else {
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext
                                                          context) =>
                                                      _buildPopupDialogFailure(
                                                          context,
                                                              'jobDetails.notUpdated'.tr()
                                                          ));
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
                                                  'button.update'.tr(),
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
                                                          _buildPopupDialogSuccess(
                                                              context,
                                                                  'jobDetails.jobIgnored'.tr()
                                                             ));
                                                } else {
                                                  showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                              context) =>
                                                          _buildPopupDialogFailure(
                                                              context,
                                                                  'jobDetails.couldNotIgnored'.tr()
                                                             ));
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
                                                          'jobDetails.ignore'.tr(),
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
                                            'jobs.completed'.tr() &&
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
                                              var supplierLatitude=profileViewModel.getProfileBody['current_address']['latitude'];
                                              var supplierLongitude=profileViewModel.getProfileBody['current_address']['longitude'];
                                              widget.fromWhere == 'request'
                                                  ? await jobsViewModel.acceptJob(
                                                              widget.data,supplierLatitude,supplierLongitude) ==
                                                          true
                                                      ? showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) => _buildPopupDialogSuccess(
                                                              context,
                                                                  'jobDetails.jobAccepted'.tr()
                                                              ))
                                                      : showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) =>
                                                              _buildPopupDialogFailure(
                                                                  context,
                                                                  '${jobsViewModel.errorMessage}'
                                                                 ))
                                                  : widget.fromWhere ==

                                                              'jobs.active'.tr()
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
                                                                      _buildPopupDialogSuccess(context, 'jobDetails.jobStarted'.tr()))
                                                              : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context, '${jobsViewModel.errorMessage}'))
                                                          : widget.fromWhere == 'jobs.completed'.tr()
                                                              ? await jobsViewModel.downloadInvoice(widget.data.id) != null
                                                                  ? await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Scaffold(
                                                    appBar: AppBar(
                                                      title: const Text('Invoice'),
                                                      actions: [
                                                        IconButton(
                                                          icon: const Icon(Icons.print),
                                                          onPressed: () async {
                                                            await Printing.layoutPdf(
                                                              onLayout: (_) async => jobsViewModel.file,
                                                            );
                                                          },
                                                        ),
                                                        IconButton(
                                                          icon: const Icon(Icons.share),
                                                          onPressed: () async {
                                                            final directory = await getTemporaryDirectory();
                                                            final filePath = '${directory.path}/invoice.pdf';
                                                            final file = File(filePath);
                                                            await file.writeAsBytes(jobsViewModel.file);

                                                            Share.shareXFiles([XFile(filePath)], text: 'Here is your invoice.');
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                    body: SfPdfViewer.memory(jobsViewModel.file),
                                                  ),
                                                ),
                                              )
                                                                  : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context, '${jobsViewModel.errorMessage}'))
                                                              : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context, '${jobsViewModel.errorMessage}'));
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
                                                        ?
                                                            'button.accept'.tr()
                                                        : widget.fromWhere ==

                                                                    'jobs.active'.tr()
                                                            ?
                                                                'button.finish'.tr()
                                                            : widget.fromWhere ==
                                                                    'booked'
                                                                ?
                                                                    'button.start'.tr()
                                                                : widget.fromWhere ==

                                                                            'jobs.completed'.tr()
                                                                    ?
                                                                        'button.invoice'.tr()
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
                                widget.fromWhere != 'jobs.completed'.tr()
                                    ?  Consumer<ProfileViewModel>(
                                    builder: (context, profileViewModel, _) {
                                        return SizedBox(
                                            width: context
                                                .appValues.appSizePercent.w35,
                                            height:
                                                context.appValues.appSizePercent.h6,
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                setState(() {
                                                  _isLoading = true;
                                                });
                                                var supplierLatitude=profileViewModel.getProfileBody['current_address']['latitude'];
                                                var supplierLongitude=profileViewModel.getProfileBody['current_address']['longitude'];
                                                final rootContext = context;
                                                widget.fromWhere == 'request'
                                                    ? await jobsViewModel.acceptJob(
                                                                widget.data,supplierLatitude,supplierLongitude) ==
                                                            true
                                                        ? showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) =>
                                                                _buildPopupDialogSuccess(
                                                                    context,

                                                                        'jobDetails.jobAccepted'.tr()
                                                                   ))
                                                        : showDialog(
                                                            context: context,
                                                            builder: (BuildContext context) =>
                                                                _buildPopupDialogFailure(
                                                                    context,
                                                                    ' ${jobsViewModel.errorMessage}'.tr()))
                                                    : widget.fromWhere ==
                                                            'jobs.active'.tr()
                                                        ? showDialog(
                                                  context: rootContext,
                                                  builder: (_) => showFinalData(rootContext, jobsViewModel),
                                                )
                                                        : widget.fromWhere ==
                                                                'booked'
                                                            ? await jobsViewModel.startJob(widget.data.id) ==
                                                                    true
                                                                ? showDialog(
                                                                    context:
                                                                        context,
                                                                    builder: (BuildContext context) =>
                                                                        _buildPopupDialogSuccess(context,'jobDetails.jobStarted'.tr()))
                                                                : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context, '${jobsViewModel.errorMessage}'))
                                                            : widget.fromWhere == 'jobs.completed'.tr()
                                                                ? await jobsViewModel.downloadInvoice(widget.data.id) != null
                                                                    ? await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => Scaffold(
                                                      appBar: AppBar(
                                                        title: const Text('Invoice'),
                                                        actions: [
                                                          IconButton(
                                                            icon: const Icon(Icons.print),
                                                            onPressed: () async {
                                                              await Printing.layoutPdf(
                                                                onLayout: (_) async => jobsViewModel.file,
                                                              );
                                                            },
                                                          ),
                                                          IconButton(
                                                            icon: const Icon(Icons.share),
                                                            onPressed: () async {
                                                              final directory = await getTemporaryDirectory();
                                                              final filePath = '${directory.path}/invoice.pdf';
                                                              final file = File(filePath);
                                                              await file.writeAsBytes(jobsViewModel.file);

                                                              Share.shareXFiles([XFile(filePath)], text: 'Here is your invoice.');
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                      body: SfPdfViewer.memory(jobsViewModel.file),
                                                    ),
                                                  ),
                                                )
                                                                    : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context,'${jobsViewModel.errorMessage}'))
                                                                : showDialog(context: context, builder: (BuildContext context) => _buildPopupDialogFailure(context,'${jobsViewModel.errorMessage}'));
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
                                                          ?
                                                              'button.accept'.tr()
                                                          : widget.fromWhere ==

                                                                      'jobs.active'.tr()
                                                              ?
                                                                  'button.finish'.tr()
                                                              : widget.fromWhere ==
                                                                      'booked'
                                                                  ?
                                                                      'button.start'.tr()
                                                                  : widget.fromWhere ==

                                                                              'jobs.completed'.tr()
                                                                      ?
                                                                          'button.invoice'.tr()
                                                                      : '',
                                                      style:
                                                          getPrimarySemiBoldStyle(
                                                        fontSize: 12,
                                                        color: context.resources
                                                            .color.colorWhite,
                                                      ),
                                                    ),
                                            ),
                                          );
                                      }
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

    return '$hours ${'jobs.hours'.tr()} $minutes ${'jobs.minutes'.tr()}';
  }

  // Widget simpleAlert(BuildContext context, String message, String message2) {
  //   return AlertDialog(
  //     backgroundColor: Colors.white,
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
  //                   Future.delayed(const Duration(seconds: 0),
  //                       () => Navigator.of(context).pop());
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         message == 'Success'
  //             ? SvgPicture.asset('assets/img/service-popup-image.svg')
  //             : SvgPicture.asset('assets/img/failure.svg'),
  //         SizedBox(height: context.appValues.appSize.s40),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             message2,
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: context.appValues.appSize.s20),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildPopupDialogSuccess(BuildContext context,String message) {
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
                  onTap: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(seconds: 0));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SvgPicture.asset('assets/img/booking-confirmation-icon.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              'button.success'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                  fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 15,
                color: context.resources.color.secondColorBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildPopupDialogFailure(BuildContext context,String message) {
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
                  onTap: () async {
                    Navigator.pop(context);
                    await Future.delayed(const Duration(seconds: 0));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          SvgPicture.asset('assets/img/failure.svg'),
          SizedBox(height: context.appValues.appSize.s40),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
             'button.failure'.tr(),
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                  fontSize: 17, color: context.resources.color.btnColorBlue),
            ),
          ),
          SizedBox(height: context.appValues.appSize.s20),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p32,
            ),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 15,
                color: context.resources.color.secondColorBlue,
              ),
            ),
          ),
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
                    '${'updateJob.actualNumberOfUnits'.tr()}: ${jobsViewModel.updatedBody["completed_units"] ?? widget.data.completed_units}',
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
                    '${'updateJob.estimatedNumberOfUnits'.tr()}: ${jobsViewModel.updatedBody["number_of_units"] ?? widget.data.number_of_units}',
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
                    Navigator.of(context, rootNavigator: true).pop();
                    if (await jobsViewModel.updateJob(
                        widget.data.id) ==
                        true && await jobsViewModel
                            .finishJobAndCollectPayment(widget.data.id) ==
                        true) {

                      Future.delayed(const Duration(milliseconds: 100), () {
                        showDialog(
                          context: context, // <- this must be the original parentContext
                          builder: (BuildContext _) =>
                              _buildPopupDialogSuccess(context, 'Job Done'), // use parentContext
                        );
                      });
                    } else {
                      debugPrint('job is not  done ');

                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialogFailure(
                              context,
                              'Something went wrong while finishing job \n${jobsViewModel.errorMessage}',
                              ));
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
                    '${'updateJob.estimatedNumberOfUnits'.tr()}: ${widget.data.number_of_units ?? ''}',
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
                    Navigator.of(context, rootNavigator: true).pop();
                    if (await jobsViewModel.updateJob(
                        widget.data.id) ==
                        true && await jobsViewModel
                            .finishJobAndCollectPayment(widget.data.id) ==
                        true) {

                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogSuccess(context, 'Job Done'));
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialogFailure(
                              context,
                              '${jobsViewModel.errorMessage}',
                             ));
                    }

                    // await jobsViewModel.finishJob(widget.data.id);
                    // Navigator.pop(context);
                    //
                    // new Future.delayed(const Duration(seconds: 0), () =>
                    //     showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             simpleAlert(
                    //                 context,'Success' ,'Job Done')));
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor: Color(0xff4100E3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: Size(
                      context.appValues.appSizePercent.w40,
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
