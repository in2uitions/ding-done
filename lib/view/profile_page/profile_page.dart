import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/settings_screen/settings_screen.dart';
import 'package:dingdone/view/widgets/profile/profile_component.dart';
import 'package:dingdone/view/widgets/profile/profile_second_component.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
                              translate('profile.account'),
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
                                    horizontal: context.appValues.appPadding.p20,
                                    // vertical: context.appValues.appPadding.p30,
                                  ),
                                  child: Text(
                                    'Manage Account',
                                    style: getPrimaryMediumStyle(
                                      fontSize: 14,
                                      color: const Color(0xff180B3C),
                                    ),
                                  ),
                                ),
                                const Gap(10),
                                ProfileComponent(
                                  // payment_method: data.data,
                                  role: profileViewModel.getProfileBody["user"] !=
                                          null
                                      ? profileViewModel.getProfileBody["user"]
                                          ["role"]
                                      : '',
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
