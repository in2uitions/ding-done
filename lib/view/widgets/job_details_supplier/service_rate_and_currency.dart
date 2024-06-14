import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class ServiceRateAndCurrnecyWidget extends StatefulWidget {
  const ServiceRateAndCurrnecyWidget({super.key});

  @override
  State<ServiceRateAndCurrnecyWidget> createState() =>
      _ServiceRateAndCurrnecyWidgetState();
}

class _ServiceRateAndCurrnecyWidgetState
    extends State<ServiceRateAndCurrnecyWidget> {
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
                context.appValues.appPadding.p20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      bottom: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      'Service Rate',
                      style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.secondColorBlue,
                      ),
                    ),
                  ),
                  Text(
                    'Service rate text',
                    style: getPrimaryRegularStyle(
                      fontSize: 13,
                      color: context.resources.color.colorBlack[50],
                    ),
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
                context.appValues.appPadding.p20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: context.appValues.appPadding.p10,
                      bottom: context.appValues.appPadding.p10,
                    ),
                    child: Text(
                      'Currency',
                      style: getPrimaryRegularStyle(
                        fontSize: 15,
                        color: context.resources.color.secondColorBlue,
                      ),
                    ),
                  ),
                  Text(
                    'USD',
                    style: getPrimaryRegularStyle(
                      fontSize: 13,
                      color: context.resources.color.colorBlack[50],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
