import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:provider/provider.dart';

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
                  : 23),
              widget.longitude != null
                  ? double.parse(widget.longitude.toString())
                  : (profileViewModel.getProfileBody['current_address'] != null
                  ? profileViewModel.getProfileBody['current_address']['longitude']
                  : 89),
            ),
            selectLocationButtonStyle: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
            ),
            selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
            selectLocationButtonText: translate('signUp.setCurrentLocation'),
            selectLocationButtonLeadingIcon: const Icon(Icons.check),
            initZoom: 11,
            minZoomLevel: 5,
            maxZoomLevel: 16,
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
              await widget.viewModel.setInputValues(
                  index: "city",
                  value: pickedData.addressData['state_district'] ?? '');
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
            },
          );
        },
      ),
    );
  }
}