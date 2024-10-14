// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_address/confirm_address.dart';
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
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: context.appValues.appSizePercent.h35,
                child: Stack(
                  children: [
                    Container(
                      width: context.appValues.appSizePercent.w100,
                      height: context.appValues.appSizePercent.h25,
                      decoration: const BoxDecoration(
                        color: Color(0xff6F6BE8),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          SafeArea(
                            child: Padding(
                              padding: EdgeInsets.all(
                                  context.appValues.appPadding.p20),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Stack(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      child: Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          context.appValues.appPadding.p3,
                                          context.appValues.appPadding.p3,
                                          context.appValues.appPadding.p0,
                                          context.appValues.appPadding.p3,
                                        ),
                                        child: SvgPicture.asset(
                                          'assets/img/back-new.svg',
                                          // colorFilter: const ColorFilter.mode(
                                          //     Colors.white, BlendMode.srcIn),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                    Center(
                                      child: Text(
                                        translate('profile.yourProfile'),
                                        style: getPrimaryBoldStyle(
                                          color: context
                                              .resources.color.colorWhite,
                                          fontSize: 22,
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
                    //
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        children: [
                          Container(
                            width: 154,
                            height: 155,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageWidget,
                                fit: BoxFit.cover,
                              ),
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(50),
                                bottomRight: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 154,
                              height: 45,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(50),
                                  bottomRight: Radius.circular(50),
                                  // topRight: Radius.circular(50),
                                ),
                                color: const Color(0xff1F1F39).withOpacity(0.5),
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
                                  widget:
                                      SvgPicture.asset('assets/img/camera.svg'),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: SizedBox(
                        width: context.appValues.appSizePercent.w100,
                        child: Text(
                          translate('profile.yourName'),
                          style: getPrimaryBoldStyle(
                            color: const Color(0xff180C38),
                            fontSize: 20,
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
                        prefixIcon: 'assets/img/account-feild.svg',
                        isPrfixShown: true,
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
                        prefixIcon: 'assets/img/account-feild.svg',
                        isPrfixShown: true,
                      ),
                    ),
                    const Gap(10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                      child: SizedBox(
                        width: context.appValues.appSizePercent.w100,
                        child: Text(
                          translate('formHints.phone_number'),
                          style: getPrimaryBoldStyle(
                            color: const Color(0xff180C38),
                            fontSize: 20,
                          ),
                        ),
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
                    // const Gap(10),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: context.appValues.appSizePercent.w100,
                        child: Text(
                          translate('formHints.email'),
                          style: getPrimaryBoldStyle(
                            color: const Color(0xff180C38),
                            fontSize: 20,
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
                        prefixIcon: 'assets/img/email-feild.svg',
                        isPrfixShown: true,
                      ),
                    ),
                    const Gap(20),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: context.appValues.appSizePercent.w100,
                        child: Text(
                          translate('profile.addresses'),
                          style: getPrimaryBoldStyle(
                            color: const Color(0xff180C38),
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const Gap(10),

                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p0),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                _createRoute(
                                  // MapScreen(viewModel: jobsViewModel)));
                                  ConfirmAddress(),
                                ),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 5),
                                  child: SvgPicture.asset(
                                    'assets/img/locationbookservice.svg',
                                  ),
                                ),
                                const Gap(10),
                                Expanded(
                                  child: Text(
                                    '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']['apartment_number']}, ${profileViewModel.getProfileBody['current_address']["floor"]}',
                                    style: getPrimaryRegularStyle(
                                      fontSize: 18,
                                      color: const Color(0xff190C39),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Color(0xffEAEAFF),
                            thickness: 2,
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: const Color(0xff000000).withOpacity(0.1),
                    //         spreadRadius: 1,
                    //         blurRadius: 5,
                    //         offset: const Offset(
                    //             0, 3), // changes position of shadow
                    //       ),
                    //     ],
                    //     color: context.resources.color.colorWhite,
                    //     borderRadius: BorderRadius.circular(15.0),
                    //   ),
                    //   child: Column(
                    //     children: [
                    //       Padding(
                    //         padding: EdgeInsets.symmetric(
                    //             horizontal: context.appValues.appPadding.p20,
                    //             vertical: context.appValues.appPadding.p10),
                    //         child: Row(
                    //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //           children: [
                    //             Row(
                    //               children: [
                    //                 SvgPicture.asset('assets/img/location.svg'),
                    //                 Padding(
                    //                   padding:
                    //                       const EdgeInsets.fromLTRB(5, 0, 0, 0),
                    //                   child: Text(
                    //                     translate('profile.addresses'),
                    //                     style: getPrimaryBoldStyle(
                    //                       fontSize: 20,
                    //                       color: const Color(0xff180C38),
                    //                     ),
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //             Container(
                    //               decoration: BoxDecoration(
                    //                 border: Border.all(
                    //                   color: const Color(0xff58537A),
                    //                   width: 2,
                    //                 ),
                    //                 borderRadius: BorderRadius.circular(20),
                    //               ),
                    //               child: Padding(
                    //                 padding: EdgeInsets.symmetric(
                    //                   vertical: context.appValues.appPadding.p5,
                    //                   horizontal:
                    //                       context.appValues.appPadding.p20,
                    //                 ),
                    //                 child: InkWell(
                    //                   child: Text(
                    //                     translate('profile.changeLocation'),
                    //                     style: getPrimaryRegularStyle(
                    //                       fontSize: 13,
                    //                       color: const Color(0xff180C38),
                    //                     ),
                    //                   ),
                    //                   onTap: () {
                    //                     Navigator.of(context).push(_createRoute(
                    //                       // MapScreen(viewModel: jobsViewModel)));
                    //                       ConfirmAddress(),
                    //                     ));
                    //                   },
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //       Padding(
                    //         padding: EdgeInsets.fromLTRB(
                    //             0, 0, 0, context.appValues.appPadding.p0),
                    //         child: SizedBox(
                    //             height: 180,
                    //             child: GoogleMap(
                    //               onMapCreated: null,
                    //               initialCameraPosition: CameraPosition(
                    //                 zoom: 16.0,
                    //                 target: LatLng(
                    //                     profileViewModel.getProfileBody[
                    //                         'current_address']["latitude"],
                    //                     profileViewModel.getProfileBody[
                    //                         'current_address']["longitude"]),
                    //               ),

                    //               mapType: MapType.normal,
                    //               markers: <Marker>{
                    //                 Marker(
                    //                     markerId: MarkerId('marker'),
                    //                     infoWindow:
                    //                         InfoWindow(title: 'InfoWindow'))
                    //               },
                    //               onCameraMove: null,
                    //               myLocationButtonEnabled: false,
                    //               // options: GoogleMapOptions(
                    //               //     myLocationEnabled:true
                    //               //there is a lot more options you can add here
                    //             )
                    //             // ),
                    //             // MapLocationPicker(
                    //             //   apiKey:
                    //             //       'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                    //             //   popOnNextButtonTaped: false,
                    //             //   hideMoreOptions:true,
                    //             //   hideBackButton: true,
                    //             //   hideBottomCard: true,
                    //             //   hideLocationButton: true,
                    //             //   hideSuggestionsOnKeyboardHide: true,
                    //             //   hideMapTypeButton: true,
                    //             //   // topCardColor: Colors.transparent,
                    //             //   topCardShape: RoundedRectangleBorder(), // This hides the top card shape
                    //             //
                    //             //   top: false,
                    //             //   currentLatLng: LatLng(
                    //             //       profileViewModel
                    //             //               .getProfileBody['current_address']
                    //             //           ["latitude"],
                    //             //       profileViewModel
                    //             //               .getProfileBody['current_address']
                    //             //           ["longitude"]),
                    //             // ),
                    //             // MapDisplay(
                    //             //   body: profileViewModel.getProfileBody,
                    //             //   longitude: profileViewModel
                    //             //           .getProfileBody['current_address']
                    //             //       ["longitude"],
                    //             //   latitude: profileViewModel
                    //             //           .getProfileBody['current_address']
                    //             //       ["latitude"],
                    //             // ),
                    //             ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                            if (await profileViewModel.patchUserData(
                                    profileViewModel.getProfileBody) ==
                                true) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      simpleAlert(
                                        context,
                                        translate('button.success'),
                                      ));
                            } else {
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
                            backgroundColor: const Color(0xff4100E3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
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
