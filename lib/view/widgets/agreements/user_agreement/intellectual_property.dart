import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class IntellectualProperty extends StatefulWidget {
  const IntellectualProperty({super.key});

  @override
  State<IntellectualProperty> createState() => _IntellectualPropertyState();
}

class _IntellectualPropertyState extends State<IntellectualProperty> {
  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            translate('termsAndConditionsCustomer.intellectualProperty'),
            style: getPrimaryRegularStyle(
                color: context.resources.color.secondColorBlue, fontSize: 18),
          ),
          SizedBox(height: context.appValues.appSize.s10),
          Padding(
              padding: EdgeInsets.only(
                left: context.appValues.appPadding.p15,
              ),
              child: Column(
                children: [
                  Text(
                    translate('termsAndConditionsCustomer.intellectualProperty1'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.intellectualProperty2'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.appValues.appPadding.p15,
                    ),
                    child: Column(
                      children: [
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty21'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty22'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty23'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Text(
                    translate('termsAndConditionsCustomer.intellectualProperty3'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 15),
                  ),
                  SizedBox(height: context.appValues.appSize.s10),
                  Padding(
                    padding: EdgeInsets.only(
                      left: context.appValues.appPadding.p15,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty31'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty32'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                        SizedBox(height: context.appValues.appSize.s10),
                        Text(
                          translate('termsAndConditionsCustomer.intellectualProperty33'),
                          style: getPrimaryRegularStyle(
                              color: context.resources.color.btnColorBlue,
                              fontSize: 15),
                        ),
                      ],
                    ),
                  ),
                ],
              ))
        ]);
  }
}
