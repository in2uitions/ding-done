import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class LoacationSupplierProfile extends StatefulWidget {
  const LoacationSupplierProfile({super.key});

  @override
  State<LoacationSupplierProfile> createState() =>
      _LoacationSupplierProfileState();
}

class _LoacationSupplierProfileState extends State<LoacationSupplierProfile> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p0,
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p10,
        ),
        child: Container(
          width: context.appValues.appSizePercent.w100,
          height: context.appValues.appSizePercent.h45,
          // height: 330,
          decoration: BoxDecoration(
            color: context.resources.color.colorWhite,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xff000000).withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p5,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: Color(0xff707070),
                    ),
                    Text(
                      translate('bookService.location'),
                      style: getPrimaryRegularStyle(
                        fontSize: 20,
                        color: const Color(0xff180C38),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                height: 20,
                thickness: 2,
                color: Color(0xffEDF1F7),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p10,
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p10,
                ),
                child: Text(
                  '${profileViewModel.getProfileBody['address'][0]["street_name"]} ${profileViewModel.getProfileBody['address'][0]["building_number"]}, ${profileViewModel.getProfileBody['address'][0]["city"]}, ${profileViewModel.getProfileBody['address'][0]["state"]}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: getPrimaryRegularStyle(
                    fontSize: 16,
                    color: const Color(0xff190C39),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p20),
                child: SizedBox(
                    height: context.appValues.appSizePercent.h25,
                    width: context.appValues.appSizePercent.w90,
                    child: MapDisplay(
                        body: profileViewModel.getProfileBody,
                        longitude: profileViewModel.getProfileBody["address"] !=
                                    null &&
                                profileViewModel.getProfileBody["address"][0]
                                        ["longitude"] !=
                                    null
                            ? profileViewModel.getProfileBody["address"][0]
                                ["longitude"]
                            : 23,
                        latitude:
                            profileViewModel.getProfileBody["address"] != null &&
                                    profileViewModel.getProfileBody["address"][0]
                                            ["latitude"] !=
                                        null
                                ? profileViewModel.getProfileBody["address"][0]
                                    ["latitude"]
                                : 89)),
              ),
              // Align(
              //   alignment: Alignment.center,
              //   child: SvgPicture.asset('assets/img/map-iamge.svg'),
              // ),
            ],
          ),
        ),
      );
    });
  }
}
