import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/agreement/user_agreement.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/signup/signup_supplier_onboarding.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:onboarding/onboarding.dart';
import 'package:provider/provider.dart';

import '../../res/constants.dart';
import '../widgets/custom/custom_phone_field_controller.dart';

class SignUpOnBoardingScreen extends StatefulWidget {
  var initialIndex;

  SignUpOnBoardingScreen({super.key, required this.initialIndex});

  @override
  State<SignUpOnBoardingScreen> createState() => _SignUpOnBoardingScreenState();
}

class _SignUpOnBoardingScreenState extends State<SignUpOnBoardingScreen> {
  late Material materialButton;
  late int index;
  dynamic image = {};
  Position? _currentPosition;
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = widget.initialIndex;
    _getCurrentPosition();
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    debugPrint('has location permission $hasPermission');
    if (!hasPermission) return;

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      debugPrint('current location $position');
      setState(() => _currentPosition = position);
      // AppPreferences().save(key: currentPositionKey, value: position, isModel: false);
      debugPrint('current location $position');
    }).catchError((e) {
      debugPrint('error getting position $e');
      debugPrint(e);
    });
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      // color: defaultSkipButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel2, _) {
        return Container(
          // width: 127,
          width: context.appValues.appSizePercent.w32,
          // height: 51,
          height: context.appValues.appSizePercent.h5,
          decoration: BoxDecoration(
            color: const Color(0xff384ea2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultSkipButtonBorderRadius,
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();

              if (signupViewModel2.validate(index: index) && setIndex != null) {
                index = index + 1;
                setIndex(index);
              }
            },
            child: Center(
              child: Text(
                translate('button.next'),
                style: getPrimaryBoldStyle(
                  fontSize: 14,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      // color: defaultProceedButtonColor,
      child: Consumer<SignUpViewModel>(builder: (context, signupViewModel1, _) {
        return Container(
          // width: 127,
          width: context.appValues.appSizePercent.w32,
          // height: 51,
          height: context.appValues.appSizePercent.h5,
          decoration: BoxDecoration(
            color: const Color(0xffFFC502),
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            borderRadius: defaultProceedButtonBorderRadius,
            onTap: () {
              if (signupViewModel1.validate(index: index)) {
                Navigator.of(context)
                    .push(_createRoute(UserAgreement(index: index)));
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(
                      context, 'Make Sure to provide all your informtation'),
                );
              }
            },
            child: Center(
              child: Text(
                translate('button.complete'),
                style: getPrimaryBoldStyle(
                  fontSize: 14,
                  color: context.resources.color.colorWhite,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String message) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SvgPicture.asset('assets/img/x.svg'),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: context.appValues.appSizePercent.w50,
                  child: Text(
                    message,
                    style: getPrimaryRegularStyle(
                        color: const Color(0xff3D3D3D), fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(top: context.appValues.appPadding.p20),
          //   child: SvgPicture.asset('assets/img/cleaning.svg'),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic imageWidget = image['image'] != null
        ? image['type'] == 'file'
            ? FileImage(image['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${image['image']}')
        : const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          );

    debugPrint('hello from the other side ');

    return MaterialApp(
      color: const Color(0xffFEFEFE),
      debugShowCheckedModeBanner: false,
      title: translate('login_screen.signUp'),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xffFEFEFE),
          leading: Padding(
            padding: EdgeInsets.fromLTRB(
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p20,
              context.appValues.appPadding.p10,
              context.appValues.appPadding.p20,
            ),
            child: InkWell(
              child: SvgPicture.asset('assets/img/back.svg'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(_createRoute(const LoginScreen()));
              },
            ),
          ),
          title: Text(
            translate('login_screen.swipe'),

            style: getPrimaryBoldStyle(
              fontSize: 13,
              color: const Color(0xff180C38),
            ), // Customize text style
          ),
          centerTitle: true, // Centers the text
        ),
        body: Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
          return Onboarding(
            pages: [
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 10, 20),
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value: signupViewModel.signUpBody['first_name'] ?? '',
                          index: 'first_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.first_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context
                                  .resources.strings.formKeys['first_name']!],
                          errorText: signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['first_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                          value: signupViewModel.signUpBody['last_name'] ?? '',
                          index: 'last_name',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.last_name'),
                          validator: (val) => signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          errorText: signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['last_name']!],
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: CustomDatePicker(
                          value: signupViewModel.signUpBody['dob'] ?? '',
                          index: 'dob',
                          viewModel: signupViewModel.setInputValues,
                          hintText: translate('formHints.dob'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                          padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                          child: SizedBox(
                            width: context.appValues.appSizePercent.w100,
                            child: Text(
                              translate('profile.contactInformation'),
                              style: getPrimaryBoldStyle(
                                color: const Color(0xff180C38),
                                fontSize: 28,
                              ),
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child:
                            // CustomPhoneFeild(
                            //   value:
                            //       signupViewModel.signUpBody['phone'] ?? '',
                            //   index: 'phone_number',
                            //   viewModel: signupViewModel.setInputValues,
                            //   validator: (val) => signupViewModel.signUpErrors[
                            //       context
                            //           .resources.strings.formKeys['phone_number']!],
                            //   errorText: signupViewModel.signUpErrors[context
                            //       .resources.strings.formKeys['phone_number']!],
                            //   hintText: translate('formHints.phone_number'),
                            // ),
                            CustomPhoneFieldController(
                          value: signupViewModel.signUpBody["phone"],
                          phone_code: signupViewModel.signUpBody["phone_code"],
                          phone_number:
                              signupViewModel.signUpBody["phone_number"],
                          index: 'phone',
                          viewModel: signupViewModel.setInputValues,
                          controller: _phoneController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['email'] ?? '',
                            index: 'email',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.email'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['email']!],
                            keyboardType: TextInputType.emailAddress),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.securityInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.signUpBody['password'] ?? '',
                            index: 'password',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.password'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context
                                    .resources.strings.formKeys['password']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['password']!],
                            keyboardType: TextInputType.visiblePassword),
                      ),
                      const SizedBox(height: 8.0),
                      // Adjust the height between the text and bullet points
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0.0,
                        ),
                        child: Text(
                          translate('signUp.requirments'),
                          // '● Minimum 8 characters\n'
                          // '● An uppercase letter\n'
                          // '● A lowercase letter\n'
                          // '● A special character\n'
                          // '● A number',
                          style: const TextStyle(
                            color: Colors.black, // Set your desired color
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.addressInformation'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20,
                            vertical: context.appValues.appPadding.p10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              translate('formHints.location'),
                              style: getPrimaryRegularStyle(
                                fontSize: 15,
                                color: context.resources.color.secondColorBlue,
                              ),
                            ),
                            // InkWell(
                            //   child: Text(
                            //     translate('signUp.chooseLocation'),
                            //     style: getPrimaryRegularStyle(
                            //       fontSize: 15,
                            //       color: context.resources.color.btnColorBlue,
                            //     ),
                            //   ),
                            //   onTap: () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //         builder: (context) {
                            //           return MapLocationPicker(
                            //             apiKey:
                            //                 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                            //             popOnNextButtonTaped: true,
                            //             currentLatLng: LatLng(
                            //                 signupViewModel.getSignUpBody[
                            //                             "latitude"] !=
                            //                         null
                            //                     ? double.parse(signupViewModel
                            //                         .getSignUpBody['latitude']
                            //                         .toString())
                            //                     : double.parse(_currentPosition!
                            //                         .latitude
                            //                         .toString()),
                            //                 signupViewModel.getSignUpBody['longitude'] != null
                            //                     ? double.parse(signupViewModel
                            //                         .getSignUpBody['longitude']
                            //                         .toString())
                            //                     : double.parse(_currentPosition!
                            //                         .longitude
                            //                         .toString())),
                            //             onNext: (GeocodingResult? result) {
                            //               if (result != null) {
                            //                 debugPrint(
                            //                     'next button hit ${result.formattedAddress}');
                            //                 var splitted = result
                            //                     .formattedAddress
                            //                     ?.split(',');
                            //                 var first =
                            //                     splitted?.first.toString();
                            //                 var last =
                            //                     splitted?.last.toString();
                            //                 debugPrint(
                            //                     'first $first last $last');
                            //                 signupViewModel.setInputValues(
                            //                     index: "longitude",
                            //                     value: result
                            //                         .geometry.location.lng
                            //                         .toString());
                            //                 signupViewModel.setInputValues(
                            //                     index: "latitude",
                            //                     value: result
                            //                         .geometry.location.lat
                            //                         .toString());
                            //                 signupViewModel.setInputValues(
                            //                     index: "address",
                            //                     value:
                            //                         result.formattedAddress ??
                            //                             '');

                            //                 signupViewModel.setInputValues(
                            //                     index: "city", value: '$last');

                            //                 // signupViewModel.setInputValues(
                            //                 //     index: "state",
                            //                 //     value: pickedData.addressData['state'] ?? '');
                            //                 signupViewModel.setInputValues(
                            //                     index: "street_number",
                            //                     value: '$first');
                            //                 Navigator.pop(context);
                            //                 if (signupViewModel
                            //                         .signUpBody['role'] ==
                            //                     Constants.supplierRoleId) {
                            //                   Navigator.of(context).push(
                            //                       _createRoute(
                            //                           SignUpSupplierOnBoardingScreen(
                            //                     initialIndex: 3,
                            //                   )));
                            //                 }
                            //                 if (signupViewModel
                            //                         .signUpBody['role'] ==
                            //                     Constants.customerRoleId) {
                            //                   Navigator.of(context).push(
                            //                       _createRoute(
                            //                           SignUpOnBoardingScreen(
                            //                     initialIndex: 3,
                            //                   )));
                            //                 }
                            //               }
                            //             },
                            //             onSuggestionSelected:
                            //                 (PlacesDetailsResponse? result) {
                            //               if (result != null) {
                            //                 setState(() {
                            //                   // autocompletePlace =
                            //                   //     result.result.formattedAddress ?? "";
                            //                 });
                            //                 var splitted = result
                            //                     .result.formattedAddress
                            //                     ?.split(',');
                            //                 var first =
                            //                     splitted?.first.toString();
                            //                 var last =
                            //                     splitted?.last.toString();
                            //                 debugPrint(
                            //                     'first $first last $last');
                            //                 signupViewModel.setInputValues(
                            //                     index: "longitude",
                            //                     value: result.result.geometry
                            //                         ?.location.lng
                            //                         .toString());
                            //                 signupViewModel.setInputValues(
                            //                     index: "latitude",
                            //                     value: result.result.geometry
                            //                         ?.location.lat
                            //                         .toString());
                            //                 signupViewModel.setInputValues(
                            //                     index: "address",
                            //                     value: result.result
                            //                             .formattedAddress ??
                            //                         '');

                            //                 signupViewModel.setInputValues(
                            //                     index: "city", value: '$last');

                            //                 // signupViewModel.setInputValues(
                            //                 //     index: "state",
                            //                 //     value: pickedData.addressData['state'] ?? '');
                            //                 signupViewModel.setInputValues(
                            //                     index: "street_number",
                            //                     value: '$first');
                            //                 // signupViewModel.setInputValues(
                            //                 //     index: "postal_code",
                            //                 //     value: pickedData.addressData['postcode'] ?? '');
                            //                 // signupViewModel.setInputValues(
                            //                 //     index: "zone",
                            //                 //     value: pickedData.addressData['zone'] ?? '');
                            //                 // Navigator.pop(context);
                            //                 // if(signupViewModel.signUpBody['role']==Constants.supplierRoleId){
                            //                 //   Navigator.of(context).push(_createRoute(SignUpSupplierOnBoardingScreen(initialIndex: 3,)));
                            //                 //
                            //                 // }
                            //                 // if(signupViewModel.signUpBody['role']==Constants.customerRoleId){
                            //                 //   Navigator.of(context).push(_createRoute(SignUpOnBoardingScreen(initialIndex: 3,)));
                            //                 //
                            //                 // }
                            //               }
                            //             },
                            //           );
                            //         },
                            //       ),
                            //     );
                            //   },
                            // ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: context.appValues.appPadding.p20),
                        child: SizedBox(
                            height: 300,
                            child: Stack(
                              children: [
                                FutureBuilder(
                                    future: Provider.of<SignUpViewModel>(
                                            context,
                                            listen: false)
                                        .getData(),
                                    builder: (context, AsyncSnapshot data) {
                                      if (data.connectionState ==
                                          ConnectionState.done) {
                                        debugPrint(
                                            'from view model ${signupViewModel.getSignUpBody["longitude"]}');
                                        debugPrint(
                                            'from data ${data.data['longitude']}');
                                        return GestureDetector(
                                          child: GoogleMap(
                                            onMapCreated: null,
                                            initialCameraPosition:
                                                CameraPosition(
                                                    zoom: 16.0,
                                                    target: LatLng(
                                                        data.data["latitude"] !=
                                                                null
                                                            ? double.parse(data
                                                                .data[
                                                                    'latitude']
                                                                .toString())
                                                            : _currentPosition !=
                                                                    null
                                                                ? double.parse(
                                                                    _currentPosition!
                                                                        .latitude
                                                                        .toString())
                                                                : 0,
                                                        data.data['longitude'] !=
                                                                null
                                                            ? double.parse(data
                                                                .data[
                                                                    'longitude']
                                                                .toString())
                                                            : _currentPosition !=
                                                                    null
                                                                ? double.parse(
                                                                    _currentPosition!
                                                                        .longitude
                                                                        .toString())
                                                                : 0)),
                                            mapType: MapType.normal,
                                            markers: <Marker>{
                                              Marker(
                                                  markerId:
                                                      const MarkerId('marker'),
                                                  infoWindow: const InfoWindow(
                                                      title: 'Current'),
                                                  position: LatLng(
                                                      data.data["latitude"] != null
                                                          ? double.parse(data
                                                              .data['latitude']
                                                              .toString())
                                                          : double.parse(
                                                              _currentPosition!.latitude
                                                                  .toString()),
                                                      data.data['longitude'] != null
                                                          ? double.parse(data
                                                              .data['longitude']
                                                              .toString())
                                                          : double.parse(
                                                              _currentPosition!
                                                                  .longitude
                                                                  .toString())))
                                            },
                                            onCameraMove: null,
                                            myLocationButtonEnabled: false,
                                          ),

                                          // child:MapLocationPicker(
                                          //   apiKey: 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                                          //   popOnNextButtonTaped: false,
                                          //   hideMoreOptions:true,
                                          //   hideBackButton: true,
                                          //   hideBottomCard: true,
                                          //   hideLocationButton: true,
                                          //   hideSuggestionsOnKeyboardHide: true,
                                          //   hideMapTypeButton: true,
                                          //
                                          //   onSuggestionSelected:
                                          //       (PlacesDetailsResponse? result) {
                                          //     if (result != null) {
                                          //
                                          //       var splitted = result
                                          //           .result.formattedAddress
                                          //           ?.split(',');
                                          //       var first =
                                          //       splitted?.first.toString();
                                          //       var last =
                                          //       splitted?.last.toString();
                                          //       debugPrint(
                                          //           'first $first last $last');
                                          //       signupViewModel.setInputValues(
                                          //           index: "longitude",
                                          //           value: result.result.geometry
                                          //               ?.location.lng
                                          //               .toString());
                                          //       signupViewModel.setInputValues(
                                          //           index: "latitude",
                                          //           value: result.result.geometry
                                          //               ?.location.lat
                                          //               .toString());
                                          //       signupViewModel.setInputValues(
                                          //           index: "address",
                                          //           value: result.result
                                          //               .formattedAddress ??
                                          //               '');
                                          //
                                          //       signupViewModel.setInputValues(
                                          //           index: "city",
                                          //           value: '$last' ?? '');
                                          //
                                          //       // signupViewModel.setInputValues(
                                          //       //     index: "state",
                                          //       //     value: pickedData.addressData['state'] ?? '');
                                          //       signupViewModel.setInputValues(
                                          //           index: "street_number",
                                          //           value: '$first' ?? '');
                                          //       // signupViewModel.setInputValues(
                                          //       //     index: "postal_code",
                                          //       //     value: pickedData.addressData['postcode'] ?? '');
                                          //       // signupViewModel.setInputValues(
                                          //       //     index: "zone",
                                          //       //     value: pickedData.addressData['zone'] ?? '');
                                          //       // Navigator.pop(context);
                                          //       // if(signupViewModel.signUpBody['role']==Constants.supplierRoleId){
                                          //       //   Navigator.of(context).push(_createRoute(SignUpSupplierOnBoardingScreen(initialIndex: 3,)));
                                          //       //
                                          //       // }
                                          //       // if(signupViewModel.signUpBody['role']==Constants.customerRoleId){
                                          //       //   Navigator.of(context).push(_createRoute(SignUpOnBoardingScreen(initialIndex: 3,)));
                                          //       //
                                          //       // }
                                          //     }
                                          //   },
                                          //   currentLatLng: LatLng(
                                          //       data.data["latitude"] !=
                                          //           null
                                          //           ? double.parse(data.data['latitude'].toString())
                                          //           : 25.2854 , data.data['longitude'] !=
                                          //       null
                                          //       ? double.parse(data.data['longitude'].toString())
                                          //       : 51.5310),
                                          //
                                          //
                                          // )
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return MapLocationPicker(
                                            apiKey:
                                                'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
                                            popOnNextButtonTaped: true,
                                            currentLatLng: LatLng(
                                                signupViewModel.getSignUpBody["latitude"] !=
                                                        null
                                                    ? double.parse(
                                                        signupViewModel.getSignUpBody[
                                                                'latitude']
                                                            .toString())
                                                    : double.parse(
                                                        _currentPosition!
                                                            .latitude
                                                            .toString()),
                                                signupViewModel.getSignUpBody[
                                                            'longitude'] !=
                                                        null
                                                    ? double.parse(signupViewModel
                                                        .getSignUpBody['longitude']
                                                        .toString())
                                                    : double.parse(_currentPosition!.longitude.toString())),
                                            onNext: (GeocodingResult? result) {
                                              if (result != null) {
                                                debugPrint(
                                                    'next button hit ${result.formattedAddress}');
                                                var splitted = result
                                                    .formattedAddress
                                                    ?.split(',');
                                                var first =
                                                    splitted?.first.toString();
                                                var last =
                                                    splitted?.last.toString();
                                                debugPrint(
                                                    'first $first last $last');
                                                signupViewModel.setInputValues(
                                                    index: "longitude",
                                                    value: result
                                                        .geometry.location.lng
                                                        .toString());
                                                signupViewModel.setInputValues(
                                                    index: "latitude",
                                                    value: result
                                                        .geometry.location.lat
                                                        .toString());
                                                signupViewModel.setInputValues(
                                                    index: "address",
                                                    value: result
                                                            .formattedAddress ??
                                                        '');

                                                signupViewModel.setInputValues(
                                                    index: "city",
                                                    value: '$last');

                                                // signupViewModel.setInputValues(
                                                //     index: "state",
                                                //     value: pickedData.addressData['state'] ?? '');
                                                signupViewModel.setInputValues(
                                                    index: "street_number",
                                                    value: '$first');
                                                Navigator.pop(context);
                                                if (signupViewModel
                                                        .signUpBody['role'] ==
                                                    Constants.supplierRoleId) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 0),
                                                      () =>
                                                          Navigator.of(context)
                                                              .push(_createRoute(
                                                                  SignUpSupplierOnBoardingScreen(
                                                            initialIndex: 3,
                                                          ))));
                                                }
                                                if (signupViewModel
                                                        .signUpBody['role'] ==
                                                    Constants.customerRoleId) {
                                                  Future.delayed(
                                                      const Duration(
                                                          seconds: 0),
                                                      () =>
                                                          Navigator.of(context)
                                                              .push(_createRoute(
                                                                  SignUpOnBoardingScreen(
                                                            initialIndex: 3,
                                                          ))));
                                                }
                                              }
                                            },
                                            hideBackButton: false,
                                            backButton: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: InkWell(
                                                child: SvgPicture.asset(
                                                    'assets/img/back.svg'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            onSuggestionSelected:
                                                (PlacesDetailsResponse?
                                                    result) {
                                              if (result != null) {
                                                setState(() {
                                                  // autocompletePlace =
                                                  //     result.result.formattedAddress ?? "";
                                                });
                                                var splitted = result
                                                    .result.formattedAddress
                                                    ?.split(',');
                                                var first =
                                                    splitted?.first.toString();
                                                var last =
                                                    splitted?.last.toString();
                                                debugPrint(
                                                    'first $first last $last');
                                                signupViewModel.setInputValues(
                                                    index: "longitude",
                                                    value: result.result
                                                        .geometry?.location.lng
                                                        .toString());
                                                signupViewModel.setInputValues(
                                                    index: "latitude",
                                                    value: result.result
                                                        .geometry?.location.lat
                                                        .toString());
                                                signupViewModel.setInputValues(
                                                    index: "address",
                                                    value: result.result
                                                            .formattedAddress ??
                                                        '');

                                                signupViewModel.setInputValues(
                                                    index: "city",
                                                    value: '$last');

                                                // signupViewModel.setInputValues(
                                                //     index: "state",
                                                //     value: pickedData.addressData['state'] ?? '');
                                                signupViewModel.setInputValues(
                                                    index: "street_number",
                                                    value: '$first');
                                                // signupViewModel.setInputValues(
                                                //     index: "postal_code",
                                                //     value: pickedData.addressData['postcode'] ?? '');
                                                // signupViewModel.setInputValues(
                                                //     index: "zone",
                                                //     value: pickedData.addressData['zone'] ?? '');
                                                // Navigator.pop(context);
                                                // if(signupViewModel.signUpBody['role']==Constants.supplierRoleId){
                                                //   Navigator.of(context).push(_createRoute(SignUpSupplierOnBoardingScreen(initialIndex: 3,)));
                                                //
                                                // }
                                                // if(signupViewModel.signUpBody['role']==Constants.customerRoleId){
                                                //   Navigator.of(context).push(_createRoute(SignUpOnBoardingScreen(initialIndex: 3,)));
                                                //
                                                // }
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ],
                            )),
                      ),
                      if (signupViewModel.signUpErrors[context
                              .resources.strings.formKeys['longitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['longitude']]!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      if (signupViewModel.signUpErrors[
                              context.resources.strings.formKeys['latitude']] !=
                          null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                          child: Text(
                            signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['latitude']]!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['street_number'] ??
                                '',
                            index: 'street_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.street'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['street_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['street_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['building_number'] ??
                                '',
                            index: 'building_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.building'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['building_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['building_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.getSignUpBody['floor'] ?? '',
                            index: 'floor',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.floor'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['floor']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel
                                    .getSignUpBody['apartment_number'] ??
                                '',
                            index: 'apartment_number',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.apartment'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['apartment_number']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources
                                .strings
                                .formKeys['apartment_number']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            index: 'city',
                            value: signupViewModel.getSignUpBody['city'] ?? '',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.city'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['city']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value: signupViewModel.getSignUpBody['zone'] ?? '',
                            index: 'zone',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.zone'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            errorText: signupViewModel.signUpErrors[
                                context.resources.strings.formKeys['zone']!],
                            keyboardType: TextInputType.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: CustomTextField(
                            value:
                                signupViewModel.signUpBody["address_label"] ??
                                    '',
                            index: 'address_label',
                            viewModel: signupViewModel.setInputValues,
                            hintText: translate('formHints.address_label'),
                            validator: (val) => signupViewModel.signUpErrors[
                                context.resources.strings
                                    .formKeys['address_label']!],
                            errorText: signupViewModel.signUpErrors[context
                                .resources.strings.formKeys['address_label']!],
                            keyboardType: TextInputType.text),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      //   child: CustomDropDown(
                      //     value: signupViewModel.signUpBody["country"] ?? '',
                      //     index: 'country',
                      //     viewModel: signupViewModel.setInputValues,
                      //     hintText: translate('formHints.country'),
                      //     validator: (val) => signupViewModel.signUpErrors[
                      //         context.resources.strings.formKeys['country']!],
                      //     errorText: signupViewModel.signUpErrors[
                      //         context.resources.strings.formKeys['country']!],
                      //     keyboardType: TextInputType.text,
                      //     list: signupViewModel.getCountries,
                      //     onChange: (value) {
                      //       debugPrint('value of country $value');
                      //       signupViewModel.setInputValues(
                      //           index: 'country', value: value);
                      //     },
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
              PageModel(
                widget: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xffFEFEFE),
                    border: Border.all(
                      width: 0.0,
                      color: const Color(0xffFEFEFE),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
                        child: SizedBox(
                          width: context.appValues.appSizePercent.w100,
                          child: Text(
                            translate('signUp.completeProfile'),
                            style: getPrimaryBoldStyle(
                              color: const Color(0xff180C38),
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),

                      // AddMedia(),

                      CircleAvatar(
                        backgroundImage: imageWidget,
                        radius: 70,
                        backgroundColor: Colors.transparent,
                      ),
                      SizedBox(height: context.appValues.appSize.s20),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xff9E9AB7),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: context.appValues.appPadding.p20,
                          vertical: context.appValues.appPadding.p10,
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
                              debugPrint('save 0 ${save[0]}');
                              signupViewModel.setInputValues(
                                  index: 'avatar', value: save[0]["image"]);
                            }
                          },
                          isImage: true,
                          widget: Text(
                            translate('signUp.uploadProfilePhoto'),
                            style: getPrimaryBoldStyle(
                              fontSize: 21,
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
            onPageChange: (int pageIndex) {
              index = pageIndex;
            },
            startPageIndex: widget.initialIndex,
            footerBuilder: (context, dragDistance, pagesLength, setIndex) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0xffFEFEFE),
                  border: Border.all(
                    width: 0.0,
                    color: const Color(0xffFEFEFE),
                  ),
                ),
                child: ColoredBox(
                  color: const Color(0xffFEFEFE),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        index == pagesLength - 1
                            ? _signupButton
                            : _skipButton(setIndex: setIndex)
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
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

Widget _buildPopupDialog(BuildContext context, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SvgPicture.asset('assets/img/x.svg'),
              ],
            ),
          ),
        ),
        Text(
          message,
          style: getPrimaryRegularStyle(
              color: const Color(0xff3D3D3D), fontSize: 15),
        ),
        // Padding(
        //   padding: EdgeInsets.only(top: context.appValues.appPadding.p20),
        //   child: SvgPicture.asset('assets/img/cleaning.svg'),
        // ),
      ],
    ),
  );
}
