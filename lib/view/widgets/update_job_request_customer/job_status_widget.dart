import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
                  translate('updateJob.jobStatus'),
                  style: getPrimaryBoldStyle(
                    fontSize: 20,
                    color: const Color(0xff180C38),
                  ),
                ),
              ),
              Container(
                width: context.appValues.appSizePercent.w100,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xff000000).withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.appValues.appPadding.p15,
                    horizontal: context.appValues.appPadding.p20,
                  ),
                  child: Text(
                    '${widget.status}',
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff190C39),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}