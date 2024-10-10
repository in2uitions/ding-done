import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

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
      child: SizedBox(
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
                  horizontal: context.appValues.appPadding.p0,
                  vertical: context.appValues.appPadding.p10),
              child: Text(
                translate('bookService.dateAndTime'),
                style: getPrimaryBoldStyle(
                  fontSize: 18,
                  color: const Color(0xff38385E),
                ),
              ),
            ),
            // const DatePickerWidget(),
            Text(
              DateFormat('d MMMM yyyy, HH:mm')
                  .format(DateTime.parse(widget.dateTime.toString())),
              // '${widget.dateTime}',
              style: getPrimaryRegularStyle(
                fontSize: 18,
                color: const Color(0xff78789D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
