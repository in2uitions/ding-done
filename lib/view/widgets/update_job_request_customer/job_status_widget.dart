import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class JobStatusWidget extends StatefulWidget {
  var status;

  JobStatusWidget({super.key, required this.status});

  @override
  State<JobStatusWidget> createState() => _JobStatusWidgetState();
}

class _JobStatusWidgetState extends State<JobStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: SizedBox(
        width: context.appValues.appSizePercent.w90,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                  horizontal: context.appValues.appPadding.p10,
                ),
                child: Text(
                  'updateJob.jobStatus'.tr(),
                  style: getPrimaryRegularStyle(
                    fontSize: 14,
                    color: const Color(0xff180B3C),
                  ),
                ),
              ),
              Text(
                '${widget.status}',
                style: getPrimaryRegularStyle(
                  fontSize: 14,
                  color: const Color(0xff71727A),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
