import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:flutter/material.dart';

class JobTypeWidget extends StatefulWidget {
  const JobTypeWidget({super.key});

  @override
  State<JobTypeWidget> createState() => _JobTypeWidgetState();
}

class _JobTypeWidgetState extends State<JobTypeWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        width: context.appValues.appSizePercent.w90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p10,
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: context.appValues.appPadding.p10,
                ),
                child: Text(
                  'Job Type',
                  style: getPrimaryRegularStyle(
                    fontSize: 15,
                    color: context.resources.color.secondColorBlue,
                  ),
                ),
              ),
              CustomTextField(
                index: '',
                // hintText: 'Job Type',
                viewModel: '',
              ),
              // Text(
              //   'Handiman',
              //   style: getPrimaryRegularStyle(
              //     fontSize: 13,
              //     color: context.resources.color.colorBlack[50],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
