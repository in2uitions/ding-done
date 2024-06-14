import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';

class AddressWidget extends StatefulWidget {
  var address;

  AddressWidget({super.key, required this.address});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p10,
      ),
      child: Container(
        width: context.appValues.appSizePercent.w90,
        // height: context.appValues.appSizePercent.h10,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: Colors.white,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Text(
                translate('updateJob.address'),
                style: getPrimaryBoldStyle(
                  fontSize: 20,
                  color: const Color(0xff180C38),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p15,
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/img/location.svg'),
                  const Gap(10),
                  Text(
                    '${widget.address}',
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: const Color(0xff190C39),
                    ),
                  ),
                ],
              ),
            ),
            // Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
            //   return Padding(
            //     padding: EdgeInsets.symmetric(
            //         horizontal: context.appValues.appPadding.p10),
            //     child: CustomLocationDropDown(
            //       profileViewModel: profileViewModel,
            //       color: 0xff000000,
            //       backgroundColor: 0xffffffff,
            //     ),
            //   );
            // }),
          ],
        ),
      ),
    );
  }
}
