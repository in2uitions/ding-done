import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CurrentSupplierWidget extends StatefulWidget {
  var user;

  CurrentSupplierWidget({super.key, required this.user});

  @override
  State<CurrentSupplierWidget> createState() => _CurrentSupplierWidgetState();
}

class _CurrentSupplierWidgetState extends State<CurrentSupplierWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p0,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        width: context.appValues.appSizePercent.w90,
        // // height: context.appValues.appSizePercent.h10,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: Colors.white,
        // ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                  horizontal: context.appValues.appPadding.p0,
                ),
                child: Text(
                  'updateJob.currentSupplier'.tr(),
                  style: getPrimaryRegularStyle(
                    fontSize: 14,
                    color: const Color(0xff180B3C),
                  ),
                ),
              ),
              Text(
                '${widget.user}',
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
