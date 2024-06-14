import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/book_a_service/date_picker.dart';
import 'package:flutter/material.dart';

class DateAndTimeWidget extends StatefulWidget {
  const DateAndTimeWidget({super.key});

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
        height: context.appValues.appSizePercent.h20,
        // height: context.appValues.appSizePercent.h30,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                  vertical: context.appValues.appPadding.p10),
              child: Text(
                'Date and Time',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ),
            const DatePickerWidget(),
          ],
        ),
      ),
    );
  }
}
