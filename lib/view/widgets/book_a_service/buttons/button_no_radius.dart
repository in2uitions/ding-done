import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class ThreeButtonss extends StatefulWidget {
  final ValueChanged<String> action; //callback value change
  final String tag; //tag of button
  final String text;
  final bool active; // state of button
  ThreeButtonss(
      {required this.action,
      required this.text,
      required this.active,
      required this.tag});
  @override
  _ThreeButtonssState createState() => _ThreeButtonssState();
}

class _ThreeButtonssState extends State<ThreeButtonss> {
  void handleTap() {
    setState(() {
      widget.action(widget.tag);
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
          borderRadius: BorderRadius.circular(0.0),
          // side: BorderSide(color: Colors.blue, width: 2.0),
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
