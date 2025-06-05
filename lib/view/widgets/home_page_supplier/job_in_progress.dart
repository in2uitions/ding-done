import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../res/app_prefs.dart';

class JobInProgress extends StatefulWidget {
  const JobInProgress({super.key});

  @override
  State<JobInProgress> createState() => _JobInProgressState();
}

String? lang;

class _JobInProgressState extends State<JobInProgress> {
  @override
  void initState() {
    super.initState();
    getLanguage();
  }

  getLanguage() async {
    lang = await AppPreferences().get(key: dblang, isModel: false);
    debugPrint('language in service $lang');
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: jobsViewModel.supplierInProgressJobs.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            Map<String, dynamic>? services;
            Map<String, dynamic>? categories;

            for (Map<String, dynamic> translation in jobsViewModel
                .supplierInProgressJobs[index].service["translations"]) {
              if (translation["languages_code"] == lang) {
                services = translation;
                break; // Break the loop once the translation is found
              }
            }
            for (Map<String, dynamic> translation in jobsViewModel
                .supplierInProgressJobs[index]
                .service["category"]["translations"]) {
              if (translation["languages_code"] == lang) {
                categories = translation;
                break; // Break the loop once the translation is found
              }
            }
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p20,
                vertical: context.appValues.appPadding.p10,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.resources.color.colorWhite,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(24),
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(context.appValues.appPadding.p20),
                        child: Row(
                          children: [
                            // SvgPicture.network(
                            //   '${context.resources.image.networkImagePath}/${jobsViewModel.supplierInProgressJobs[index].service["category"]["image"]}.svg',
                            //   // 'assets/img/plumbing-blue.svg',
                            //   width: 32,
                            //   height: 31,
                            // ),

                            Container(
                              width: 76,
                              height: 76,
                              decoration: BoxDecoration(
                                color: const Color(0xffEAEAFF),
                                borderRadius: BorderRadius.circular(16),

                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${context.resources.image.networkImagePath2}/${jobsViewModel.supplierInProgressJobs[index].service['image']}.svg',
                                    ),
                                    fit: BoxFit.cover,
                                  ),

                              ),
                              // child: SvgPicture.network(
                              //   '${context.resources.image.networkImagePath2}/${jobsViewModel.supplierInProgressJobs[index].service['image']}.svg',
                              //   fit: BoxFit.cover,
                              // ),
                            ),
                            // SvgPicture.asset('assets/img/plumbing-blue.svg'),
                            SizedBox(
                              width: context.appValues.appSize.s10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: context.appValues.appSizePercent.w55,
                                  child: Text(
                                    categories != null
                                        ? '${categories["title"]}'
                                        : '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: getPrimaryMediumStyle(
                                      fontSize: 14,
                                      color: const Color(0xff180B3C),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: context.appValues.appSizePercent.w55,
                                  child: Text(
                                    '${services != null ? services["title"] : ''}',
                                    maxLines: 2,
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
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p15,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Working day',
                                  style: getPrimaryBoldStyle(
                                    fontSize: 12,
                                    color: const Color(0xff180B3C),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/img/calendarhpsupp.svg'),
                                    const Gap(7),
                                    Text(
                                      DateFormat('d MMMM yyyy').format(
                                          DateTime.parse(jobsViewModel
                                              .supplierInProgressJobs[index]
                                              .start_date
                                              .toString())),

                                      // '${jobsViewModel.supplierInProgressJobs[index].start_date}',
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Start time',
                                  style: getPrimaryBoldStyle(
                                    fontSize: 12,
                                    color: const Color(0xff180B3C),
                                  ),
                                ),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/img/clockhpsupp.svg'),
                                    const Gap(7),
                                    Text(
                                      DateFormat('HH:mm').format(DateTime.parse(
                                          jobsViewModel
                                              .supplierInProgressJobs[index]
                                              .start_date
                                              .toString())),

                                      // '${jobsViewModel.supplierInProgressJobs[index].start_date}',
                                      style: getPrimaryRegularStyle(
                                        fontSize: 14,
                                        color: const Color(0xff180B3C),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                context.appValues.appPadding.p0,
                                context.appValues.appPadding.p0,
                                context.appValues.appPadding.p0,
                                context.appValues.appPadding.p0,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    translate('home_screen.totalPrice'),
                                    style: getPrimarySemiBoldStyle(
                                      fontSize: 12,
                                      color: const Color(0xff180B3C),
                                    ),
                                  ),
                                  Text(
                                    '${jobsViewModel.supplierInProgressJobs[index].service["country_rates"] != null ? jobsViewModel.supplierInProgressJobs[index].service["country_rates"][0]["unit_rate"] : ''}'
                                    ' ${jobsViewModel.supplierInProgressJobs[index].service["country_rates"] != null ? jobsViewModel.supplierInProgressJobs[index].service["country_rates"][0]["country"]["currency"] : ''}'
                                    ' ${jobsViewModel.supplierInProgressJobs[index].service["country_rates"] != null ? jobsViewModel.supplierInProgressJobs[index].service["country_rates"][0]["unit_type"] : ''}',
                                    style: getPrimarySemiBoldStyle(
                                      fontSize: 12,
                                      color: const Color(0xff4100E3),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: context.appValues.appSizePercent.w38,
                              // width: 155,
                              height: context.appValues.appSizePercent.h6,
                              // height: 51,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          showFinalData(
                                              context,
                                              jobsViewModel,jobsViewModel.supplierInProgressJobs[index]));
                                  // debugPrint(
                                  //     '${jobsViewModel.supplierInProgressJobs[index].id}');
                                  // jobsViewModel.finishJobAndCollectPayment(
                                  //     jobsViewModel
                                  //         .supplierInProgressJobs[index].id);
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  backgroundColor: const Color(0xff4100E3),
                                ),
                                child: Text(
                                  translate('button.complete'),
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
                    ]),
              ),
            );
          });
    });
  }
  Widget showFinalData(BuildContext context, JobsViewModel jobsViewModel,var data ) {
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
              'Completed Units: ${jobsViewModel.updatedBody["completed_units"] ?? data.completed_units}',
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
              'Current number of units: ${jobsViewModel.updatedBody["number_of_units"] ?? data.number_of_units}',
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
              'Extra Fees: ${jobsViewModel.updatedBody["extra_fees"] ?? data.extra_fees}',
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
              'Extra Fees Reason: ${jobsViewModel.updatedBody["extra_fees_reason"] ?? data.extra_fees_reason}',
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
              debugPrint('data in finish ${data.customer['id']}');
              if (await jobsViewModel.finishJobAndCollectPayment(data.id) == true) {
                Navigator.pop(context); // ❗Close showFinalData dialog first
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialogSuccess(context),
                );
              } else {
                Navigator.pop(context); // ❗Close showFinalData dialog first
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialogFailure(context),
                );
              }
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
              'Completed Units: $data.completed_units ?? ''}',
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
              'Current number of units: ${data.number_of_units ?? ''}',
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
              'Extra Fees: ${data.extra_fees ?? ''}',
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
              'Extra Fees Reason: ${data.extra_fees_reason ?? ''}',
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
              if (await jobsViewModel.finishJobAndCollectPayment(data.id) == true) {
                Navigator.pop(context); // ❗Close showFinalData dialog first
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialogSuccess(context),
                );
              } else {
                Navigator.pop(context); // ❗Close showFinalData dialog first
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialogFailure(context),
                );
              }
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
  Widget _buildPopupDialogSuccess(BuildContext context) {
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
              translate('jobDetails.jobAccepted'),
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
  Widget _buildPopupDialogFailure(BuildContext context) {
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
  //                           () => Navigator.of(context).pop());
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

}
