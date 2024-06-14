import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:provider/provider.dart';

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  State<DatePickerWidget> createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return Padding(
        padding:
            EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p10),
        child: CustomDatePicker(
          index: 'date',
          viewModel: jobsViewModel.setInputValues,
        ),
        // DatePicker(
        //   DateTime.now(),
        //   initialSelectedDate: DateTime.now(),
        //   selectionColor: context.resources.color.btnColorBlue,
        //   selectedTextColor: context.resources.color.colorWhite,
        //   dateTextStyle: TextStyle(
        //       color: context.resources.color.btnColorBlue, fontSize: 17),
        //   width: context.appValues.appSizePercent.w14,
        //   height: context.appValues.appSizePercent.h10,
        //   onDateChange: (DateTime date) {
        //     // New date selected
        //     String formattedDateTime = date.toIso8601String();
        //     jobsViewModel.setInputValues(
        //         index: 'date', value: formattedDateTime);
        //     setState(() {
        //       // _selectedValue = date;
        //     });
        //   },
        // ),
      );
    });
  }
}
