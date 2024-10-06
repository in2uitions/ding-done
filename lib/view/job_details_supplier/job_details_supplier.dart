// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

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
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
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
  @override
  Widget build(BuildContext context) {
    debugPrint('job type ${widget.data.job_type}');



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
                children: [
                  SafeArea(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                            context.appValues.appPadding.p20,
                            0,
                            context.appValues.appPadding.p20,
                            0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Gap(10),
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
                                // color: context.resources.color.colorYellow,
                                color: const Color(0xff38385E),
                                fontSize: 32,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // DraggableScrollableSheet(
              //   initialChildSize: 0.55,
              //   minChildSize: 0.55,
              //   maxChildSize: 1,
              //   builder:
              //       (BuildContext context, ScrollController scrollController) {
              //     return Container(
              //       decoration: const BoxDecoration(
              //         borderRadius: BorderRadius.only(
              //           topLeft: Radius.circular(30),
              //           topRight: Radius.circular(30),
              //         ),
              //         color: Color(0xffFEFEFE),
              //       ),
              //       child: ListView.builder(
              //         controller: scrollController,
              //         itemCount: 1,
              //         itemBuilder: (BuildContext context, int index) {
              //           return Column(
              //             children: [],
              //           );
              //         },
              //       ),
              //     );
              //   },
              // ),
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
                              horizontal: context.appValues.appPadding.p0,
                              vertical: context.appValues.appPadding.p10,
                            ),
                            child: Text(
                              translate('bookService.customerName'),
                              style: getPrimaryBoldStyle(
                                fontSize: 20,
                                color: const Color(0xff38385E),
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
                                0,
                              ),
                              child: Text(
                                widget.data.customer != null
                                    ? '${widget.data.customer["first_name"]} ${widget.data.customer["last_name"]}'
                                    : '',
                                style: getPrimaryRegularStyle(
                                  // color: context.resources.color.colorYellow,
                                  color: const Color(0xff38385E),
                                  fontSize: 20,
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
                        style: getPrimaryBoldStyle(
                          fontSize: 20,
                          color: const Color(0xff38385E),
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
                            // color: context.resources.color.colorYellow,
                            color: const Color(0xff38385E),
                            fontSize: 20,
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
                                horizontal: context.appValues.appPadding.p0,
                                vertical: context.appValues.appPadding.p10),
                            child: Text(
                              translate('bookService.jobDescription'),
                              style: getPrimaryBoldStyle(
                                fontSize: 20,
                                color: const Color(0xff38385E),
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
                                0,
                              ),
                              child: Builder(
                                builder: (context) {
                                  String? description;
                                  for (var translation in widget.data.service['translations']) {
                                    if (translation['languages_code'] == widget.lang) {
                                      description = translation['description'];
                                      break; // Exit loop once the match is found
                                    }
                                  }

                                  // Display the description if found, otherwise fallback to default
                                  return Text(
                                    description ?? 'No description available',  // Fallback text if no matching translation is found
                                    style: getPrimaryRegularStyle(
                                      color: const Color(0xff180C38),
                                      fontSize: 20,
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
                      actual_start_date: widget.data.actual_start_date ?? '',
                      actual_end_date: widget.data.finish_date ?? '')
                  : Container(),
              widget.fromWhere == translate('jobs.completed')
                  ? ActualEndTimeWidget(
                      actual_start_date: widget.data.actual_start_date ?? '',
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
                                horizontal: context.appValues.appPadding.p0,
                                vertical: context.appValues.appPadding.p10),
                            child: Text(
                              translate('bookService.job_duration'),
                              style: getPrimaryBoldStyle(
                                fontSize: 20,
                                color: const Color(0xff38385E),
                              ),
                            ),
                          ),
                          Text(
                            _getFormattedDuration(widget.data.actual_start_date,
                                widget.data.finish_date),
                            style: getPrimaryRegularStyle(
                              color: const Color(0xff38385E),
                              fontSize: 20,
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
                      currency: widget.data.service["country_rates"].isNotEmpty
                          ? widget.data.service["country_rates"][0]["country"]
                              ["curreny"]
                          : '',
                      // currency: widget.data.currency,
                      service_rate: widget.data.job_type == 'inspection'
                          ? widget.data.service["country_rates"][0]
                              ['inspection_rate']
                          : widget.data.service["country_rates"].isNotEmpty
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
                      child: Consumer2<PaymentViewModel, JobsViewModel>(builder:
                          (context, paymentViewModel, jobsViewModel, _) {
                        debugPrint(
                            'payment method ${paymentViewModel.paymentList}');
                        debugPrint('payment card ${widget.data.payment_card}');
                        // paymentViewModel.getPaymentMethods();
                        return PaymentMethodButtons(
                            payment_method: paymentViewModel.paymentList,
                            payment_card: widget.data.payment_card,
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
                      completed_units: widget.data.completed_units ?? '',
                      number_of_units: widget.data.number_of_units ?? '',
                      extra_fees: widget.data.extra_fees ?? '',
                      extra_fees_reason: widget.data.extra_fees_reason ?? '',
                      userRole: Constants.supplierRoleId,
                      fromWhere: widget.fromWhere,
                    )
                  : Container(),

              widget.fromWhere != 'request' &&
                      widget.fromWhere != translate('jobs.booked')
                  ? RatingStarsWidget(stars: widget.data.rating_stars ?? 0.0)
                  : Container(),

              widget.fromWhere != 'request' &&
                      widget.fromWhere != translate('jobs.booked') &&
                      widget.fromWhere != translate('jobs.active')
                  ? ReviewWidget(review: widget.data.rating_comment ?? '')
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
                                horizontal: context.appValues.appPadding.p0,
                                vertical: context.appValues.appPadding.p10),
                            child: Text(
                              // translate('home_screen.totalPrice'),
                              translate('jobs.cost'),
                              style: getPrimaryBoldStyle(
                                fontSize: 20,
                                color: const Color(0xff38385E),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p0,
                            ),
                            child: Text(
                              widget.data.total_amount != null
                                  ? '${widget.data.total_amount} ${widget.data.service["country_rates"] != null && widget.data.service["country_rates"].isNotEmpty ? widget.data.service["country_rates"][0]["country"]["curreny"] : ''}'
                                  : '',
                              style: getPrimaryRegularStyle(
                                color: const Color(0xff78789D),
                                fontSize: 18,
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
                                horizontal: context.appValues.appPadding.p0,
                                vertical: context.appValues.appPadding.p10),
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
                                  color: widget.data.severity_level != null
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        widget.fromWhere == translate('jobs.active')
                            ? SizedBox(
                                width: context.appValues.appSizePercent.w45,
                                height: context.appValues.appSizePercent.h7,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (await jobsViewModel
                                            .updateJob(widget.data.id) ==
                                        true) {
                                      setState(() {
                                        _isLoading2 = true;
                                      });
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(
                                                  context,
                                                  translate('button.success'),
                                                  translate(
                                                      'jobDetails.jobUpdated')));
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(
                                                  context,
                                                  translate('button.failure'),
                                                  translate(
                                                      'jobDetails.notUpdated')));
                                    }
                                    setState(() {
                                      _isLoading2 = false;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xffF4F3FD),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  child: _isLoading2
                                      ? const CircularProgressIndicator()
                                      : Text(
                                          translate('button.update'),
                                          style: getPrimaryBoldStyle(
                                            fontSize: 18,
                                            color: const Color(0xff6F6BE8),
                                          ),
                                        ),
                                ),
                              )
                            : widget.fromWhere == 'request'
                                ? SizedBox(
                                    width: context.appValues.appSizePercent.w45,
                                    height: context.appValues.appSizePercent.h7,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        setState(() {
                                          _isLoading2 = true;
                                        });
                                        if (await jobsViewModel
                                                .ignoreJob(widget.data.id) ==
                                            true) {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  simpleAlert(
                                                      context,
                                                      translate(
                                                          'button.success'),
                                                      translate(
                                                          'jobDetails.jobIgnored')));
                                        } else {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
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
                                              BorderRadius.circular(15),
                                        ),
                                      ),
                                      child: _isLoading2
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              translate('jobDetails.ignore'),
                                              style: getPrimaryBoldStyle(
                                                fontSize: 18,
                                                color: const Color(0xff6F6BE8),
                                              ),
                                            ),
                                    ),
                                  )
                                : Container(),
                        SizedBox(
                          width: context.appValues.appSizePercent.w45,
                          height: context.appValues.appSizePercent.h7,
                          child: ElevatedButton(
                            onPressed: () async {
                              debugPrint('wefjweoifj ${widget.fromWhere}');

                              setState(() {
                                _isLoading = true;
                              });
                              widget.fromWhere == 'request'
                                  ? await jobsViewModel.acceptJob(widget.data) ==
                                          true
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(
                                                  context,
                                                  translate('button.success'),
                                                  translate(
                                                      'jobDetails.jobAccepted')))
                                      : showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              simpleAlert(
                                                  context,
                                                  translate('button.failure'),
                                                  '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                  : widget.fromWhere == translate('jobs.active')
                                      ? showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              showFinalData(
                                                  context, jobsViewModel))
                                      : widget.fromWhere == 'booked'
                                          ? await jobsViewModel.startJob(
                                                      widget.data.id) ==
                                                  true
                                              ? showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) =>
                                                      simpleAlert(
                                                          context,
                                                          translate('button.success'),
                                                          translate('jobDetails.jobStarted')))
                                              : showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                          : widget.fromWhere == translate('jobs.completed')
                                              ? await Navigator.push(
                                context,
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                      appBar: AppBar(
                                        title: const Text('Invoice'),
                                      ),
                                      body: FutureBuilder<File?>(
                                        future: jobsViewModel.downloadInvoice(widget.data.id), // Assume this returns the file from the download
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                            final File file = snapshot.data!;

                                            // Check if the file exists and print file path and size
                                            if (file.existsSync()) {
                                              debugPrint('File path: ${file.path}');
                                              debugPrint('File size: ${file.lengthSync()} bytes');
                                            } else {
                                              debugPrint('File does not exist at path: ${file.path}');
                                            }

                                            // Use SfPdfViewer.file() with the valid file path
                                            return SfPdfViewer.file(file);
                                          } else if (snapshot.hasError) {
                                            return Center(child: Text('Error loading PDF: ${snapshot.error}'));
                                          } else {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                        },
                                      ),
                                    ),

                                  )

                              )
                              :showDialog(context: context, builder: (BuildContext context) => simpleAlert(context, translate('button.failure'), '${translate('button.failure')} \n ${jobsViewModel.errorMessage}'))
                                              ;
                              setState(() {
                                _isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              backgroundColor: const Color(0xff4100E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    widget.fromWhere == 'request'
                                        ? translate('button.accept')
                                        : widget.fromWhere == translate('jobs.active')
                                            ? translate('button.finish')
                                            : widget.fromWhere == 'booked'
                                                ? translate('button.start')
                                                : widget.fromWhere ==
                                                        translate('jobs.completed')
                                                    ? translate(
                                                        'button.invoice')
                                                    : '',
                                    style: getPrimaryBoldStyle(
                                      fontSize: 18,
                                      color: context.resources.color.colorWhite,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ));
              }),
            ],
          ),
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
                    if(await jobsViewModel.payFees(widget.data.id,widget.data.customer['id']) == true) {
                      if (await jobsViewModel.finishJob(widget.data.id) ==
                          true) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                simpleAlert(
                                    context, 'Success', 'Job finished'));
                      }else{
                        showDialog(
                            context: context,
                            builder: (BuildContext context) => simpleAlert(
                                context,
                                'Failure',
                                'Something went wrong while finishing job \n${jobsViewModel.errorMessage}'));
                      }
                    }else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => simpleAlert(
                              context,
                              'Failure',
                              'Something went wrong while paying job\n${jobsViewModel.errorMessage}'));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0.0,
                    shadowColor: Colors.transparent,
                    backgroundColor: context.resources.color.btnColorBlue,
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
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p32,
                  ),
                  child: Text(
                    'Completed Units: ${widget.data.completed_units ?? ''}',
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
                    'Current number of units: ${widget.data.number_of_units ?? ''}',
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
                    'Extra Fees: ${widget.data.extra_fees ?? ''}',
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
                    'Extra Fees Reason: ${widget.data.extra_fees_reason ?? ''}',
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
                    if (await jobsViewModel.finishJob(widget.data.id) == true) {
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
                    backgroundColor: context.resources.color.btnColorBlue,
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
