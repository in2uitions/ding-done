import 'package:dingdone/view/signup/signup_onboarding.dart';
import 'package:dingdone/view/signup/signup_supplier_onboarding.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

import '../../res/constants.dart';

class MapScreen extends StatefulWidget {
  final dynamic viewModel;
  final double longitude;
  final double latitude;

  MapScreen({
    Key? key,
    required this.viewModel,
    required this.longitude,
    required this.latitude,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F8),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Consumer2<SignUpViewModel, ProfileViewModel>(
        builder: (context, signupViewModel, profileViewModel, _) {
          return FlutterLocationPicker(
            initPosition: LatLong(
              widget.latitude != null
                  ? double.parse(widget.latitude.toString())
                  : (profileViewModel.getProfileBody['current_address'] != null
                  ? profileViewModel.getProfileBody['current_address']['latitude']
                  : 25.3),
              widget.longitude != null
                  ? double.parse(widget.longitude.toString())
                  : (profileViewModel.getProfileBody['current_address'] != null
                  ? profileViewModel.getProfileBody['current_address']['longitude']
                  : 51.52),
            ),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            // selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
            selectLocationButtonText: translate('signUp.setCurrentLocation'),
            selectLocationButtonLeadingIcon: const Icon(Icons.check),
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 18,
            trackMyPosition: true,
            onError: (e) => debugPrint('Error while trying to build map: $e'),
            onPicked: (pickedData) async {
              debugPrint('latitude ${pickedData.latLong.latitude}');
              debugPrint('longitude ${pickedData.latLong.longitude}');
              debugPrint('address ${pickedData.address}');
              debugPrint('country ${pickedData.addressData['country']}');
              debugPrint('address data ${pickedData.addressData}');

              await widget.viewModel.setInputValues(
                  index: "longitude",
                  value: pickedData.latLong.longitude.toString());
              await widget.viewModel.setInputValues(
                  index: "latitude",
                  value: pickedData.latLong.latitude.toString());
              await widget.viewModel.setInputValues(
                  index: "address",
                  value: pickedData.address ?? '');
              // await widget.viewModel.setInputValues(
              //     index: "city",
              //     value: pickedData.addressData['state_district'] ?? '');
              await widget.viewModel.setInputValues(
                  index: "city",
                  value: pickedData.addressData['state'] ?? '');
              await widget.viewModel.setInputValues(
                  index: "state",
                  value: pickedData.addressData['state'] ?? '');
              await widget.viewModel.setInputValues(
                  index: "street_name",
                  value: pickedData.addressData['road'] ?? '');
              await widget.viewModel.setInputValues(
                  index: "postal_code",
                  value: pickedData.addressData['postcode'] ?? '');
              await widget.viewModel.setInputValues(
                  index: "zone",
                  value: pickedData.addressData['zone'] ?? '');


              Navigator.pop(context);
              if(signupViewModel.signUpBody['role']==Constants.supplierRoleId){
                Navigator.of(context).push(_createRoute(SignUpSupplierOnBoardingScreen(initialIndex: 3,)));

              }
              if(signupViewModel.signUpBody['role']==Constants.customerRoleId){
                Navigator.of(context).push(_createRoute(SignUpOnBoardingScreen(initialIndex: 3,)));

              }
            },
          );
        },
      ),
    );
  }
}
Route _createRoute(Widget child) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween = Tween(begin: begin, end: end);
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: curve,
      );

      return SlideTransition(
        position: tween.animate(curvedAnimation),
        child: child,
      );
    },
  );
}
