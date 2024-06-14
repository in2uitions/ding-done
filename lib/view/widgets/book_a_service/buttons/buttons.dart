import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';

class ThreeButtons extends StatefulWidget {
  final ValueChanged<String> action; //callback value change
  final String tag; //tag of button
  final String text;
  final bool active; // state of button
  final JobsViewModel jobsViewModel;
  ThreeButtons({
    required this.action,
    required this.text,
    required this.active,
    required this.tag,
    required this.jobsViewModel,
  });
  @override
  _ThreeButtonsState createState() => _ThreeButtonsState();
}

class _ThreeButtonsState extends State<ThreeButtons> {
  void handleTap() {
    setState(() {
      widget.action(widget.tag);
      widget.jobsViewModel
          .setInputValues(index: 'severity_level', value: widget.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // splashColor: Colors.transparent,
      // highlightColor: Colors.transparent,
      onPressed: handleTap,
      style: ElevatedButton.styleFrom(
        elevation: 0.0,
        shadowColor: Colors.transparent,
        backgroundColor: widget.active
            ? context.resources.color.btnColorBlue
            : context.resources.color.colorWhite,
        // side: BorderSide(
        //   width: 2,
        //   color: widget.active
        //       ? context.resources.color.btnColorBlue
        //       : context.resources.color.colorWhite,
        // ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        fixedSize: Size(
          context.appValues.appSizePercent.w29,
          context.appValues.appSizePercent.h7,
        ),
      ),
      child: Text(
        widget.text,
        style: getPrimaryRegularStyle(
            fontSize: 17,
            color: widget.active
                ? context.resources.color.colorWhite
                : context.resources.color.secondColorBlue),
      ),
    );
  }
}
