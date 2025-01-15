import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../confirm_address/confirm_address.dart';

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
                        fontSize: 16,
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

              InkWell(
                onTap: () {
                  Navigator.of(context).push(_createRoute(ConfirmAddress()));
                },
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                      ),
                      child: Text(
                        profileViewModel.getProfileBody['current_address'] !=
                                null
                            ? '${profileViewModel.getProfileBody['current_address']["street_number"]} ${profileViewModel.getProfileBody['current_address']["building_number"]}, ${profileViewModel.getProfileBody['current_address']["city"]}, ${profileViewModel.getProfileBody['current_address']["zone"]}'
                            : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getPrimaryRegularStyle(
                          fontSize: 14,
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
                        child: Stack(
                          children: [
                            FutureBuilder(
                                future: Provider.of<ProfileViewModel>(context,
                                        listen: false)
                                    .getData(),
                                builder: (context, AsyncSnapshot data) {
                                  if (data.connectionState ==
                                      ConnectionState.done) {
                                    return GoogleMap(
                                      onMapCreated: null,
                                      initialCameraPosition: CameraPosition(
                                        zoom: 16.0,
                                        target: LatLng(
                                            profileViewModel.getProfileBody['current_address'] != null &&
                                                    profileViewModel.getProfileBody['current_address']["latitude"] !=
                                                        null
                                                ? double.parse(profileViewModel
                                                    .getProfileBody['current_address']
                                                        ["latitude"]
                                                    .toString())
                                                : 25.2854,
                                            profileViewModel.getProfileBody['current_address'] != null &&
                                                    profileViewModel.getProfileBody['current_address']
                                                            ["longitude"] !=
                                                        null
                                                ? double.parse(profileViewModel
                                                    .getProfileBody['current_address']["longitude"]
                                                    .toString())
                                                : 51.5310),
                                      ),

                                      mapType: MapType.normal,
                                      markers: <Marker>{
                                        Marker(
                                          markerId: MarkerId('marker'),
                                          infoWindow:
                                              InfoWindow(title: 'Current'),
                                          position: LatLng(
                                              profileViewModel.getProfileBody['current_address'] != null &&
                                                      profileViewModel.getProfileBody['current_address']
                                                              ["latitude"] !=
                                                          null
                                                  ? double.parse(profileViewModel
                                                      .getProfileBody['current_address']
                                                          ["latitude"]
                                                      .toString())
                                                  : 25.2854,
                                              profileViewModel.getProfileBody[
                                                              'current_address'] !=
                                                          null &&
                                                      profileViewModel.getProfileBody['current_address']
                                                              ["longitude"] !=
                                                          null
                                                  ? double.parse(profileViewModel.getProfileBody['current_address']["longitude"].toString())
                                                  : 51.5310),
                                        )
                                      },
                                      onCameraMove: null,
                                      myLocationButtonEnabled: false,
                                      // options: GoogleMapOptions(
                                      //     myLocationEnabled:true
                                      //there is a lot more options you can add here
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .push(_createRoute(ConfirmAddress()));
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
