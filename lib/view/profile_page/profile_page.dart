import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/settings_screen/settings_screen.dart';
import 'package:dingdone/view/widgets/profile/profile_component.dart';
import 'package:dingdone/view/widgets/profile/profile_second_component.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';
import '../../view_model/dispose_view_model/app_view_model.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isDeleteBusy = false;

  Future<void> _handleRefresh() async {
    try {
      await Provider.of<ProfileViewModel>(context, listen: false).readJson();
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
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      // backgroundColor: const Color(0xffF0F3F8),
      body: Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
        return Stack(
          children: [
            Container(
              height: context.appValues.appSizePercent.h50,
              width: context.appValues.appSizePercent.w100,
              decoration: const BoxDecoration(
                color: Color(0xff4100E3),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.appValues.appPadding.p10,
                ),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'profile.account'.tr(),
                              style: getPrimarySemiBoldStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context).push(_createRoute(
                                  const SettingsScreen(),
                                ));
                              },
                              child:
                                  SvgPicture.asset('assets/img/settings.svg'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p10,
                          bottom: context.appValues.appPadding.p15,
                          left: context.appValues.appPadding.p0,
                        ),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(32),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                profileViewModel.getProfileBody['user'] !=
                                            null &&
                                        profileViewModel.getProfileBody['user']
                                                ['avatar'] !=
                                            null
                                    ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                                    : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                      // const Gap(15),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            profileViewModel.getProfileBody["user"] != null
                                ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                                : '',
                            style: getPrimarySemiBoldStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            profileViewModel.getProfileBody["user"] != null
                                ? '${profileViewModel.getProfileBody["user"]["email"]}'
                                : '',
                            style: getPrimaryRegularStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DraggableScrollableSheet(
                initialChildSize: 0.62,
                minChildSize: 0.62,
                maxChildSize: 1,
                builder:
                    (BuildContext context, ScrollController scrollController) {
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Container(
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Gap(30),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        context.appValues.appPadding.p20,
                                    // vertical: context.appValues.appPadding.p30,
                                  ),
                                  child: Text(
                                  'drawer.manageAccount'.tr(),
                                    style: getPrimaryMediumStyle(
                                      fontSize: 14,
                                      color: const Color(0xff180B3C),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                ProfileComponent(
                                  // payment_method: data.data,
                                  role: profileViewModel
                                              .getProfileBody["user"] !=
                                          null
                                      ? profileViewModel.getProfileBody["user"]
                                          ["role"]
                                      : '',
                                ),
                                const Gap(30),

                                InkWell(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: context.appValues.appPadding.p5,
                                        left: context.appValues.appPadding.p15,
                                        right:
                                        context.appValues.appPadding.p15),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/img/bin.svg',
                                              // width: 16,
                                              // height: 16,
                                            ),
                                            const Gap(10),
                                            Text(
                                              'drawer.deleteAccount'.tr(),
                                              style: getPrimaryRegularStyle(
                                                fontSize: 14,
                                                color: context.resources.color
                                                    .btnColorBlue,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Color(0xff8F9098),
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: _isDeleteBusy
                                      ? null
                                      : () async {
                                    setState(() => _isDeleteBusy = true);

                                    await _confirmAndDelete(profileViewModel);

                                    // If you want to re-enable later, turn it back to false:
                                    setState(() => _isDeleteBusy = false);
                                  },
                                ),
                                const Gap(40),

                                const ProfileSeconComponent(),

                              ],
                            );
                          }),
                    ),
                  );
                }),
          ],
        );
      }),
    );
  }
  Future<void> _confirmAndDelete(ProfileViewModel profileViewModel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    child: SvgPicture.asset('assets/img/x.svg'),
                    onTap: () async {
                      Navigator.pop(context);

                    },
                  ),
                ],
              ),
            ),
            SvgPicture.asset('assets/img/remove-card-confirmation-icon.svg'),
            SizedBox(height: context.appValues.appSize.s40),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p0,
              ),
              child: Text(
                // translate('bookService.serviceRequestConfirmed'),
                'drawer.delete?'.tr(),
                textAlign: TextAlign.center,
                style: getPrimaryMediumStyle(
                  fontSize: 14,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
            ),
            const Gap(20),
            InkWell(
              onTap: () async {
                Navigator.pop(context, true);

                dynamic value=await profileViewModel.deleteProfile();
                if(value["status"].toString().toLowerCase()=='ok'){
                  showDialog(
                      context: context,
                      builder:
                          (BuildContext context) =>
                          simpleAlert(context, 'button.success'.tr(),'',profileViewModel));
                }else{
                  showDialog(context: context, builder: (BuildContext context) => simpleAlert(context,'button.failure'.tr(),value["reason"].toString(),profileViewModel));
                }
              },
              child: Container(
                width: context.appValues.appSizePercent.w100,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    // translate('confirmAddress.delete'),
                    "Yes, I’m Done With It",
                    style: getPrimarySemiBoldStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // const Gap(20),
          ],
        ),
      ),
    );

  }
  // Widget simpleAlert(BuildContext context, String message,String error,ProfileViewModel profileViewModel) {
  //   return AlertDialog(
  //     backgroundColor: Colors.white,
  //     elevation: 15,
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       // crossAxisAlignment: CrossAxisAlignment.center,
  //       children: <Widget>[
  //         Padding(
  //           padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.end,
  //             children: [
  //               InkWell(
  //                 child: SvgPicture.asset('assets/img/x.svg'),
  //                 onTap: () {
  //                   if(message == 'button.success'.tr()){
  //                     Navigator.pop(context);
  //                     AppPreferences().clear();
  //                     profileViewModel.clear();
  //                     AppProviders.disposeAllDisposableProviders(
  //                         context);
  //                     Navigator.of(context)
  //                         .push(_createRoute(const LoginScreen()));
  //
  //                   }
  //
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //         message == 'button.success'.tr()
  //             ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
  //             : SvgPicture.asset('assets/img/failure.svg'),
  //         SizedBox(height: context.appValues.appSize.s40),
  //         Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             message,
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ),  message == 'button.success'.tr()?
  //         SizedBox(height: context.appValues.appSize.s20):Container(),
  //         message == 'button.success'.tr()?Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             'Request Sent',
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ):Padding(
  //           padding: EdgeInsets.symmetric(
  //             horizontal: context.appValues.appPadding.p32,
  //           ),
  //           child: Text(
  //             '$error',
  //             textAlign: TextAlign.center,
  //             style: getPrimaryRegularStyle(
  //
  //               fontSize: 17,
  //               color: context.resources.color.btnColorBlue,
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: context.appValues.appSize.s20),
  //       ],
  //     ),
  //   );
  // }
  Widget simpleAlert(
      BuildContext context,
      String message,
      String error,
      ProfileViewModel profileViewModel,
      ) {
    final bool isSuccess = message == 'button.success'.tr();

    return WillPopScope(
      onWillPop: () async => false, // 🚫 disable back button
      child: AlertDialog(
        backgroundColor: Colors.white,
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ❌ Close icon
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  child: SvgPicture.asset('assets/img/x.svg'),
                  onTap: isSuccess
                      ? () => _logoutAndGoToLogin(profileViewModel)
                      : () => Navigator.pop(context),
                ),
              ],
            ),

            isSuccess
                ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
                : SvgPicture.asset('assets/img/failure.svg'),

            SizedBox(height: context.appValues.appSize.s30),

            Text(
              message,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 16,
                color: context.resources.color.btnColorBlue,
              ),
            ),

            const Gap(10),

            Text(
              isSuccess ? 'Request Sent' : error,
              textAlign: TextAlign.center,
              style: getPrimaryRegularStyle(
                fontSize: 16,
                color: context.resources.color.btnColorBlue,
              ),
            ),

            const Gap(25),

            // ✅ OK BUTTON
            InkWell(
              onTap: isSuccess
                  ? () => _logoutAndGoToLogin(profileViewModel)
                  : () => Navigator.pop(context),
              child: Container(
                height: 44,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff4100E3),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'button.ok'.tr(),
                    style: getPrimarySemiBoldStyle(
                      fontSize: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _logoutAndGoToLogin(ProfileViewModel profileViewModel) {
    Navigator.pop(context); // close alert dialog
    Navigator.pop(context); // close profile/settings if needed

    AppPreferences().clear();
    profileViewModel.clear();
    AppProviders.disposeAllDisposableProviders(context);

    Navigator.of(context).pushAndRemoveUntil(
      _createRoute(const LoginScreen()),
          (route) => false,
    );
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
