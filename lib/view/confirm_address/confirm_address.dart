import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_address/add_new_address_widget.dart';
import 'package:dingdone/view/widgets/confirm_address/addresses_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';

class ConfirmAddress extends StatefulWidget {
  ConfirmAddress({super.key});

  @override
  State<ConfirmAddress> createState() => _ConfirmAddressState();
}

class _ConfirmAddressState extends State<ConfirmAddress> {
  Future<void> _handleRefresh() async {
    try {
      String? role = await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(ConfirmAddress()));


    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer2<ProfileViewModel, JobsViewModel>(
        builder: (context, profileViewModel, jobsViewModel, _) {
      return  RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          // backgroundColor: const Color(0xffF0F3F8),
          backgroundColor: const Color(0xffFEFEFE),
          body: Stack(
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Container(
                    // decoration: BoxDecoration(
                    //   color: context.resources.color.btnColorBlue,
                    //   borderRadius: const BorderRadius.only(
                    //       bottomLeft: Radius.circular(20),
                    //       bottomRight: Radius.circular(20)),
                    // ),
                    child: SafeArea(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Padding(
                          padding:
                              EdgeInsets.all(context.appValues.appPadding.p20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: SvgPicture.asset('assets/img/back.svg'),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                translate('confirmAddress.confirmAddress'),
                                style: getPrimaryBoldStyle(
                                  color: const Color(0xff180C38),
                                  fontSize: 32,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(context.appValues.appPadding.p20),
                    child: Text(
                      translate('profile.addresses'),
                      style: getPrimaryBoldStyle(
                        fontSize: 28,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ),
                  const AddressesButtonsWidget(),
                  const AddNewAddressWidget(),
                  // SizedBox(height: context.appValues.appSize.s90),
                  SizedBox(
                    height: context.appValues.appSizePercent.h10,
                    width: context.appValues.appSizePercent.w100,
                    // decoration: BoxDecoration(
                    //   borderRadius: const BorderRadius.only(
                    //       topLeft: Radius.circular(20),
                    //       topRight: Radius.circular(20)),
                    //   color: context.resources.color.btnColorBlue,
                    // ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.appValues.appPadding.p10,
                        horizontal: context.appValues.appPadding.p15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: context.appValues.appSizePercent.w90,
                            height: context.appValues.appSizePercent.h100,
                            child: ElevatedButton(
                              onPressed: () async {
                                await profileViewModel
                                    .patchProfileData(jobsViewModel.getjobsBody);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffF3D347),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                translate('confirmAddress.addNewAddress'),
                                style: getPrimaryBoldStyle(
                                  fontSize: 18,
                                  color: context.resources.color.colorWhite,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}