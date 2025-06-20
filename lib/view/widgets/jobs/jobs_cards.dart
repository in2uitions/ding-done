// ignore_for_file: use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/job_details_supplier/job_details_supplier.dart';
import 'package:dingdone/view/update_job_request_customer/update_job_request_customer.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class JobsCards extends StatefulWidget {
  var active;
  var userRole;
  var jobsViewModel;
  var lang;
  final ScrollController? scrollController;

  JobsCards({
    super.key,
    required this.active,
    required this.userRole,
    required this.jobsViewModel,
    required this.lang,
    this.scrollController,
  });

  @override
  State<JobsCards> createState() => _JobsCardsState();
}

class _JobsCardsState extends State<JobsCards> {
  var data;
  String? role;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<LoginViewModel, JobsViewModel, PaymentViewModel>(
        builder: (context, loginViewModel, jobsViewModel, paymentViewModel, _) {
      data = Constants.supplierRoleId == widget.userRole
          ? widget.active == 'activeJobs'
              ? widget.jobsViewModel.supplierInProgressJobs
              : widget.active == 'completedJobs'
                  ? widget.jobsViewModel.supplierCompletedJobs
                  : widget.jobsViewModel.supplierBookedJobs
          : widget.active == 'activeJobs'
              ? widget.jobsViewModel.getcustomerJobs
                  .where((e) => e.status == 'inprogress')
                  .toList()
              : widget.active == 'completedJobs'
                  ? widget.jobsViewModel.getcustomerJobs
                      .where((e) => e.status == 'completed')
                      .toList()
                  : widget.active == 'requestedJobs'
                      ? widget.jobsViewModel.getcustomerJobs
                          .where((e) =>
                              e.status == 'circulating' || e.status == 'draft')
                          .toList()
                      : widget.jobsViewModel.getcustomerJobs
                          .where((e) => e.status == 'booked')
                          .toList();
      return Padding(
        padding: const EdgeInsets.only(bottom: 150),
        child: ListView.builder(
            controller: widget.scrollController,
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: data!=null? data.length:0,
            // physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              Map<String, dynamic>? services;
              for (Map<String, dynamic> translation in data[index].service != null
                  ? data[index].service["translations"]
                  : []) {
                if (translation["languages_code"] == widget.lang) {
                  services = translation;
                  break; // Break the loop once the translation is found
                }
              }

              return InkWell(
                onTap: () {
                  debugPrint(
                      'uploaded media on tap ${data[index].uploaded_media}');
                  widget.userRole == Constants.supplierRoleId
                      ? paymentViewModel
                          .getCustomerPayments(data[index].customer["id"])
                      : debugPrint(
                          'i am a customer ${data[index].customer["id"]}');

                  widget.userRole == Constants.supplierRoleId
                      ? Navigator.of(context)
                          .push(_createRoute(JobDetailsSupplier(
                          data: data[index],
                          fromWhere: widget.active == 'activeJobs'
                              ? translate('jobs.active')
                              : widget.active == 'completedJobs'
                                  ? translate('jobs.completed')
                                  : translate('jobs.booked'),
                          title: services?["title"].toString(),
                          lang: widget.lang,
                        )))
                      : Navigator.of(context)
                          .push(_createRoute(UpdateJobRequestCustomer(
                          data: data[index],
                          title: services?["title"].toString(),
                          fromWhere: widget.active == 'activeJobs'
                              ? translate('jobs.active')
                              : widget.active == 'completedJobs'
                                  ? translate('jobs.completed')
                                  : widget.active == 'requestedJobs'
                                      ? translate('jobs.requestedJobs')
                                      : translate('jobs.booked'),
                          lang: widget.lang,
                        )));
                },
                child: Padding(
                  padding: EdgeInsets.all(context.appValues.appPadding.p10),
                  child: Container(
                    width: context.appValues.appSizePercent.w100,
                    // height: context.appValues.appSizePercent.h45,
                    decoration: BoxDecoration(
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: const Color(0xff000000).withOpacity(0.1),
                      //     spreadRadius: 1,
                      //     blurRadius: 5,
                      //     offset:
                      //         const Offset(0, 3), // changes position of shadow
                      //   ),
                      // ],
                      // color: context.resources.color.colorWhite,
                      color: const Color(0xffEAEAFF).withOpacity(0.4),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(
                                      context.appValues.appPadding.p0),
                                  child: Align(
                                    alignment: Alignment.topCenter,
                                    child: InkWell(
                                      child: Container(
                                        width:
                                            context.appValues.appSizePercent.w18,
                                        height:
                                            context.appValues.appSizePercent.h9,
                                        decoration:  BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                              data[index].service['image']!=null?
                                              '${context.resources.image.networkImagePath2}/${data[index].service['image']}.svg':
                                              'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                            ),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // Image.network(
                                      //   'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                                      //   width:
                                      //       context.appValues.appSizePercent.w18,
                                      //   //width: 71,
                                      //   height:
                                      //       context.appValues.appSizePercent.h9,
                                      //   // height: 71,
                                      //   fit: BoxFit.cover,
                                      // ),
                                      onTap: () {
                                        // Navigator.of(context)
                                        //     .push(_createRoute(ViewProfilePage()));
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.appValues.appSizePercent.w2,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: context.appValues.appSizePercent.w63,
                                      child: Text(
                                        services!=null? widget.userRole ==
                                                Constants.supplierRoleId
                                            ? '${services?['title']}'
                                            :'${services!["title"]}':'',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: getPrimaryMediumStyle(
                                          fontSize: 14,
                                          color: const Color(0xff180B3C),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: context.appValues.appSizePercent.w63,
                                      child: Text(
                                        widget.active == 'requestedJobs'?
                                            'CIRCULATING':
                                        widget.userRole ==
                                                Constants.supplierRoleId
                                            ? data[index].customer != null
                                                ? '${data[index].customer["first_name"]} ${data[index].customer["last_name"]}'.toUpperCase()
                                                : ''
                                            : data[index].supplier != null
                                                ? '${data[index].supplier["first_name"]} ${data[index].supplier["last_name"]}'.toUpperCase()
                                                : '',
                                        // : data[index].supplier != null
                                        //     ? '${data[index].customer["first_name"]} ${data[index].customer["last_name"]}'
                                        //     : '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: getPrimarySemiBoldStyle(
                                          fontSize: 10,
                                          color: const Color(0xff6E6BE8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: context.appValues.appSizePercent.h2,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: context.appValues.appPadding.p8),
                              child: widget.userRole ==
                                          Constants.supplierRoleId ||
                                      widget.active == 'requestedJobs' ||
                                      widget.active == 'completedJobs'
                                  || widget.active == 'bookedJobs'
                                  ? widget.active == 'activeJobs'

                                      ?
                              Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/img/calendarjobs.svg',
                                                ),
                                                const Gap(5),
                                                Text(
                                                  data[index].actual_start_date !=
                                                          null
                                                      ? DateFormat('d MMMM yyyy')
                                                          .format(DateTime.parse(
                                                                  data[index]
                                                                          .actual_start_date +
                                                                      'Z')
                                                              .toUtc()
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                    fontSize: 14,
                                                    color:
                                                        const Color(0xff78789D),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/img/timejobs.svg',
                                                ),
                                                const Gap(5),
                                                Text(
                                                  data[index].actual_start_date !=
                                                          null
                                                      ? DateFormat('HH:mm').format(
                                                          DateTime.parse(data[
                                                                          index]
                                                                      .actual_start_date +
                                                                  'Z')
                                                              .toUtc()
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                    fontSize: 12,
                                                    color: context.resources.color
                                                        .btnColorBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/img/calendarjobs.svg',
                                                ),
                                                const Gap(5),
                                                Text(
                                                  data[index].start_date != null
                                                      ? DateFormat('d MMMM yyyy')
                                                          .format(DateTime.parse(
                                                                  data[index]
                                                                      .start_date)
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                    fontSize: 12,
                                                    color: context.resources.color
                                                        .btnColorBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/img/timejobs.svg',
                                                ),
                                                const Gap(5),
                                                Text(
                                                  data[index].start_date != null
                                                      ? DateFormat('HH:mm')
                                                          .format(DateTime.parse(
                                                                  data[index]
                                                                      .start_date)
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                    fontSize: 12,
                                                    color: context.resources.color
                                                        .btnColorBlue,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                  : widget.active == 'activeJobs'
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/img/calendarjobs.svg'),
                                                const Gap(5),
                                                Text(
                                                  data[index].actual_start_date !=
                                                          null
                                                      ? DateFormat('d MMMM yyyy')
                                                          .format(DateTime.parse(
                                                                  data[index]
                                                                          .actual_start_date +
                                                                      'Z')
                                                              .toUtc()
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                      fontSize: 12,
                                                      color: context.resources
                                                          .color.btnColorBlue),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/img/timejobs.svg',
                                                ),
                                                const Gap(5),
                                                Text(
                                                  data[index].actual_start_date !=
                                                          null
                                                      ? DateFormat('HH:mm').format(
                                                          DateTime.parse(data[
                                                                          index]
                                                                      .actual_start_date +
                                                                  'Z')
                                                              .toUtc()
                                                              .toLocal())
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                      fontSize: 14,
                                                      color: context.resources
                                                          .color.btnColorBlue),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )
                                      : Container(),
                            ),
                            widget.active == 'completedJobs' &&
                                widget.userRole ==
                                    Constants.customerRoleId?
                            Gap(7):Container(),
                            Padding(
                              padding: EdgeInsets.only(
                                  right: context.appValues.appPadding.p8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // widget.active == 'completedJobs' &&
                                  //         widget.userRole ==
                                  //             Constants.customerRoleId
                                  //     ? Text(
                                  //         translate('jobs.dateTime'),
                                  //         style: getPrimaryRegularStyle(
                                  //             fontSize: 18,
                                  //             color: context.resources.color
                                  //                 .secondColorBlue),
                                  //       )
                                  //     : Container(),

                                  widget.active == 'completedJobs' &&
                                          widget.userRole ==
                                              Constants.customerRoleId
                                      ? Padding(
                                        padding: const EdgeInsets.only(left: 0.0),
                                        child: Text(
                                            data[index].actual_start_date != null
                                                ? DateFormat('d MMMM yyyy, HH:mm')
                                                    .format(DateTime.parse(data[
                                                                    index]
                                                                .actual_start_date +
                                                            'Z')
                                                        .toUtc()
                                                        .toLocal())
                                                : '',
                                            style: getPrimaryRegularStyle(
                                              fontSize: 12,
                                              color: context
                                                  .resources.color.btnColorBlue,
                                            ),
                                          ),
                                      )
                                      : Container(),
                                ],
                              ),
                            ),
                            const Gap(7),
                            // widget.active == 'bookedJobs' ||
                            //         widget.active == 'requestedJobs'
                            //     ?
                            Padding(
                                    padding: EdgeInsets.only(
                                        right: context.appValues.appPadding.p8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text(
                                        //   translate('updateJob.address'),
                                        //   style: getPrimaryRegularStyle(
                                        //       fontSize: 18,
                                        //       color: context.resources.color
                                        //           .secondColorBlue),
                                        // ),
                                        // const Gap(30),
                                        Expanded(
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/img/locationjobs.svg'),
                                                Text(
                                                  data[index].job_address !=
                                                              null &&
                                                          data[index]
                                                                  .job_address
                                                                  .toString() !=
                                                              ''
                                                      ? '${data[index].job_address['city'] ?? ''}, ${data[index].job_address['state'] ?? ''}, ${data[index].job_address['street_number'] ?? ''}'
                                                      : '',
                                                  style: getPrimaryRegularStyle(
                                                    fontSize: 12,
                                                    color: context.resources.color
                                                        .btnColorBlue,
                                                  ),
                                                  overflow: TextOverflow
                                                      .visible, // Ensure the text wraps to the next line
                                                  softWrap:
                                                      true, // Enable soft wrapping
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                // : Container(),
                            const Gap(15),
                            widget.userRole == Constants.supplierRoleId
                                ? widget.active == 'bookedJobs'
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                context.appValues.appPadding.p8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${(data[index].supplier_to_job_distance != null ? (data[index].supplier_to_job_distance / 1000).toStringAsFixed(3) : "0")} km',
                                                style: getPrimaryBoldStyle(
                                                  fontSize: 14,
                                                  color: const Color(0xff78789D),
                                                ),
                                              ),
                                            ]),
                                      )
                                    : Container()
                                : Container(),
                            // const Gap(5),
                            widget.userRole == Constants.supplierRoleId
                                ? widget.active == 'bookedJobs'
                                    ? Padding(
                                        padding: EdgeInsets.only(
                                            right:
                                                context.appValues.appPadding.p8),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${data[index].supplier_to_job_time ?? 0} ${translate('jobs.minutes')}',
                                                style: getPrimaryBoldStyle(
                                                  fontSize: 14,
                                                  color: const Color(0xff78789D),
                                                ),
                                              ),
                                            ]),
                                      )
                                    : Container()
                                : Container(),

                            Padding(
                              padding: EdgeInsets.only(
                                  right: context.appValues.appPadding.p8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    // '',
                                    // data[index].supplier_total != null &&
                                    //         data[index]
                                    //                 .supplier_total
                                    //                 .toString() !=
                                    //             ''
                                    //     ? '${data[index].supplier_total} ${data[index].service["country_rates"] != null && data[index].service["country_rates"].isNotEmpty ? data[index].service["country_rates"][0]["country"]["currency"] : ''}'
                                    //     :
                              data[index].service!=null?'${data[index].service["country_rates"] != null ? data[index].number_of_units != null ? (data[index].service["country_rates"][0]["unit_rate"] * data[index].number_of_units) : (data[index].service["country_rates"][0]["unit_rate"] * data[index].service["country_rates"][0]["minimum_order"]) : ''} ${data[index].service["country_rates"] != null ? data[index].service["country_rates"][0]["country"]["currency"] : ''}':'',
                                    style: getPrimarySemiBoldStyle(
                                      fontSize: 14,
                                      color: const Color(0xff180B3C),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(5),
                            widget.active == 'requestedJobs'
                                ? Padding(
                                    padding: EdgeInsets.only(
                                        right: context.appValues.appPadding.p8),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            data[index].severity_level != null
                                                ? data[index]
                                                            .severity_level
                                                            .toString()
                                                            .toLowerCase() ==
                                                        'major'
                                                    ? 'URGENT'
                                                    : 'SCHEDULED'
                                                : '',
                                            style: getPrimarySemiBoldStyle(
                                                fontSize: 10,
                                                color: data[index]
                                                            .severity_level !=
                                                        null
                                                    ? data[index]
                                                                .severity_level
                                                                .toString()
                                                                .toLowerCase() ==
                                                            'major'
                                                        ? Colors.red
                                                        : Colors.green
                                                    : Colors.white),
                                          ),
                                        ]),
                                  )
                                : Container(),

                            const Gap(15),
                            widget.active == 'bookedJobs'
                                ? Padding(
                                    padding: EdgeInsets.only(
                                      top: context.appValues.appPadding.p10,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  _buildPopupDialog(
                                                      context,
                                                      jobsViewModel,
                                                      data[index].id,
                                                      widget.active),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0,
                                            // shadowColor: Colors.black,
                                            backgroundColor:
                                                const Color(0xffF4F3FD),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            fixedSize: Size(
                                              context
                                                  .appValues.appSizePercent.w40,
                                              context.appValues.appSizePercent.h6,
                                            ),
                                          ),
                                          child: Text(
                                            translate('button.cancel'),
                                            style: getPrimaryBoldStyle(
                                              fontSize: 14,
                                              color: const Color(0xff6F6BE8),
                                            ),
                                          ),
                                        ),
                                        widget.active != 'activeJobs' &&
                                                widget.userRole ==
                                                    Constants.supplierRoleId
                                            ? ElevatedButton(
                                                onPressed: () {
                                                  debugPrint(
                                                      'data ${data[index]}');
                                                  widget.active == 'activeJobs'
                                                      ? jobsViewModel
                                                          .finishJobAndCollectPayment(
                                                              data[index].id)
                                                      : jobsViewModel.startJob(
                                                          data[index].id);
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  // shadowColor: Colors.black,
                                                  backgroundColor:
                                                      const Color(0xff6F6BE8),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                  ),
                                                  fixedSize: Size(
                                                    context.appValues
                                                        .appSizePercent.w40,
                                                    context.appValues
                                                        .appSizePercent.h6,
                                                  ),
                                                ),
                                                child: Text(
                                                  widget.active == 'activeJobs'
                                                      ? translate(
                                                          'button.complete')
                                                      : translate(
                                                          'button.startJob'),
                                                  style: getPrimaryBoldStyle(
                                                    fontSize: 14,
                                                    color: context.resources.color
                                                        .colorWhite,
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    ]),
                  ),
                ),
              );
            }),
      );
    });
  }

  Widget _buildPopupDialog(BuildContext context, JobsViewModel jobsViewModel,
      int job_id, String tab) {
    String message = '';
    if (tab == 'bookedJobs') {
      message = translate('jobs.provideReasonToCancelBooking');
    } else if (tab == 'activeJobs') {
      message = translate('jobs.provideReasonToCancelJob');
    }
    List<String> reasons = [
      translate('jobs.changeOfPlans'),
      translate('jobs.unexpectedEmergency'),
      translate('jobs.illnessOrHealthIssues'),
      translate('jobs.other')
    ];

    return SingleChildScrollView(
      child: AlertDialog(
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
              child: Consumer<JobsViewModel>(
                  builder: (context, jobsViewModel1, _) {
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
                  if (widget.userRole == Constants.supplierRoleId) {
                    if (await jobsViewModel.cancelBooking(job_id) == true) {
                      Navigator.pop(context);

                      Future.delayed(const Duration(seconds: 0));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => _buildPopupDialogSuccess(
                              context,''));
                    } else {
                      Navigator.pop(context);

                      Future.delayed(const Duration(seconds: 0));
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialogFailure(
                                  context,

                                  translate('button.somethingWentWrong')));
                    }
                  } else {
                    debugPrint('active    qwd ${widget.active}');
                    // if (tab == 'bookedJobs') {
                    //   if (await jobsViewModel.cancelJobNoPenalty(job_id) ==
                    //       true) {
                    //     Navigator.pop(context);
                    //
                    //     Future.delayed(const Duration(seconds: 0));
                    //     showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) => simpleAlert(
                    //             context, translate('button.success')));
                    //   } else {
                    //     Navigator.pop(context);
                    //
                    //     Future.delayed(const Duration(seconds: 0));
                    //     showDialog(
                    //         context: context,
                    //         builder: (BuildContext context) =>
                    //             simpleAlertWithMessage2(
                    //                 context,
                    //                 translate('button.failure'),
                    //                 translate('button.somethingWentWrong')));
                    //   }
                    // } else {
                    if (widget.active == 'requestedJobs') {
                      if (await jobsViewModel.cancelJobNoPenalty(job_id) ==
                          true) {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogSuccess(
                                    context,

                                    translate('button.jobCanceledMsg')));
                      } else {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogFailure(
                                    context,

                                    translate('button.somethingWentWrong')));
                      }
                    } else {
                      if (await jobsViewModel.cancelJobWithPenalty(job_id) ==
                          true) {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogSuccess(
                                    context,
                                    // translate('button.success'),
                                    translate('button.jobCanceledMsg')));
                      } else {
                        Navigator.pop(context);

                        Future.delayed(const Duration(seconds: 0));
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                _buildPopupDialogFailure(
                                    context,

                                    translate('button.somethingWentWrong')));
                      }
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  elevation: 1.0,
                  shadowColor: Colors.black,
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
                  translate('button.proceed'),
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
    );
  }
}

// Widget simpleAlertWithMessage2(
//     BuildContext context, String message, String message2) {
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
                onTap: () {
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
            translate('button.failure'),
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
            translate('button.somethingWentWrong'),
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
                onTap: () {
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
            translate('button.success'),
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
