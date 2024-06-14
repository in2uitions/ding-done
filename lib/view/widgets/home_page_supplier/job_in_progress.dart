import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
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
    // TODO: implement initState
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
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Column(children: [
                  Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p20),
                    child: Row(
                      children: [
                        SvgPicture.network(
                          '${context.resources.image.networkImagePath}/${jobsViewModel.supplierInProgressJobs[index].service["category"]["image"]}.svg',
                          // 'assets/img/plumbing-blue.svg',
                          width: 32, // Set the desired width of the SVG image
                          height: 31,
                        ),
                        // SvgPicture.asset('assets/img/plumbing-blue.svg'),
                        SizedBox(
                          width: context.appValues.appSize.s10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categories!=null?'${categories!["title"]}':'',
                              // 'Plumbing',
                              style: getPrimaryBoldStyle(
                                fontSize: 15,
                                color: const Color(0xff9E9AB7),
                              ),
                            ),
                            Text(
                              '${services!["title"]}',
                              style: getPrimaryBoldStyle(
                                fontSize: 22,
                                color: const Color(0xff190C39),
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
                      context.appValues.appPadding.p10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          translate('home_screen.totalPrice'),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xff9E9AB7),
                          ),
                        ),
                        // Text(
                        //   '\$${jobsViewModel.supplierInProgressJobs[index].service["country_rates"] != null ? jobsViewModel.supplierInProgressJobs[index].service["country_rates"][0]["unit_rate"] : ''} ${jobsViewModel.supplierInProgressJobs[index].service["country_rates"] != null ? jobsViewModel.supplierInProgressJobs[index].service["country_rates"][0]["unit_type"] : ''}',
                        //   style: getPrimaryRegularStyle(
                        //     fontSize: 18,
                        //     color: const Color(0xff180C39),
                        //   ),
                        // ),
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
                        Text(
                          translate('jobs.dateTime'),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xff9E9AB7),
                          ),
                        ),
                        Text(
                          '${jobsViewModel.supplierInProgressJobs[index].start_date}',
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xff180C39),
                          ),
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
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Container(
                        //   width: context.appValues.appSizePercent.w38,
                        //   // width: 155,
                        //   height: context.appValues.appSizePercent.h065,
                        //   // height: 51,
                        //   decoration: BoxDecoration(
                        //     border: Border.all(
                        //       color: const Color(0xff58537A),
                        //       width: 2,
                        //     ),
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       // jobsViewModel.cancelJob(jobsViewModel.supplierInProgressJobs[index].id);
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       elevation: 0,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12.0),
                        //         side: const BorderSide(
                        //           color: Colors.transparent,
                        //         ),
                        //       ),
                        //       backgroundColor:
                        //           context.resources.color.colorWhite,
                        //     ),
                        //     child: Text(
                        //       translate('button.stopCancel'),
                        //       style: getPrimaryRegularStyle(
                        //         fontSize: 16,
                        //         color: const Color(0xff9E9AB7),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Container(
                          width: context.appValues.appSizePercent.w38,
                          // width: 155,
                          height: context.appValues.appSizePercent.h065,
                          // height: 51,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              debugPrint(
                                  '${jobsViewModel.supplierInProgressJobs[index].id}');
                              jobsViewModel.finishJob(jobsViewModel
                                  .supplierInProgressJobs[index].id);
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                side: BorderSide(
                                  color: context.resources.color.colorYellow,
                                ),
                              ),
                              backgroundColor: const Color(0xffF3D347),
                            ),
                            child: Text(
                              translate('button.complete'),
                              style: getPrimaryBoldStyle(
                                fontSize: 15,
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
