import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  dynamic image = {};
  Future<void> _handleRefresh() async {
    try {
      String? role = await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(EditAccount()));


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
    return Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
      debugPrint('image ${profileViewModel.getProfileBody['user']}');
      dynamic imageWidget = image['image'] != null
          ? image['type'] == 'file'
              ? FileImage(image['image'])
              : NetworkImage(
                  '${context.resources.image.networkImagePath}${image['image']}')
          : NetworkImage(
              profileViewModel.getProfileBody['user']['avatar'] != null
                  ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            );

      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
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
                      child: Padding(
                        padding: EdgeInsets.all(context.appValues.appPadding.p20),
                        child: Directionality(
                          textDirection: TextDirection.ltr,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    context.appValues.appPadding.p3,
                                    context.appValues.appPadding.p3,
                                    context.appValues.appPadding.p10,
                                    context.appValues.appPadding.p3,
                                  ),
                                  child: SvgPicture.asset(
                                    'assets/img/back.svg',
                                    // colorFilter: const ColorFilter.mode(
                                    //     Colors.white, BlendMode.srcIn),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: context.appValues.appPadding.p10,
                                ),
                                child: Text(
                                  translate('profile.account'),
                                  style: getPrimaryBoldStyle(
                                    // color: context.resources.color.colorYellow,
                                    color: const Color(0xff180C38),
                                    fontSize: 32,
                                  ),
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
                    child: Column(
                      children: [
                        Column(
                          children: [
                            CircleAvatar(
                              backgroundImage: imageWidget,
                              radius: 70,
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(height: context.appValues.appSize.s20),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff9E9AB7),
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: context.appValues.appPadding.p10,
                                horizontal: context.appValues.appPadding.p20,
                              ),
                              child: UploadOneImage(
                                callback: (picked, save) async {
                                  if (picked != null) {
                                    setState(() {
                                      image = {
                                        'type': 'file',
                                        'image': File(picked[0].path)
                                      };
                                    });
                                  }
                                  if (save != null) {
                                    debugPrint('save 0 ${save[0]["image"]}');
                                    profileViewModel.setInputValues(
                                        index: 'avatar', value: save[0]["image"]);
                                  }
                                },
                                isImage: true,
                                widget: Text(
                                  translate('profile.editProfilePhoto'),
                                  style: getPrimaryBoldStyle(
                                      fontSize: 21, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Gap(20),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('profile.personalInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, context.appValues.appPadding.p10, 0, 0),
                          child: CustomTextField(
                            index: 'first_name',
                            viewModel: profileViewModel.setInputValues,
                            hintText: translate('formHints.first_name'),
                            keyboardType: TextInputType.text,
                            value: profileViewModel.getProfileBody["user"]
                                ["first_name"],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: context.appValues.appPadding.p10),
                          child: CustomTextField(
                            index: 'last_name',
                            viewModel: profileViewModel.setInputValues,
                            hintText: translate('formHints.last_name'),
                            keyboardType: TextInputType.text,
                            value: profileViewModel.getProfileBody["user"]
                                ["last_name"],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('profile.contactInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, context.appValues.appPadding.p10, 0, 0),
                          child: CustomTextField(
                            index: 'email',
                            viewModel: profileViewModel.setInputValues,
                            hintText: translate('formHints.email'),
                            keyboardType: TextInputType.emailAddress,
                            value: profileViewModel.getProfileBody["user"]["email"],
                          ),
                        ),
                        const Gap(10),
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              0, context.appValues.appPadding.p10, 0, 0),
                          child: CustomPhoneFeild(
                            index: 'phone_number',
                            viewModel: profileViewModel.setInputValues,
                            hintText: translate('formHints.phone_number'),
                            errorText: '',
                            value: profileViewModel.getProfileBody["user"]
                                ["phone_number"],
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xff000000).withOpacity(0.1),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                            color: context.resources.color.colorWhite,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: context.appValues.appPadding.p20,
                                    vertical: context.appValues.appPadding.p10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'assets/img/location.svg'),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 0, 0, 0),
                                          child: Text(
                                            translate('profile.addresses'),
                                            style: getPrimaryBoldStyle(
                                              fontSize: 20,
                                              color: const Color(0xff180C38),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color(0xff58537A),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical:
                                              context.appValues.appPadding.p5,
                                          horizontal:
                                              context.appValues.appPadding.p20,
                                        ),
                                        child: InkWell(
                                          child: Text(
                                            translate('profile.changeLocation'),
                                            style: getPrimaryRegularStyle(
                                              fontSize: 13,
                                              color: const Color(0xff180C38),
                                            ),
                                          ),
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(_createRoute(
                                              // MapScreen(viewModel: jobsViewModel)));
                                              ConfirmAddress(),
                                            ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                    0, 0, 0, context.appValues.appPadding.p0),
                                child: SizedBox(
                                  height: 180,
                                  child: MapDisplay(
                                    body: profileViewModel.getProfileBody,
                                    longitude: profileViewModel
                                        .getProfileBody['current_address']["longitude"],
                                    latitude: profileViewModel
                                        .getProfileBody['current_address']["latitude"],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
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
                ],
              ),
            ],
          ),
        ),
      );
    });
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
                  Future.delayed(const Duration(seconds: 0));
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
