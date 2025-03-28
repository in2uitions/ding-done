import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:flutter/material.dart';

class JobCategorieAndServiceWidget extends StatefulWidget {
  const JobCategorieAndServiceWidget({super.key});

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
                      'Job Categories',
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
                      'Services',
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
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
