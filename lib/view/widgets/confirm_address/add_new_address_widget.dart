import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/map_screen/map_screen.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild_without_shadow.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class AddNewAddressWidget extends StatefulWidget {
  const AddNewAddressWidget({super.key});

  @override
  State<AddNewAddressWidget> createState() => _AddNewAddressWidgetState();
}

class _AddNewAddressWidgetState extends State<AddNewAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<JobsViewModel, ProfileViewModel>(
        builder: (context, jobsViewModel, profileViewModel, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p50,
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p20,
        ),
        child: FutureBuilder(
        future:
        Provider.of<ProfileViewModel>(context, listen: false)
        .getData(),
    builder: (context, AsyncSnapshot data) {
    if (data.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translate('confirmAddress.addNewAddress'),
                  style: getPrimaryBoldStyle(
                    fontSize: 28,
                    color: const Color(0xff180C38),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s10),
                Container(
                  width: context.appValues.appSizePercent.w100,
                  height: context.appValues.appSizePercent.h35,
                  // height: 330,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: context.resources.color.colorWhite,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p0,
                          context.appValues.appPadding.p20,
                          context.appValues.appPadding.p10,
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(_createRoute(MapScreen(
                              viewModel: jobsViewModel,
                              longitude: jobsViewModel.getjobsBody["longitude"] ??
                                  profileViewModel.getProfileBody['current_address']
                                      ["longitude"]!=null? profileViewModel.getProfileBody['current_address']
                              ["longitude"]:23,
                              latitude: jobsViewModel.getjobsBody["latitude"] ??
                                  profileViewModel.getProfileBody['current_address']
                                      ["latitude"]!=null?profileViewModel.getProfileBody['current_address']
                              ["latitude"]:89,
                            )));
                          },
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/img/location.svg'),
                              const Gap(10),
                              Text(
                                translate('confirmAddress.setLocationOnMap'),
                                style: getPrimaryRegularStyle(
                                  fontSize: 20,
                                  color: const Color(0xffC1C1C1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.center,
                      //   child: SvgPicture.asset('assets/img/map-iamge.svg'),
                      // ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(_createRoute(MapScreen(
                            viewModel: jobsViewModel,
                            longitude: jobsViewModel.getjobsBody["longitude"] != null
                                ? jobsViewModel.getjobsBody["longitude"] is String
                                ? double.parse(jobsViewModel.getjobsBody["longitude"])
                                : jobsViewModel.getjobsBody["longitude"]
                                : profileViewModel.getProfileBody['current_address']!=null && profileViewModel.getProfileBody['current_address']["longitude"] != null
                                ? profileViewModel.getProfileBody['current_address']["longitude"] is String
                                ? double.parse(profileViewModel.getProfileBody['current_address']["longitude"])
                                : profileViewModel.getProfileBody['current_address']["longitude"]
                                : 23.0,
                            latitude: jobsViewModel.getjobsBody["latitude"] != null
                                ? jobsViewModel.getjobsBody["latitude"] is String
                                ? double.parse(jobsViewModel.getjobsBody["latitude"])
                                : jobsViewModel.getjobsBody["latitude"]
                                : profileViewModel.getProfileBody['current_address']!=null && profileViewModel.getProfileBody['current_address']["latitude"] != null
                                ? profileViewModel.getProfileBody['current_address']["latitude"] is String
                                ? double.parse(profileViewModel.getProfileBody['current_address']["latitude"])
                                : profileViewModel.getProfileBody['current_address']["latitude"]
                                : 89.0,
                          )));

                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: context.appValues.appPadding.p20),
                          child: Container(
                            height: 180,
                            child: MapDisplay(
                              body: profileViewModel.getProfileBody,
                              longitude: jobsViewModel.getjobsBody["longitude"] != null
                                  ? double.parse(jobsViewModel.getjobsBody["longitude"].toString())
                                  : profileViewModel.getProfileBody['current_address']!=null &&profileViewModel.getProfileBody['current_address']["longitude"] != null
                                  ? double.parse(profileViewModel.getProfileBody['current_address']["longitude"].toString())
                                  : 23.0,
                              latitude: jobsViewModel.getjobsBody["latitude"] != null
                                  ? double.parse(jobsViewModel.getjobsBody["latitude"].toString())
                                  : profileViewModel.getProfileBody['current_address']!=null && profileViewModel.getProfileBody['current_address']["latitude"] != null
                                  ? double.parse(profileViewModel.getProfileBody['current_address']["latitude"].toString())
                                  : 89.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s10),
                Container(
                  // height: context.appValues.appSizePercent.h12,
                  width: context.appValues.appSizePercent.w100,
                  // height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate('confirmAddress.streetNameHouseNumber'),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xffB4B4B4),
                          ),
                        ),
                        CustomTextFieldWithoutShadow(
                          index: 'street_name',
                          viewModel: jobsViewModel.setInputValues,
                          keyboardType: TextInputType.text,
                          value: jobsViewModel.getjobsBody["street_name"] ?? '',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Container(
                  // height: context.appValues.appSizePercent.h12,
                  width: context.appValues.appSizePercent.w100,
                  // height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate('confirmAddress.localityPostalCode'),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xffB4B4B4),
                          ),
                        ),
                        CustomTextFieldWithoutShadow(
                          index: 'postal_code',
                          viewModel: jobsViewModel.setInputValues,
                          keyboardType: TextInputType.text,
                          value: jobsViewModel.getjobsBody["postal_code"] ?? '',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: context.appValues.appSize.s15),
                Container(
                  // height: context.appValues.appSizePercent.h12,
                  width: context.appValues.appSizePercent.w100,
                  // height: 60,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p10,
                      context.appValues.appPadding.p5,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          translate('formHints.country'),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: const Color(0xffB4B4B4),
                          ),
                        ),
                        CustomTextFieldWithoutShadow(
                          index: 'country',
                          viewModel: jobsViewModel.setInputValues,
                          keyboardType: TextInputType.text,
                          value: '',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );}
    else{
      return Container();
    }
          }
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
