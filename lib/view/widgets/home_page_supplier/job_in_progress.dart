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
                              ),
                              child: SvgPicture.network(
                                '${context.resources.image.networkImagePath}/${jobsViewModel.supplierInProgressJobs[index].service["category"]["image"]}.svg',
                                fit: BoxFit.cover,
                              ),
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
                                  debugPrint(
                                      '${jobsViewModel.supplierInProgressJobs[index].id}');
                                  jobsViewModel.finishJobAndCollectPayment(
                                      jobsViewModel
                                          .supplierInProgressJobs[index].id);
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
}
