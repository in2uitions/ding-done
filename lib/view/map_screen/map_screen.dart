import 'package:dingdone/view/signup/signup_onboarding.dart';
import 'package:dingdone/view/signup/signup_supplier_onboarding.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:geocoding/geocoding.dart';

import '../../res/constants.dart';

class MapScreen extends StatefulWidget {
  final dynamic viewModel;
  final double longitude;
  final double latitude;

  const MapScreen({
    super.key,
    required this.viewModel,
    required this.longitude,
    required this.latitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng selectedLocation;

  @override
  void initState() {
    super.initState();
    selectedLocation = _safeLatLng(widget.latitude, widget.longitude);
  }

  LatLng _safeLatLng(double lat, double lon) {
    final safeLat = lat.isFinite ? lat : 51.52;
    final safeLon = lon.isFinite ? lon : 25.3;
    return LatLng(safeLat, safeLon);
  }

  Future<void> _confirmLocation(
      BuildContext context,
      SignUpViewModel signupViewModel,
      ProfileViewModel profileViewModel,
      ) async {
    final placemarks = await placemarkFromCoordinates(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );

    final place = placemarks.isNotEmpty ? placemarks.first : null;

    await widget.viewModel.setInputValues(
      index: "longitude",
      value: selectedLocation.longitude.toString(),
    );
    await widget.viewModel.setInputValues(
      index: "latitude",
      value: selectedLocation.latitude.toString(),
    );
    await widget.viewModel.setInputValues(
      index: "address",
      value: place?.street ?? '',
    );
    await widget.viewModel.setInputValues(
      index: "city",
      value: place?.locality ?? place?.administrativeArea ?? '',
    );
    await widget.viewModel.setInputValues(
      index: "state",
      value: place?.administrativeArea ?? '',
    );
    await widget.viewModel.setInputValues(
      index: "street_name",
      value: place?.street ?? '',
    );
    await widget.viewModel.setInputValues(
      index: "postal_code",
      value: place?.postalCode ?? '',
    );
    await widget.viewModel.setInputValues(
      index: "zone",
      value: place?.subLocality ?? '',
    );

    Navigator.pop(context);

    if (signupViewModel.signUpBody['role'] ==
        Constants.supplierRoleId) {
      Navigator.of(context).push(
        _createRoute(
           SignUpSupplierOnBoardingScreen(initialIndex: 3),
        ),
      );
    }

    if (signupViewModel.signUpBody['role'] ==
        Constants.customerRoleId) {
      Navigator.of(context).push(
        _createRoute(
           SignUpOnBoardingScreen(initialIndex: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF0F3F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer2<SignUpViewModel, ProfileViewModel>(
        builder: (context, signupViewModel, profileViewModel, _) {
          return Stack(
            children: [
              FlutterMap(
                options: MapOptions(
                  initialCenter: selectedLocation,
                  initialZoom: 11,
                  minZoom: 5,
                  maxZoom: 18,
                  onTap: (tapPosition, latLng) {
                    setState(() {
                      selectedLocation = latLng;
                    });
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName:
                    'com.in2uitions.dingdone',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: selectedLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // ✅ Confirm button (same UX as before)
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.check),
                  label: Text(
                    'signUp.setCurrentLocation'.tr(),
                    style: const TextStyle(fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _confirmLocation(
                    context,
                    signupViewModel,
                    profileViewModel,
                  ),
                ),
              ),
            ],
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
