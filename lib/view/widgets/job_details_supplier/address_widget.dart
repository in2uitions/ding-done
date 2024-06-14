import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/custom/custom_location_dropdown.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressWidget extends StatefulWidget {
  const AddressWidget({super.key});

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
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p0,
              ),
              child: Text(
                'Address',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ),
            Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
              return Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p10),
                child: CustomLocationDropDown(
                  profileViewModel: profileViewModel,
                  color: 0xff000000,
                  backgroundColor: 0xffffffff,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
