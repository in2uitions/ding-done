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
          translate('termsAndConditionsSupplier.partiesAgree'),
          style: getPrimaryRegularStyle(
              color: context.resources.color.secondColorBlue, fontSize: 18),
        ),
        Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: Text(
            translate('termsAndConditionsSupplier.definitionAndIntegration'),
            style: getPrimaryRegularStyle(
                color: context.resources.color.secondColorBlue, fontSize: 17),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s10),
        Padding(
          padding: EdgeInsets.only(
            left: context.appValues.appPadding.p15,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  translate('termsAndConditionsSupplier.defAndInt1'),
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.btnColorBlue, fontSize: 15),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p20,
                ),
                child: Column(
                  children: [
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt11'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt12'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt13'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt14'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt15'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt16'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),

              Padding(
                padding: const EdgeInsets.only(left:8.0),
                child: Text(
                  translate('termsAndConditionsSupplier.defAndInt2'),
                  style: getPrimaryRegularStyle(
                      color: context.resources.color.btnColorBlue, fontSize: 15),
                ),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Padding(
                padding: EdgeInsets.only(
                  left: context.appValues.appPadding.p20,
                ),
                child: Column(
                  children: [
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt21'),

                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt22'),

                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt23'),

                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt24'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt25'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt26'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt27'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt28'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt29'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt210'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt211'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.defAndInt212'),
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
