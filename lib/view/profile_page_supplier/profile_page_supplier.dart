// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/login/login.dart';
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
  bool _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xffF0F3F8),
      backgroundColor: const Color(0xffFFFFFF),
      body: Consumer2<ProfileViewModel, LoginViewModel>(
          builder: (context, profileViewModel, loginViewModel, _) {
        return ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xffEAEAFF).withOpacity(0.5),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: context.appValues.appPadding.p10,
                ),
                child: Row(
                  children: [
                    SafeArea(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: context.appValues.appPadding.p10,
                          bottom: context.appValues.appPadding.p15,
                          left: context.appValues.appPadding.p20,
                        ),
                        child: Container(
                          width: 102,
                          height: 102,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                profileViewModel.getProfileBody['user']!=null && profileViewModel.getProfileBody['user']
                                            ['avatar'] !=
                                        null
                                    ? profileViewModel.getProfileBody['user']
                                            ['avatar'] is Map<String, dynamic>
                                        ? '${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']['filename_disk']}'
                                        : '${context.resources.image.networkImagePath2}/${profileViewModel.getProfileBody['user']['avatar']}'
                                    : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Gap(15),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profileViewModel.getProfileBody["user"] != null
                              ? '${profileViewModel.getProfileBody["user"]["first_name"]} ${profileViewModel.getProfileBody["user"]["last_name"]}'
                              : '',
                          style: getPrimaryRegularStyle(
                            fontSize: 25,
                            color: const Color(0xff1F126B),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stars(
                              rating: 4,
                              itemSize: 18,
                            ),
                            const Gap(5),
                            Text(
                              '93 reviews',
                              style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: const Color(0xff7B7B7B),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: context.appValues.appPadding.p5,
                              ),
                              child: SvgPicture.asset(
                                'assets/img/location-profile.svg',
                              ),
                            ),
                            const Gap(5),
                            SizedBox(
                              width: context.appValues.appSizePercent.w60,
                              child: Text(
                                profileViewModel.getProfileBody!=null && profileViewModel.getProfileBody['current_address']!=null?
                                '${profileViewModel.getProfileBody['current_address']["street_number"]}, ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}':'',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: getPrimaryRegularStyle(
                                  fontSize: 18,
                                  color: const Color(0xff1F126B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Gap(30),

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
                          // if (await profileViewModel.patchUserData(
                          //         profileViewModel.getProfileBody) ==
                          //     true) {
                          debugPrint('selected Services ${profileViewModel.selectedServices}');
                          setState(() {
                            _isLoading=true;

                          });
                          if(await profileViewModel.patchProfileServices()==true){

                            showDialog(
                                context: context,
                                builder: (BuildContext context) => simpleAlert(
                                  context,
                                  translate('button.success'),
                                ));


                          } else {

                            showDialog(
                                context: context,
                                builder: (BuildContext context) => simpleAlert(
                                      context,
                                      translate('button.failure'),
                                    ));
                          }
                          setState(() {
                            _isLoading=false;

                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff4100E3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child:
                        _isLoading?
                        CircularProgressIndicator()
                            :
                        Text(
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
                        SvgPicture.asset(
                          'assets/img/logout-new.svg',
                        ),
                        const Gap(10),
                        Text(
                          translate('drawer.logout'),
                          style: getPrimaryRegularStyle(
                            fontSize: 20,
                            color: const Color(0xff78789D),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  AppPreferences().clear();
                  AppProviders.disposeAllDisposableProviders(context);
                  Navigator.of(context).push(_createRoute(const LoginScreen()));
                },
              ),
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
