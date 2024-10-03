import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

class DefinitionsSupplier extends StatefulWidget {
  const DefinitionsSupplier({super.key});

  @override
  State<DefinitionsSupplier> createState() => _DefinitionsSupplierState();
}

class _DefinitionsSupplierState extends State<DefinitionsSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('termsAndConditionsSupplier.definitionAndIntegration'),
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
                translate('termsAndConditionsSupplier.defAndInt21'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p20,
                ),
                child: Column(
                  children: [
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21a'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21b'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21c'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21d'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21e'),
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
