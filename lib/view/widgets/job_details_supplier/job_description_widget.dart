import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area.dart';
import 'package:flutter/material.dart';

class JobDescriptionWidget extends StatefulWidget {
  const JobDescriptionWidget({super.key});

  @override
  State<JobDescriptionWidget> createState() => _JobDescriptionWidgetState();
}

class _JobDescriptionWidgetState extends State<JobDescriptionWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
      child: Container(
        width: context.appValues.appSizePercent.w100,
        height: context.appValues.appSizePercent.h22,
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
                'Job Description',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p20,
              ),
              child: const CustomTextArea(
                index: 'job_description',
                // viewModel: jobsViewModel.setInputValues,
                viewModel: '',
                keyboardType: TextInputType.visiblePassword,
                maxlines: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
