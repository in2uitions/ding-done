import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DefinitionAndInterpretation extends StatefulWidget {
  const DefinitionAndInterpretation({super.key});

  @override
  State<DefinitionAndInterpretation> createState() =>
      _DefinitionAndInterpretationState();
}

class _DefinitionAndInterpretationState
    extends State<DefinitionAndInterpretation> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('termsAndConditionsCustomer.definitionAndIntegration'),
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
                translate('termsAndConditionsCustomer.defAndInt1'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 17),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  children: [
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt11'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt12'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt13'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt14'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt15'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt16'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                  ],
                ),
              ),
              Text(
                translate('termsAndConditionsCustomer.defAndInt2'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 17),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p15,
                ),
                child: Column(
                  children: [
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt21'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt22'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt23'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt24'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt25'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt26'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt27'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt28'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt29'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt210'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt211'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsCustomer.defAndInt212'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
