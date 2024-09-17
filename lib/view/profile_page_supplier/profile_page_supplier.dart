// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/about_supplier.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/location_supplier_profile.dart';
import 'package:dingdone/view/widgets/profile_page_supplier/services_offered_supplier.dart';
import 'package:dingdone/view/widgets/stars/stars.dart';
import 'package:dingdone/view_model/dispose_view_model/app_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfilePageSupplier extends StatefulWidget {
  var data;
  var list;

  ProfilePageSupplier({super.key, required this.data, required this.list});

  @override
  State<ProfilePageSupplier> createState() => _ProfilePageSupplierState();
}

class _ProfilePageSupplierState extends State<ProfilePageSupplier> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFEFEFE),
      body: Consumer2<ProfileViewModel,LoginViewModel>(builder: (context, profileViewModel,loginViewModel, _) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Column(
              children: [
                SafeArea(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.all(context.appValues.appPadding.p20),
                      child: InkWell(
                        child: SvgPicture.asset('assets/img/back.svg'),
                        onTap: () {
                          Navigator.pop(context);

                          Navigator.of(context).push(_createRoute(
                              BottomBar(userRole: Constants.supplierRoleId)));
                        },
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: context.appValues.appSizePercent.w38p5,
                    height: context.appValues.appSizePercent.h18p8,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xff8E889E),
                        width: 4,
                      ),
                      borderRadius: BorderRadius.circular(100),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                          profileViewModel.getProfileBody['user']['avatar'] != null
                              ? profileViewModel.getProfileBody['user']['avatar'] is Map<String,dynamic>?'${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']['filename_disk']}':'${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']}'
                              : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p20,
                    vertical: context.appValues.appPadding.p10,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        profileViewModel.getProfileBody["user"] != null
                            ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                            : '',
                        style: getPrimaryBoldStyle(
                          fontSize: 32,
                          color: const Color(0xff180C38),
                        ),
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stars(
                            rating: 4,
                          ),
                          Text(
                            '93 reviews',
                            style: getPrimaryRegularStyle(
                              fontSize: 19,
                              color: const Color(0xff707070),
                            ),
                          )
                        ],
                      ),
                      const Gap(10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            color: Color(0xff707070),
                          ),
                          Flexible(
                            child: Text(
                              '${profileViewModel.getProfileBody['address'][0]["street_name"]} ${profileViewModel.getProfileBody['address'][0]["building_number"]}, ${profileViewModel.getProfileBody['address'][0]["city"]}, ${profileViewModel.getProfileBody['address'][0]["state"]}',
                              style: getPrimaryRegularStyle(
                                fontSize: 16,
                                color: const Color(0xff190C39),
                              ),
                              softWrap: true,
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
                const Gap(30),
                //  AboutSupplier(profileViewModel: profileViewModel,),
                const LoacationSupplierProfile(),
                ServicesOfferedSupplierProfile(
                  profileViewModel: profileViewModel,
                  data: widget.data,
                  list: widget.list,
                ),
                // Padding(
                //   padding:
                //       EdgeInsets.only(left: context.appValues.appPadding.p15),
                //   child: const Divider(
                //     height: 20,
                //     thickness: 2,
                //     color: Color(0xffEDF1F7),
                //   ),
                // ),
                SizedBox(
                  height: context.appValues.appSizePercent.h10,
                  width: context.appValues.appSizePercent.w100,
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
                              if(await profileViewModel
                                  .patchUserData(profileViewModel.getProfileBody)==true){
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        simpleAlert(
                                          context,
                                          translate('button.success'),
                                        ));
                              }else{
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        simpleAlert(
                                          context,
                                          translate('button.failure'),
                                        ));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF3D347),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: getPrimaryBoldStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: context.appValues.appPadding.p15,
                    left: context.appValues.appPadding.p20,
                    right: context.appValues.appPadding.p20,
                  ),
                  child: InkWell(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(50),
                                ),
                                color: Color(0xffEDF1F7),
                              ),
                              child: Align(
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/img/sign-out.svg',
                                  width: 16,
                                  height: 16,
                                  color: Color(0xff04043E),
                                ),
                              ),
                            ),
                            SizedBox(width: context.appValues.appSize.s10),
                            Text(
                              translate('drawer.logout'),
                              style: getPrimaryRegularStyle(
                                fontSize: 20,
                                color: const Color(0xff180C38),
                              ),
                            ),
                          ],
                        ),
                        SvgPicture.asset(
                          'assets/img/right-arrow.svg',
                        ),
                      ],
                    ),
                    onTap: () {
                      AppPreferences().clear();
                      AppProviders.disposeAllDisposableProviders(context);
                      Navigator.of(context)
                          .push(_createRoute(const LoginScreen()));
                    },
                  ),
                ),

              ],
            ),
            const Gap(30)
          ],
        );
      }),
    );
  }
}
Widget simpleAlert(BuildContext context, String message) {
  return AlertDialog(
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
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        message == 'Success'
            ? SvgPicture.asset('assets/img/service-popup-image.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 17,
              color: context.resources.color.btnColorBlue,
            ),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s20),
      ],
    ),
  );
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
