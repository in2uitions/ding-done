import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DateAndTimeWidget extends StatefulWidget {
  var dateTime;

  DateAndTimeWidget({super.key, required this.dateTime});

  @override
  State<DateAndTimeWidget> createState() => _DateAndTimeWidgetState();
}

class _DateAndTimeWidgetState extends State<DateAndTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p10,
      ),
      child: Container(
        width: context.appValues.appSizePercent.w100,
        // height: context.appValues.appSizePercent.h20,
        // height: context.appValues.appSizePercent.h30,
        // decoration: BoxDecoration(
        //   color: context.resources.color.colorWhite,
        //   borderRadius: const BorderRadius.all(Radius.circular(20)),
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p10,
                  vertical: context.appValues.appPadding.p10),
              child: Text(
                translate('bookService.dateAndTime'),
                style: getPrimaryBoldStyle(
                  fontSize: 20,
                  color: const Color(0xff180C38),
                ),
              ),
            ),
            // const DatePickerWidget(),
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
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p15,
                  horizontal: context.appValues.appPadding.p20,
                ),
                child: Text(
                  '${widget.dateTime}',
                  style: getPrimaryRegularStyle(
                    fontSize: 18,
                    color: const Color(0xff180C38),
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