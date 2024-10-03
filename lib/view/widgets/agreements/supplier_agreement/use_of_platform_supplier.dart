import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

class UseOfPlatformSupplier extends StatefulWidget {
  const UseOfPlatformSupplier({super.key});

  @override
  State<UseOfPlatformSupplier> createState() => _UseOfPlatformSupplierState();
}

class _UseOfPlatformSupplierState extends State<UseOfPlatformSupplier> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate('termsAndConditionsSupplier.useOfPlatform'),
          style: getPrimaryRegularStyle(
              color: context.resources.color.secondColorBlue, fontSize: 18),
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
                translate('termsAndConditionsSupplier.useOfPlatform1'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
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
                      translate('termsAndConditionsSupplier.useOfPlatform1a'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.useOfPlatform1b'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.useOfPlatform1c'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                    Text(
                      translate('termsAndConditionsSupplier.useOfPlatform1d'),
                      style: getPrimaryRegularStyle(
                          color: context.resources.color.btnColorBlue,
                          fontSize: 15),
                    ),
                    SizedBox(height: context.appValues.appSize.s10),
                  ],
                ),
              ),
              Text(
                translate('termsAndConditionsSupplier.useOfPlatform2'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.useOfPlatform3'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.useOfPlatform4'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
              SizedBox(height: context.appValues.appSize.s10),
              Text(
                translate('termsAndConditionsSupplier.useOfPlatform5'),
                style: getPrimaryRegularStyle(
                    color: context.resources.color.btnColorBlue, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
