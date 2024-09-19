import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/map_screen/map_display.dart';
import 'package:dingdone/view/map_screen/map_screen.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild_without_shadow.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

import '../custom/custom_dropdown.dart';

class AddNewAddressWidget extends StatefulWidget {
  const AddNewAddressWidget({super.key});

  @override
  State<AddNewAddressWidget> createState() => _AddNewAddressWidgetState();
}

class _AddNewAddressWidgetState extends State<AddNewAddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer3<JobsViewModel, ProfileViewModel,SignUpViewModel>(
        builder: (context, jobsViewModel, profileViewModel,signupViewModel, _) {
      return Padding(
        padding: EdgeInsets.fromLTRB(
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p50,
          context.appValues.appPadding.p20,
          context.appValues.appPadding.p20,
        ),
        child: Column(
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return MapLocationPicker(
                                apiKey: 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                                popOnNextButtonTaped: true,
                                currentLatLng: LatLng(
                                    jobsViewModel.getjobsBody["latitude"] != null
                                        ? jobsViewModel.getjobsBody["latitude"] is String
                                        ? double.parse(
                                        jobsViewModel.getjobsBody["latitude"])
                                        : jobsViewModel.getjobsBody["latitude"]
                                        : profileViewModel.getProfileBody['current_address'] !=
                                        null &&
                                        profileViewModel.getProfileBody[
                                        'current_address']["latitude"] !=
                                            null
                                        ? profileViewModel
                                        .getProfileBody['current_address']
                                    ["latitude"] is String
                                        ? double.parse(profileViewModel
                                        .getProfileBody['current_address']
                                    ["latitude"])
                                        : profileViewModel
                                        .getProfileBody['current_address']
                                    ["latitude"]: 25.2854,
                                    jobsViewModel.getjobsBody['longitude'] !=
                                        null
                                        ? double.parse(jobsViewModel.getjobsBody['longitude'].toString())
                                        : 51.5310),
                                onNext: (GeocodingResult? result) {
                                  if (result != null) {
                                    debugPrint('next button hit ${result.formattedAddress}');
                                    var splitted =result.formattedAddress?.split(',');
                                    var first=splitted?.first.toString();
                                    var last=splitted?.last.toString();
                                    debugPrint('first $first last $last');
                                    jobsViewModel.setInputValues(
                                        index: "longitude",
                                        value: result.geometry?.location.lng.toString());
                                    jobsViewModel.setInputValues(
                                        index: "latitude",
                                        value: result.geometry?.location.lat.toString());
                                    jobsViewModel.setInputValues(
                                        index: "address",
                                        value: result.formattedAddress ?? '');

                                    jobsViewModel.setInputValues(
                                        index: "city",
                                        value: '$last' ?? '');

                                    jobsViewModel.setInputValues(
                                        index: "street_number",
                                        value: '$first' ?? '');

                                  }
                                },
                                onSuggestionSelected: (PlacesDetailsResponse? result) {
                                  if (result != null) {
                                    setState(() {
                                      // autocompletePlace =
                                      //     result.result.formattedAddress ?? "";
                                    });
                                    var splitted =result.result.formattedAddress?.split(',');
                                    var first=splitted?.first.toString();
                                    var last=splitted?.last.toString();
                                    debugPrint('first $first last $last');
                                    jobsViewModel.setInputValues(
                                        index: "longitude",
                                        value: result.result.geometry?.location.lng.toString());
                                    jobsViewModel.setInputValues(
                                        index: "latitude",
                                        value: result.result.geometry?.location.lat.toString());
                                    jobsViewModel.setInputValues(
                                        index: "address",
                                        value: result.result.formattedAddress ?? '');

                                    jobsViewModel.setInputValues(
                                        index: "city",
                                        value: '$last' ?? '');
                                    jobsViewModel.setInputValues(
                                        index: "street_number",
                                        value: '$first' ?? '');
                                  }
                                },



                              );
                            },
                          ),
                        );
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
                  GestureDetector(
                    onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                            return MapLocationPicker(
                              apiKey: 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                              popOnNextButtonTaped: true,
                              currentLatLng: LatLng(
                                  jobsViewModel.getjobsBody["latitude"] != null
                                      ? jobsViewModel.getjobsBody["latitude"] is String
                                      ? double.parse(
                                      jobsViewModel.getjobsBody["latitude"])
                                      : jobsViewModel.getjobsBody["latitude"]
                                      : profileViewModel.getProfileBody['current_address'] !=
                                      null &&
                                      profileViewModel.getProfileBody[
                                      'current_address']["latitude"] !=
                                          null
                                      ? profileViewModel
                                      .getProfileBody['current_address']
                                  ["latitude"] is String
                                      ? double.parse(profileViewModel
                                      .getProfileBody['current_address']
                                  ["latitude"])
                                      : profileViewModel
                                      .getProfileBody['current_address']
                                  ["latitude"]: 25.2854,
                                  jobsViewModel.getjobsBody['longitude'] !=
                                  null
                                  ? double.parse(jobsViewModel.getjobsBody['longitude'].toString())
                                  : 51.5310),
                              onNext: (GeocodingResult? result) {
                                if (result != null) {
                                  debugPrint('next button hit ${result.formattedAddress}');
                                  var splitted =result.formattedAddress?.split(',');
                                  var first=splitted?.first.toString();
                                  var last=splitted?.last.toString();
                                  debugPrint('first $first last $last');
                                  jobsViewModel.setInputValues(
                                      index: "longitude",
                                      value: result.geometry?.location.lng.toString());
                                  jobsViewModel.setInputValues(
                                      index: "latitude",
                                      value: result.geometry?.location.lat.toString());
                                  jobsViewModel.setInputValues(
                                      index: "address",
                                      value: result.formattedAddress ?? '');
                                  jobsViewModel.setInputValues(
                                      index: "city",
                                      value: '$last' ?? '');

                                  jobsViewModel.setInputValues(
                                      index: "street_number",
                                      value: '$first' ?? '');

                                }
                              },
                              onSuggestionSelected: (PlacesDetailsResponse? result) {
                                if (result != null) {
                                  var splitted =result.result.formattedAddress?.split(',');
                                  var first=splitted?.first.toString();
                                  var last=splitted?.last.toString();
                                  debugPrint('first $first last $last');
                                  jobsViewModel.setInputValues(
                                      index: "longitude",
                                      value: result.result.geometry?.location.lng.toString());
                                  jobsViewModel.setInputValues(
                                      index: "latitude",
                                      value: result.result.geometry?.location.lat.toString());
                                  jobsViewModel.setInputValues(
                                      index: "address",
                                      value: result.result.formattedAddress ?? '');

                                  jobsViewModel.setInputValues(
                                      index: "city",
                                      value: '$last' ?? '');
                                  jobsViewModel.setInputValues(
                                      index: "street_number",
                                      value: '$first' ?? '');
                                }
                              },



                            );
                          },
                        ),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20),
                      child: Container(
                        height: 180,
                        child: FutureBuilder(
                            future: Provider.of<ProfileViewModel>(context,
                                    listen: false)
                                .getData(),
                            builder: (context, AsyncSnapshot data) {
                              if (data.connectionState ==
                                  ConnectionState.done) {
                                return  GoogleMap(
                                  onMapCreated: null,
                                  initialCameraPosition:
                                  CameraPosition(
                                    zoom: 16.0,
                                    target: LatLng(
                                        jobsViewModel.getjobsBody["latitude"] !=
                                            null
                                            ? double.parse(jobsViewModel
                                            .getjobsBody["latitude"]
                                            .toString())
                                            : profileViewModel.getProfileBody[
                                        'current_address'] !=
                                            null &&
                                            profileViewModel.getProfileBody[
                                            'current_address']
                                            ["latitude"] !=
                                                null
                                            ? double.parse(profileViewModel
                                            .getProfileBody['current_address']
                                        ["latitude"]
                                            .toString())
                                            : 25.2854 ,
                                        jobsViewModel
                                            .getjobsBody["longitude"] !=
                                            null
                                            ? double.parse(jobsViewModel
                                            .getjobsBody["longitude"]
                                            .toString())
                                            : profileViewModel.getProfileBody[
                                        'current_address'] !=
                                            null &&
                                            profileViewModel
                                                .getProfileBody['current_address']
                                            ["longitude"] !=
                                                null
                                            ? double.parse(profileViewModel
                                            .getProfileBody['current_address']
                                        ["longitude"]
                                            .toString())
                                            : 51.5310),),

                                  mapType: MapType.normal,
                                  markers: <Marker>{Marker(
                                      markerId: MarkerId('marker'),
                                      infoWindow: InfoWindow(title: 'InfoWindow'))},
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
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.appValues.appSize.s10),
            // Container(
            //   // height: context.appValues.appSizePercent.h12,
            //   width: context.appValues.appSizePercent.w100,
            //   // height: 60,
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0xff000000).withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 5,
            //         offset: const Offset(0, 3), // changes position of shadow
            //       ),
            //     ],
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p5,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           translate('confirmAddress.streetNameHouseNumber'),
            //           style: getPrimaryRegularStyle(
            //             fontSize: 18,
            //             color: const Color(0xffB4B4B4),
            //           ),
            //         ),
            //         CustomTextFieldWithoutShadow(
            //           index: 'street_name',
            //           viewModel: jobsViewModel.setInputValues,
            //           keyboardType: TextInputType.text,
            //           value: jobsViewModel.getjobsBody["street_name"] ?? '',
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: context.appValues.appSize.s15),
            // Container(
            //   // height: context.appValues.appSizePercent.h12,
            //   width: context.appValues.appSizePercent.w100,
            //   // height: 60,
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0xff000000).withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 5,
            //         offset: const Offset(0, 3), // changes position of shadow
            //       ),
            //     ],
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p5,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           translate('confirmAddress.localityPostalCode'),
            //           style: getPrimaryRegularStyle(
            //             fontSize: 18,
            //             color: const Color(0xffB4B4B4),
            //           ),
            //         ),
            //         CustomTextFieldWithoutShadow(
            //           index: 'postal_code',
            //           viewModel: jobsViewModel.setInputValues,
            //           keyboardType: TextInputType.text,
            //           value: jobsViewModel.getjobsBody["postal_code"] ?? '',
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            // SizedBox(height: context.appValues.appSize.s15),
            // Container(
            //   // height: context.appValues.appSizePercent.h12,
            //   width: context.appValues.appSizePercent.w100,
            //   // height: 60,
            //   decoration: BoxDecoration(
            //     boxShadow: [
            //       BoxShadow(
            //         color: const Color(0xff000000).withOpacity(0.1),
            //         spreadRadius: 1,
            //         blurRadius: 5,
            //         offset: const Offset(0, 3), // changes position of shadow
            //       ),
            //     ],
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(15),
            //   ),
            //   child: Padding(
            //     padding: EdgeInsets.fromLTRB(
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p10,
            //       context.appValues.appPadding.p5,
            //     ),
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text(
            //           translate('formHints.country'),
            //           style: getPrimaryRegularStyle(
            //             fontSize: 18,
            //             color: const Color(0xffB4B4B4),
            //           ),
            //         ),
            //         CustomTextFieldWithoutShadow(
            //           index: 'country',
            //           viewModel: jobsViewModel.setInputValues,
            //           keyboardType: TextInputType.text,
            //           value: '',
            //         ),
            //       ],
            //     ),
            //   ),
            // ),






            if (jobsViewModel.jobsAddressError[context
                .resources.strings.formKeys['longitude']] !=
                null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  jobsViewModel.jobsAddressError[context
                      .resources.strings.formKeys['longitude']]!,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (jobsViewModel.jobsAddressError[
            context.resources.strings.formKeys['latitude']] !=
                null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Text(
                  jobsViewModel.jobsAddressError[context
                      .resources.strings.formKeys['latitude']]!,
                  style: TextStyle(color: Colors.red),
                ),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody['street_number'] ??
                      '',
                  index: 'street_number',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.street'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings
                      .formKeys['street_number']!],
                  errorText: jobsViewModel.jobsAddressError[context
                      .resources.strings.formKeys['street_number']!],
                  keyboardType: TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody['building_number'] ??
                      '',
                  index: 'building_number',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.building'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings
                      .formKeys['building_number']!],
                  errorText: jobsViewModel.jobsAddressError[context
                      .resources
                      .strings
                      .formKeys['building_number']!],
                  keyboardType: TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody['floor'] ?? '',
                  index: 'floor',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.floor'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['floor']!],
                  errorText: jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['floor']!],
                  keyboardType: TextInputType.text),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody['apartment_number'] ??
                      '',
                  index: 'apartment_number',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.apartment'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings
                      .formKeys['apartment_number']!],
                  errorText: jobsViewModel.jobsAddressError[context
                      .resources
                      .strings
                      .formKeys['apartment_number']!],
                  keyboardType: TextInputType.text),
            ),
            // FutureBuilder(
            //     future: Provider.of<SignUpViewModel>(context,
            //             listen: false)
            //         .getData(),
            //     builder: (context, AsyncSnapshot data) {
            //
            //         return
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody["city"] ?? '',
                  index: 'city',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.city'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['city']!],
                  errorText: jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['city']!],
                  keyboardType: TextInputType.text),
            ),

            // }),
            // FutureBuilder(
            //     future: Provider.of<SignUpViewModel>(context,
            //             listen: false)
            //         .getData(),
            //     builder: (context, AsyncSnapshot data) {

            // return
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomTextField(
                  value: jobsViewModel.getjobsBody["zone"] ?? '',
                  index: 'zone',
                  viewModel: jobsViewModel.setInputValues,
                  hintText: translate('formHints.zone'),
                  validator: (val) => jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['zone']!],
                  errorText: jobsViewModel.jobsAddressError[
                  context.resources.strings.formKeys['zone']!],
                  keyboardType: TextInputType.text),
            ),
            // FutureBuilder(
            //     future: Provider.of<SignUpViewModel>(context,
            //             listen: false)
            //         .countries(),
            //     builder: (context, AsyncSnapshot data) {
            //       if (data.connectionState == ConnectionState.done) {
            //         return
            Padding(
              padding:
              const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: CustomDropDown(
                value:
                jobsViewModel.getjobsBody["country"] ??
                    '',
                index: 'country',
                viewModel: jobsViewModel.setInputValues,
                hintText: translate('formHints.country'),
                validator: (val) =>
                jobsViewModel.jobsAddressError[context
                    .resources
                    .strings
                    .formKeys['country']!],
                errorText: jobsViewModel.jobsAddressError[
                context.resources.strings
                    .formKeys['country']!],
                keyboardType: TextInputType.text,
                list: signupViewModel.getCountries,
                onChange: (value) {
                  jobsViewModel.setInputValues(
                      index: 'country', value: value);
                },
              ),
            ),
          ],
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
