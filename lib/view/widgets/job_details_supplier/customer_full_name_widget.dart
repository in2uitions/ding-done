import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomerFullNameWidget extends StatefulWidget {
  var user;

   CustomerFullNameWidget({super.key,required this.user});

  @override
  State<CustomerFullNameWidget> createState() => _CustomerFullNameWidgetState();
}

class _CustomerFullNameWidgetState extends State<CustomerFullNameWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p20,
          vertical: context.appValues.appPadding.p10),
      child: Container(
        width: context.appValues.appSizePercent.w90,
        // height: context.appValues.appSizePercent.h10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p0,
            context.appValues.appPadding.p20,
            context.appValues.appPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.appValues.appPadding.p10,
                ),
                child: Text(
                  'Customer',
                  style: getPrimaryRegularStyle(
                    fontSize: 15,
                    color: context.resources.color.secondColorBlue,
                  ),
                ),
              ),
              Text(
                '${widget.user}',
                style: getPrimaryRegularStyle(
                  fontSize: 13,
                  color: context.resources.color.colorBlack[50],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
