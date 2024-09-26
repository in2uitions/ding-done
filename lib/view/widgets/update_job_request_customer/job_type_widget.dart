import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/book_a_service/job_type/job_type_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class JobTypeWidget extends StatefulWidget {
  var job_type;
  var tab;
  var service;

  JobTypeWidget(
      {super.key,
      required this.job_type,
      required this.tab,
      required this.service});

  @override
  State<JobTypeWidget> createState() => _JobTypeWidgetState();
}

class _JobTypeWidgetState extends State<JobTypeWidget> {
  @override
  Widget build(BuildContext context) {
    debugPrint('job type ${widget.job_type}');
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: SizedBox(
        width: context.appValues.appSizePercent.w90,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p10,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: context.appValues.appPadding.p10,
                  bottom: context.appValues.appPadding.p10,
                  left: context.appValues.appPadding.p0,
                  right: context.appValues.appPadding.p10,
                ),
                child: Text(
                  translate('bookService.jobType'),
                  style: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: const Color(0xff38385E),
                  ),
                ),
              ),
              widget.tab == 'completed' || widget.tab == 'booked'
                  ? Text(
                      '${widget.job_type}',
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff78789D),
                      ),
                    )
                  :
                  // Consumer<JobsViewModel>(
                  //      builder: (context,jobsViewModel, _) {
                  //      return CustomTextField(
                  //        index: 'job_type',
                  //        value: widget.job_type,
                  //        // hintText: 'Job Type',
                  //        viewModel: jobsViewModel.setUpdatedJob,
                  //      );
                  //    }
                  //  ),

                  Consumer3<ProfileViewModel, JobsViewModel, ServicesViewModel>(
                      builder: (context, profileViewModel, jobsViewModel,
                          servicesViewModel, _) {
                      return widget.job_type != null
                          ? JobTypeButtons(
                              service: widget.service,
                              country_code: profileViewModel
                                  .profileBody["address"][0]["country"],
                              job_type: widget.job_type,
                              servicesViewModel: servicesViewModel)
                          : Container();
                    }),
            ],
          ),
        ),
      ),
    );
  }
}
