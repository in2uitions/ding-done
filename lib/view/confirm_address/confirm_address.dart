import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_address/add_new_address_widget.dart';
import 'package:dingdone/view/widgets/confirm_address/addresses_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
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
      String? role =
          await AppPreferences().get(key: userRoleKey, isModel: false);

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
      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
          // backgroundColor: const Color(0xffF0F3F8),
          backgroundColor: const Color(0xffFEFEFE),
          body: Stack(
            children: [
              Container(
                width: context.appValues.appSizePercent.w100,
                height: context.appValues.appSizePercent.h50,
                decoration: const BoxDecoration(
                  color: Color(0xff4100E3),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20,
                      vertical: context.appValues.appPadding.p10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          translate('confirmAddress.confirmAddress'),
                          style: getPrimarySemiBoldStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                  initialChildSize: 0.85,
                  minChildSize: 0.85,
                  maxChildSize: 1,
                  builder: (BuildContext context,
                      ScrollController scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Color(0xffFEFEFE),
                      ),
                      child: ListView.builder(
                          controller: scrollController,
                          itemCount: 1,
                          padding: EdgeInsets.zero,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        context.appValues.appPadding.p20,
                                    vertical: context.appValues.appPadding.p10,
                                  ),
                                  child: Text(
                                    translate('profile.addresses'),
                                    style: getPrimaryRegularStyle(
                                      fontSize: 12,
                                      color: const Color(0xff2F3036),
                                    ),
                                  ),
                                ),
                                const AddressesButtonsWidget(),
                                const AddNewAddressWidget(),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: context.appValues.appPadding.p10,
                                    horizontal:
                                        context.appValues.appPadding.p25,
                                  ),
                                  child: Container(
                                    width: 327,
                                    height: 44,
                                    decoration: BoxDecoration(
                                      color: const Color(0xff4100E3),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: InkWell(
                                      onTap: () async {
                                        if (jobsViewModel.validate()) {
                                          await profileViewModel
                                              .patchProfileData(
                                                  jobsViewModel.getjobsBody);
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          translate('button.save'),
                                          style: getPrimaryBoldStyle(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Gap(20),
                              ],
                            );
                          }),
                    );
                  }),
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
