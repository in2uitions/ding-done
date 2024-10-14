import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

import '../../res/constants.dart';
import '../signup/signup_onboarding.dart';
import '../signup/signup_supplier_onboarding.dart';

// import 'key.dart';

// void main() {
//   runApp(
//     const MaterialApp(
//       home: MyApp(),
//       debugShowCheckedModeBanner: false,
//     ),
//   );
// }

class GoogleMapScreen extends StatefulWidget {
  const GoogleMapScreen({Key? key}) : super(key: key);

  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  String address = "null";
  String autocompletePlace = "null";
  Prediction? initialValue;
  Position? _currentPosition;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(builder: (context, signupViewModel, _) {
      return MapLocationPicker(
        apiKey: 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I',
        popOnNextButtonTaped: true,
        currentLatLng: LatLng(
          signupViewModel.getSignUpBody['latitude'] != null &&
                  signupViewModel.getSignUpBody['latitude'] != 'null' &&
                  signupViewModel.getSignUpBody['latitude'] != ''
              ? double.parse(
                  signupViewModel.getSignUpBody['latitude'].toString())
              : _currentPosition!=null?double.parse(_currentPosition!.latitude.toString()):25.2854,
          signupViewModel.getSignUpBody["longitude"] != null &&
                  signupViewModel.getSignUpBody["longitude"] != 'null' &&
                  signupViewModel.getSignUpBody["longitude"] != ''
              ? double.parse(
                  signupViewModel.getSignUpBody['longitude'].toString())
              : _currentPosition!=null?double.parse(_currentPosition!.longitude.toString()):51.5310,
        ),
        // LatLng(
        //   25.2854,
        //  51.5310,
        //
        // ),
        onNext: (GeocodingResult? result) async {
          if (result != null) {
            debugPrint('next button hit ${result.formattedAddress}');
            var splitted = result.formattedAddress?.split(',');
            var first = splitted?.first.toString();
            var last = splitted?.last.toString();
            debugPrint('first $first last $last');
            signupViewModel.setInputValues(
                index: "longitude",
                value: result.geometry?.location.lng.toString());
            signupViewModel.setInputValues(
                index: "latitude",
                value: result.geometry?.location.lat.toString());
            signupViewModel.setInputValues(
                index: "address", value: result.formattedAddress ?? '');

            signupViewModel.setInputValues(index: "city", value: '$last' ?? '');

            // signupViewModel.setInputValues(
            //     index: "state",
            //     value: pickedData.addressData['state'] ?? '');
            signupViewModel.setInputValues(
                index: "street_number", value: '$first' ?? '');
            Navigator.pop(context);
            if (signupViewModel.signUpBody['role'] ==
                Constants.supplierRoleId) {
              debugPrint(';supplier clicked');
              Future.delayed(
                  const Duration(seconds: 0),
                      () =>   Navigator.of(context).push(
                          _createRoute(SignUpSupplierOnBoardingScreen(
                        initialIndex: 3,
                      )
                      )));

              // Navigator.of(context).push(
              //     _createRoute(
              //         SignUpSupplierOnBoardingScreen(
              //   initialIndex: 3,
              // )));
            }
            debugPrint(';customer clicked');

            if (signupViewModel.signUpBody['role'] ==
                Constants.customerRoleId) {
              debugPrint(';customer clicked');

              Future.delayed(
                  const Duration(seconds: 0),
                      () =>    Navigator.of(context).push(_createRoute(SignUpOnBoardingScreen(
                initialIndex: 3,
              ))));

            }
          }
        },
        onSuggestionSelected: (PlacesDetailsResponse? result) {
          if (result != null) {
            var splitted = result.result.formattedAddress?.split(',');
            var first = splitted?.first.toString();
            var last = splitted?.last.toString();
            debugPrint('first $first last $last');
            signupViewModel.setInputValues(
                index: "longitude",
                value: result.result.geometry?.location.lng.toString());
            signupViewModel.setInputValues(
                index: "latitude",
                value: result.result.geometry?.location.lat.toString());
            signupViewModel.setInputValues(
                index: "address", value: result.result.formattedAddress ?? '');

            signupViewModel.setInputValues(index: "city", value: '$last' ?? '');

            // signupViewModel.setInputValues(
            //     index: "state",
            //     value: pickedData.addressData['state'] ?? '');
            signupViewModel.setInputValues(
                index: "street_number", value: '$first' ?? '');
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
    });
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

}
