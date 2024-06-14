import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class CircleButton extends StatefulWidget {
  final ValueChanged<String> action; //callback value change
  final String tag; //tag of button
  final String text;
  final bool active; // state of button
  CircleButton(
      {required this.action,
      required this.text,
      required this.active,
      required this.tag});
  @override
  _CircleButtonState createState() => _CircleButtonState();
}

class _CircleButtonState extends State<CircleButton> {
  void handleTap() {
    setState(() {
      widget.action(widget.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          onPressed: handleTap,
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor:
                widget.active ? const Color(0xffFFD105) : Colors.transparent,
            side: BorderSide(
              width: 2,
              color: widget.active
                  ? const Color(0xffFFD105)
                  : context.resources.color.secondColorBlue,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            fixedSize: Size(
              context.appValues.appSizePercent.w29,
              context.appValues.appSizePercent.h6,
            ),
          ),
          child: Text(
            widget.text,
            style: getPrimaryRegularStyle(
                fontSize: 17,
                color: widget.active
                    ? context.resources.color.btnColorBlue
                    : context.resources.color.secondColorBlue),
          ),
        ),
      ],
    );
  }
}
