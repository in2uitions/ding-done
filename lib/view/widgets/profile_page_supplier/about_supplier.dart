import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_text_area_white.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AboutSupplier extends StatefulWidget {
  var profileViewModel;

   AboutSupplier({super.key,required this.profileViewModel});

  @override
  State<AboutSupplier> createState() => _AboutSupplierState();
}

class _AboutSupplierState extends State<AboutSupplier> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p0,
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p10,
      ),
      child: Container(
        width: context.appValues.appSizePercent.w100,
        // height: context.appValues.appSizePercent.h22,
        // height: 139,
        decoration: BoxDecoration(
          color: context.resources.color.colorWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.appValues.appPadding.p20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.info_outline_rounded,
                      color: Color(0xff58537B),
                    ),
                    Text(
                      translate('formHints.about'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                color: Color(0xffEDF1F7),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.appValues.appPadding.p20,
                ),
                child:  CustomTextAreaWhite(
                  index: 'description',
                  value: widget.profileViewModel.getProfileBody["user"]["description"],
                  // hintText: translate('profile.sentenceAboutYou'),
                  viewModel: widget.profileViewModel.setInputValues,
                  keyboardType: TextInputType.text,
                  maxlines: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
