import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class DateAndTimeButtons extends StatefulWidget {
  DateAndTimeButtons({
    super.key,
  });

  @override
  State<DateAndTimeButtons> createState() => _DateAndTimeButtonsState();
}

class _DateAndTimeButtonsState extends State<DateAndTimeButtons> {
  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('bookService.Now'),
                  style: getPrimaryRegularStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            leading: Radio(
              activeColor: context.resources.color.btnColorBlue,
              value: 'now',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
                jobsViewModel.setInputValues(
                    index: 'start_date', value: DateTime.now().toString());
              },
            ),
          ),
          ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('bookService.scheduleForLater'),
                  style: getPrimaryRegularStyle(
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            leading: Radio(
              activeColor: context.resources.color.btnColorBlue,
              value: 'schedule',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
          ),
        ],
      );
    });
  }
}
