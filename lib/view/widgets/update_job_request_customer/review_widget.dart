import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class ReviewWidget extends StatefulWidget {
  var review;

  ReviewWidget({super.key, required this.review});

  @override
  State<ReviewWidget> createState() => _ReviewWidgetState();
}

class _ReviewWidgetState extends State<ReviewWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
      child: Container(
        width: context.appValues.appSizePercent.w100,
        // height: context.appValues.appSizePercent.h22,
        // height: context.appValues.appSizePercent.h30,
        // decoration: BoxDecoration(
        //   color: context.resources.color.colorWhite,
        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
        // ),
        child: Padding(
          padding: EdgeInsets.only(
            bottom: context.appValues.appPadding.p15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p10,
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Text(
                  translate('jobDetails.review'),
                  style: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: const Color(0xff38385E),
                  ),
                ),
              ),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     horizontal: context.appValues.appPadding.p20,
              //   ),
              //   child: Text(
              //     '${widget.review}',
              //     style: getPrimaryRegularStyle(
              //       fontSize: 13,
              //       color: context.resources.color.colorBlack[50],
              //     ),
              //   ),
              // ),
              Consumer2<JobsViewModel, LoginViewModel>(
                  builder: (context, jobsViewModel, loginViewModel, _) {
                return loginViewModel.userRole == Constants.supplierRoleId
                    ? Container(
                        width: context.appValues.appSizePercent.w90,
                        height: context.appValues.appSizePercent.h7,
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
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p10,
                            ),
                            child: Text(
                              '${widget.review}',
                              style: getPrimaryBoldStyle(
                                fontSize: 18,
                                color: const Color(0xff38385E),
                              ),
                            ),
                          ),
                        ),
                      )
                    : CustomTextArea(
                        index: 'rating_comment',
                        value: widget.review,
                        // hintText: 'Job Type',
                        viewModel: jobsViewModel.setUpdatedJob,
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
