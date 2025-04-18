// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../res/app_prefs.dart';
import '../widgets/custom/custom_phone_field_controller.dart';

class EditAccount extends StatefulWidget {
  const EditAccount({super.key});

  @override
  State<EditAccount> createState() => _EditAccountState();
}

class _EditAccountState extends State<EditAccount> {
  dynamic image = {};

  Future<void> _handleRefresh() async {
    try {
      String? role =
          await AppPreferences().get(key: userRoleKey, isModel: false);

      // Simulate network fetch or database query
      await Future.delayed(const Duration(seconds: 2));
      // Update the list of items and refresh the UI
      Navigator.pop(context);
      Navigator.of(context).push(_createRoute(const EditAccount()));
    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }

  final TextEditingController _phoneController = TextEditingController();

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
              profileViewModel.getProfileBody['user'] != null
                  ? profileViewModel.getProfileBody['user']['avatar'] != null
                      ? '${context.resources.image.networkImagePath2}${profileViewModel.getProfileBody['user']['avatar']}'
                      : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                  : 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
            );

      return RefreshIndicator(
        onRefresh: _handleRefresh,
        child: Scaffold(
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
                          translate('bottom_bar.profile'),
                          style: getPrimaryBoldStyle(
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
                  initialChildSize: 0.75,
                  minChildSize: 0.75,
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
                          // controller: scrollController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: 1,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                // SizedBox(
                                //   height: context.appValues.appSizePercent.h35,
                                //   child: Stack(
                                //     children: [
                                //       // Container(
                                //       //   width: context.appValues.appSizePercent.w100,
                                //       //   height: context.appValues.appSizePercent.h25,
                                //       //   decoration: const BoxDecoration(
                                //       //     color: Color(0xff6F6BE8),
                                //       //     borderRadius: BorderRadius.only(
                                //       //       bottomLeft: Radius.circular(30),
                                //       //       bottomRight: Radius.circular(30),
                                //       //     ),
                                //       //   ),
                                //       //   child: Column(
                                //       //     children: [
                                //       //       SafeArea(
                                //       //         child: Padding(
                                //       //           padding: EdgeInsets.all(
                                //       //               context.appValues.appPadding.p20),
                                //       //           child: Directionality(
                                //       //             textDirection: TextDirection.ltr,
                                //       //             child: Stack(
                                //       //               // crossAxisAlignment: CrossAxisAlignment.start,
                                //       //               children: [
                                //       //                 InkWell(
                                //       //                   child: Padding(
                                //       //                     padding: EdgeInsets.fromLTRB(
                                //       //                       context.appValues.appPadding.p3,
                                //       //                       context.appValues.appPadding.p3,
                                //       //                       context.appValues.appPadding.p0,
                                //       //                       context.appValues.appPadding.p3,
                                //       //                     ),
                                //       //                     child: SvgPicture.asset(
                                //       //                       'assets/img/back.svg',
                                //       //                       // colorFilter: const ColorFilter.mode(
                                //       //                       colorFilter: ColorFilter.mode(
                                //       //                           Colors.white, BlendMode.srcIn),
                                //       //                       // BlendMode.srcIn),
                                //       //                     ),
                                //       //                   ),
                                //       //                   onTap: () {
                                //       //                     Navigator.pop(context);
                                //       //                   },
                                //       //                 ),
                                //       //                 Center(
                                //       //                   child: Text(
                                //       //                     translate('profile.yourProfile'),
                                //       //                     style: getPrimaryBoldStyle(
                                //       //                       color: context
                                //       //                           .resources.color.colorWhite,
                                //       //                       fontSize: 20,
                                //       //                     ),
                                //       //                   ),
                                //       //                 ),
                                //       //               ],
                                //       //             ),
                                //       //           ),
                                //       //         ),
                                //       //       ),
                                //       //     ],
                                //       //   ),
                                //       // ),
                                //       //
                                //       // Align(
                                //       //   alignment: Alignment.bottomCenter,
                                //       //   child: Stack(
                                //       //     children: [
                                //       //       Container(
                                //       //         width: 154,
                                //       //         height: 155,
                                //       //         decoration: BoxDecoration(
                                //       //           image: DecorationImage(
                                //       //             image: imageWidget,
                                //       //             fit: BoxFit.cover,
                                //       //           ),
                                //       //           borderRadius: const BorderRadius.only(
                                //       //             bottomLeft: Radius.circular(50),
                                //       //             bottomRight: Radius.circular(50),
                                //       //             topRight: Radius.circular(50),
                                //       //           ),
                                //       //         ),
                                //       //       ),
                                //       //       Positioned(
                                //       //         bottom: 0,
                                //       //         child: Container(
                                //       //           width: 154,
                                //       //           height: 45,
                                //       //           decoration: BoxDecoration(
                                //       //             borderRadius: const BorderRadius.only(
                                //       //               bottomLeft: Radius.circular(50),
                                //       //               bottomRight: Radius.circular(50),
                                //       //               // topRight: Radius.circular(50),
                                //       //             ),
                                //       //             color: const Color(0xff1F1F39).withOpacity(0.5),
                                //       //           ),
                                //       //           child: Center(
                                //       //             child: UploadOneImage(
                                //       //               callback: (picked, save) async {
                                //       //                 if (picked != null) {
                                //       //                   setState(() {
                                //       //                     image = {
                                //       //                       'type': 'file',
                                //       //                       'image': File(picked[0].path)
                                //       //                     };
                                //       //                   });
                                //       //                 }
                                //       //                 if (save != null) {
                                //       //                   debugPrint('save 0 ${save[0]["image"]}');
                                //       //                   profileViewModel.setInputValues(
                                //       //                       index: 'avatar',
                                //       //                       value: save[0]["image"]);
                                //       //                 }
                                //       //               },
                                //       //               isImage: true,
                                //       //               widget:
                                //       //                   SvgPicture.asset('assets/img/camera.svg'),
                                //       //             ),
                                //       //           ),
                                //       //         ),
                                //       //       ),
                                //       //     ],
                                //       //   ),
                                //       // ),
                                //     ],
                                //   ),
                                // ),
                                Padding(
                                  padding: EdgeInsets.all(
                                      context.appValues.appPadding.p20),
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: SizedBox(
                                          width: context
                                              .appValues.appSizePercent.w100,
                                          child: Text(
                                            translate('profile.yourName'),
                                            style: getPrimaryRegularStyle(
                                              color: const Color(0xff71727A),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(5),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            context.appValues.appPadding.p10,
                                            0,
                                            0),
                                        child: CustomTextField(
                                          index: 'first_name',
                                          viewModel:
                                              profileViewModel.setInputValues,
                                          hintText:
                                              translate('formHints.first_name'),
                                          keyboardType: TextInputType.text,
                                          value: profileViewModel
                                                  .getProfileBody["user"]
                                              ["first_name"],
                                          prefixIcon:
                                              'assets/img/account-feild.svg',
                                          isPrfixShown: true,
                                        ),
                                      ),
                                      const Gap(10),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: context
                                                .appValues.appPadding.p10),
                                        child: CustomTextField(
                                          index: 'last_name',
                                          viewModel:
                                              profileViewModel.setInputValues,
                                          hintText:
                                              translate('formHints.last_name'),
                                          keyboardType: TextInputType.text,
                                          value: profileViewModel
                                                  .getProfileBody["user"]
                                              ["last_name"],
                                          prefixIcon:
                                              'assets/img/account-feild.svg',
                                          isPrfixShown: true,
                                        ),
                                      ),
                                      const Gap(10),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 5, 0, 0),
                                        child: SizedBox(
                                          width: context
                                              .appValues.appSizePercent.w100,
                                          child: Text(
                                            translate('formHints.phone_number'),
                                            style: getPrimaryRegularStyle(
                                              color: const Color(0xff71727A),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(5),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            context.appValues.appPadding.p10,
                                            0,
                                            0),
                                        child:
                                            // CustomPhoneFeild(
                                            //   index: 'phone_number',
                                            //   viewModel: profileViewModel.setInputValues,
                                            //   hintText: translate('formHints.phone_number'),
                                            //   errorText: '',
                                            //   value: profileViewModel.getProfileBody["user"]
                                            //       ["phone_number"],
                                            // ),
                                            CustomPhoneFieldController(
                                          value: profileViewModel
                                              .getProfileBody["user"]["phone"],
                                          phone_code: profileViewModel
                                                  .getProfileBody["user"]
                                              ["phone_code"],
                                          phone_number: profileViewModel
                                                  .getProfileBody["user"]
                                              ["phone_number"],
                                          index: 'phone',
                                          viewModel:
                                              profileViewModel.setInputValues,
                                          controller: _phoneController,
                                          keyboardType: TextInputType.number,
                                        ),
                                      ),
                                      // const Gap(10),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 0, 0, 0),
                                        child: SizedBox(
                                          width: context
                                              .appValues.appSizePercent.w100,
                                          child: Text(
                                            translate('formHints.email'),
                                            style: getPrimaryRegularStyle(
                                              color: const Color(0xff71727A),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(5),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            context.appValues.appPadding.p10,
                                            0,
                                            0),
                                        child: CustomTextField(
                                          index: 'email',
                                          viewModel:
                                              profileViewModel.setInputValues,
                                          hintText:
                                              translate('formHints.email'),
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          value: profileViewModel
                                              .getProfileBody["user"]["email"],
                                          prefixIcon:
                                              'assets/img/email-feild.svg',
                                          isPrfixShown: true,
                                        ),
                                      ),
                                      const Gap(20),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: context.appValues.appSizePercent.h8,
                                  width: context.appValues.appSizePercent.w100,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical:
                                          context.appValues.appPadding.p10,
                                      horizontal:
                                          context.appValues.appPadding.p15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: context
                                              .appValues.appSizePercent.w90,
                                          height: context
                                              .appValues.appSizePercent.h100,
                                          child: ElevatedButton(
                                            onPressed: () async {
                                              if (await profileViewModel
                                                      .patchUserData(
                                                          profileViewModel
                                                              .getProfileBody) ==
                                                  true) {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        simpleAlert(
                                                          context,
                                                          translate(
                                                              'button.success'),
                                                        ));
                                              } else {
                                                showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        simpleAlert(
                                                          context,
                                                          translate(
                                                              'button.failure'),
                                                        ));
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xff4100E3),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                            child: Text(
                                              'Save',
                                              style: getPrimarySemiBoldStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(20),
                              ],
                            );
                          }),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 120),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 154,
                    height: context.appValues.appSizePercent.h21,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 154,
                          height: 155,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageWidget,
                              fit: BoxFit.cover,
                            ),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(32),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                              color: Color(0xff4100E3),
                            ),
                            child: Center(
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
                                        index: 'avatar',
                                        value: save[0]["image"]);
                                  }
                                },
                                isImage: true,
                                widget: SvgPicture.asset(
                                    'assets/img/editprofile.svg'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
