import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class JobCategorieAndServiceWidget extends StatefulWidget {
  var category;

  var service;

  JobCategorieAndServiceWidget(
      {super.key, required this.category, required this.service});

  @override
  State<JobCategorieAndServiceWidget> createState() =>
      _JobCategorieAndServiceWidgetState();
}

class _JobCategorieAndServiceWidgetState
    extends State<JobCategorieAndServiceWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: Container(
            // width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.appValues.appPadding.p10,
                      horizontal: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.jobCategories'),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
                        '${widget.category}',
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
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: Container(
            // width: context.appValues.appSizePercent.w90,
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(15),
            //   color: Colors.white,
            // ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: context.appValues.appPadding.p10,
                      horizontal: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      translate('updateJob.services'),
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: const Color(0xff180B3C),
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
                          offset:
                              const Offset(0, 3), // changes position of shadow
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
                        '${widget.service}',
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
          ),
        )
      ],
    );
  }
}
