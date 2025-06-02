// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/agreement/supplier_agreement.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_field_controller.dart';
import 'package:dingdone/view/widgets/custom/custom_multiple_selection_checkbox.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

class SignUpNewSupplier extends StatefulWidget {
  const SignUpNewSupplier({Key? key}) : super(key: key);

  @override
  State<SignUpNewSupplier> createState() => _SignUpNewSupplierState();
}

class _SignUpNewSupplierState extends State<SignUpNewSupplier> {
  // We use 6 pages:
  // 1. Personal Info & Profile Type (with ID upload for individuals)
  // 2. Contact Information
  // 3. Security Information
  // 4. Address Information (with map picker)
  // 5. Select Your Skills
  // 6. Complete Profile (upload profile picture)
  int _currentStep = 0;
  final int _totalSteps = 6;
  final TextEditingController _phoneController = TextEditingController();
  dynamic profileImage = {};
  dynamic idImage = {};
  String? selectedOption;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentStep = 0;
    selectedOption = null;
    Provider.of<SignUpViewModel>(context, listen: false).countries();
    Provider.of<CategoriesViewModel>(context, listen: false)
        .getCategoriesAndServices();
    _getCurrentPosition();
  }

  // ─────────────────────────────────────────────
  // LOCATION PERMISSION & CURRENT POSITION
  // ─────────────────────────────────────────────
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
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
    if (!hasPermission) return;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      debugPrint('Error obtaining position: $e');
    }
  }

  // ─────────────────────────────────────────────
  // OPEN MAP LOCATION PICKER (Preserves supplier's map functionality)
  // ─────────────────────────────────────────────
  Future<void> _openMapPicker(SignUpViewModel signupViewModel) async {
    const String googleApiKey =
        'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I'; // Replace with your API key.
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MapLocationPicker(
            apiKey: googleApiKey,
            popOnNextButtonTaped: true,
            currentLatLng: LatLng(
              signupViewModel.getSignUpBody["latitude"] != null
                  ? double.parse(
                      signupViewModel.getSignUpBody['latitude'].toString())
                  : _currentPosition != null
                      ? _currentPosition!.latitude
                      : 0,
              signupViewModel.getSignUpBody["longitude"] != null
                  ? double.parse(
                      signupViewModel.getSignUpBody['longitude'].toString())
                  : _currentPosition != null
                      ? _currentPosition!.longitude
                      : 0,
            ),
            onNext: (GeocodingResult? result) {
              if (result != null) {
                var splitted = result.formattedAddress?.split(',');
                var first = splitted?.first.toString();
                var last = splitted?.last.toString();
                signupViewModel.setInputValues(
                    index: "longitude",
                    value: result.geometry.location.lng.toString());
                signupViewModel.setInputValues(
                    index: "latitude",
                    value: result.geometry.location.lat.toString());
                signupViewModel.setInputValues(
                    index: "address", value: result.formattedAddress ?? '');
                signupViewModel.setInputValues(index: "city", value: '$last');
                signupViewModel.setInputValues(
                    index: "street_number", value: '$first');
              }
            },
            onSuggestionSelected: (PlacesDetailsResponse? result) {
              if (result != null) {
                var splitted = result.result.formattedAddress?.split(',');
                var first = splitted?.first.toString();
                var last = splitted?.last.toString();
                signupViewModel.setInputValues(
                    index: "longitude",
                    value: result.result.geometry?.location.lng.toString());
                signupViewModel.setInputValues(
                    index: "latitude",
                    value: result.result.geometry?.location.lat.toString());
                signupViewModel.setInputValues(
                    index: "address",
                    value: result.result.formattedAddress ?? '');
                signupViewModel.setInputValues(index: "city", value: '$last');
                signupViewModel.setInputValues(
                    index: "street_number", value: '$first');
              }
            },
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────
  // STEP PROGRESS INDICATOR
  // ─────────────────────────────────────────────
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_totalSteps, (i) {
        return Expanded(
          child: Container(
            height: 7,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: i <= _currentStep
                  ? Colors.white
                  : Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.5),
            ),
          ),
        );
      }),
    );
  }

  // ─────────────────────────────────────────────
  // Popup error dialog.
  // ─────────────────────────────────────────────
  Widget _buildPopupDialog(BuildContext context, String message) {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Align(
            alignment: Alignment.topRight,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: SvgPicture.asset('assets/img/x.svg'),
            )),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Text(
            message,
            style: getPrimaryRegularStyle(
                color: const Color(0xff3D3D3D), fontSize: 15),
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the view models.
    final signupViewModel = Provider.of<SignUpViewModel>(context);
    final servicesViewModel = Provider.of<ServicesViewModel>(context);

    // Prepare image previews.
    dynamic profileImageWidget = profileImage['image'] != null
        ? (profileImage['type'] == 'file'
            ? FileImage(profileImage['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${profileImage['image']}'))
        : const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png');

    dynamic idImageWidget = idImage['image'] != null
        ? (idImage['type'] == 'file'
            ? FileImage(idImage['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${idImage['image']}'))
        : const AssetImage('assets/img/identification.png');

    // Define pages.
    // Page 1: Personal Information & Profile Type.
    Widget page1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),
        // First Name.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.first_name'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody['first_name'] ?? '',
                index: 'first_name',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.first_name'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['first_name']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['first_name']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        // Last Name.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.last_name'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
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
            ],
          ),
        ),
        // Date of Birth.
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.dob'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomDatePicker(
                value: signupViewModel.signUpBody['dob'] ?? '',
                index: 'dob',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.dob'),
              ),
            ],
          ),
        ),
        const Gap(25),
        // Profile Type.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Text(
            translate('signUp.profileType'),
            style: getPrimarySemiBoldStyle(
                color: const Color(0xff180C38), fontSize: 22),
          ),
        ),
        Row(
          children: [
            Radio<String>(
              value: 'individual',
              groupValue: signupViewModel.signUpBody['selectedOption'] ??
                  selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
                signupViewModel.setInputValues(
                    index: 'selectedOption', value: value);
              },
            ),
            Text(
              translate('signUp.individual'),
              style: getPrimaryRegularStyle(
                  color: const Color(0xff180C38), fontSize: 14),
            ),
            Radio<String>(
              value: 'company',
              groupValue: signupViewModel.signUpBody['selectedOption'] ??
                  selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
                signupViewModel.setInputValues(
                    index: 'selectedOption', value: value);
              },
            ),
            Text(
              translate('signUp.company'),
              style: getPrimaryRegularStyle(
                  color: const Color(0xff180C38), fontSize: 14),
            ),
          ],
        ),
        // If individual, allow ID upload.
        if ((signupViewModel.getSignUpBody['selectedOption'] ??
                selectedOption) ==
            'individual')
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xffededf6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p40,
                    vertical: context.appValues.appPadding.p10,
                  ),
                  child: UploadOneImage(
                    callback: (picked, save) async {
                      if (picked != null) {
                        setState(() {
                          idImage = {
                            'type': 'file',
                            'image': File(picked[0].path),
                          };
                        });
                      }
                      if (save != null) {
                        signupViewModel.setInputValues(
                            index: 'id_image', value: save[0]["image"]);
                      }
                    },
                    isImage: true,
                    widget: Text(
                      translate('signUp.identificationCard'),
                      style: getPrimarySemiBoldStyle(
                          fontSize: 14, color: const Color(0xff4657a6)),
                    ),
                  ),
                ),
                const Gap(10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 5,
                  child: Container(
                    width: 300,
                    height: 150,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: idImageWidget,
                        fit: BoxFit.cover,
                      ),
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                if (signupViewModel.signUpErrors[
                        context.resources.strings.formKeys['id_image']] !=
                    null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
                    child: Text(
                      signupViewModel.signUpErrors[
                          context.resources.strings.formKeys['id_image']]!,
                      style: TextStyle(color: Colors.red[700], fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        if ((signupViewModel.getSignUpBody['selectedOption'] ??
                selectedOption) ==
            'company')
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: CustomTextField(
              value:
              signupViewModel.signUpBody["company"] ??
                  '',
              index: 'company',
              viewModel: signupViewModel.setInputValues,
              hintText: translate('signUp.companyId'),
              // validator: (val) =>
              //     signupViewModel.signUpErrors[context
              //         .resources
              //         .strings
              //         .formKeys['company_id']!],
              // errorText: signupViewModel.signUpErrors[context
              //     .resources.strings.formKeys['company_id']!],
              keyboardType: TextInputType.text,
            ),
          ),
          if (signupViewModel.signUpErrors[
                  context.resources.strings.formKeys['company']] !=
              null)
            Padding(
              padding: const EdgeInsets.fromLTRB(55, 0, 20, 20),
              child: Text(
                signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['company']]!,
                style: TextStyle(color: Colors.red[700], fontSize: 12),
              ),
            ),


      ],
    );

    // Page 2: Contact Information.
    Widget page2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.phone_number'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomPhoneFieldController(
                value: signupViewModel.signUpBody["phone"],
                phone_code: signupViewModel.signUpBody["phone_code"],
                phone_number: signupViewModel.signUpBody["phone_number"],
                index: 'phone',
                viewModel: signupViewModel.setInputValues,
                controller: _phoneController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.email'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody['email'] ?? '',
                index: 'email',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.email'),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['email']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['email']!],
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ],
    );

    Widget buildPasswordRequirements(String password) {
      final requirements = [
        {
          'label': translate('passRequirments.req1'),
          'valid': password.length >= 8,
        },
        {
          'label': translate('passRequirments.req2'),
          'valid': RegExp(r'[A-Z]').hasMatch(password),
        },
        {
          'label': translate('passRequirments.req3'),
          'valid': RegExp(r'[a-z]').hasMatch(password),
        },
        {
          'label': translate('passRequirments.req4'),
          'valid': RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
        },
        {
          'label': translate('passRequirments.req5'),
          'valid': RegExp(r'\d').hasMatch(password),
        },
      ];

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: requirements.map((req) {
          final isValid = req['valid'] as bool;
          final color = isValid
              ? const Color(0xFF4CAF50) // green when valid
              : const Color(0xFF8F9098); // your gray/unmet color
          // final icon = isValid ? Icons.check_circle : Icons.circle;

          return Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Row(
              children: [
                // Icon(icon, size: 12, color: color),
                Text(
                  '●',
                  style: getPrimarySemiBoldStyle(
                    color: color,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  req['label'] as String,
                  style: getPrimaryRegularStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }

    // Page 3: Security Information.
    Widget page3 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.password'),
                style: getPrimarySemiBoldStyle(
                  color: const Color(0xff180C38),
                  fontSize: 12,
                ),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody['password'] ?? '',
                index: 'password',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.password'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['password']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['password']!],
                keyboardType: TextInputType.visiblePassword,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: buildPasswordRequirements(
            signupViewModel.signUpBody['password'] ?? '',
          ),
        ),
        const SizedBox(height: 8.0),
      ],
    );

    // Page 4: Address Information.
    Widget page4 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                translate('formHints.location'),
                style: getPrimarySemiBoldStyle(
                    fontSize: 12, color: context.resources.color.btnColorBlue),
              ),
              InkWell(
                child: Text(
                  translate('signUp.chooseLocation'),
                  style: getPrimaryRegularStyle(
                      fontSize: 12,
                      color: context.resources.color.btnColorBlue),
                ),
                onTap: () => _openMapPicker(signupViewModel),
              ),
            ],
          ),
        ),
        if (signupViewModel.signUpErrors[
                context.resources.strings.formKeys['longitude']] !=
            null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 5),
            child: Text(
              signupViewModel.signUpErrors[
                  context.resources.strings.formKeys['longitude']]!,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        if (signupViewModel
                .signUpErrors[context.resources.strings.formKeys['latitude']] !=
            null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Text(
              signupViewModel.signUpErrors[
                  context.resources.strings.formKeys['latitude']]!,
              style: const TextStyle(color: Colors.red),
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
                  future: Provider.of<SignUpViewModel>(context, listen: false)
                      .getData(),
                  builder: (context, AsyncSnapshot data) {
                    if (data.connectionState == ConnectionState.done) {
                      return GoogleMap(
                        onMapCreated: (_) {},
                        initialCameraPosition: CameraPosition(
                          zoom: 16.0,
                          target: LatLng(
                            data.data["latitude"] != null
                                ? double.parse(data.data['latitude'].toString())
                                : _currentPosition != null
                                    ? _currentPosition!.latitude
                                    : 0,
                            data.data["longitude"] != null
                                ? double.parse(
                                    data.data['longitude'].toString())
                                : _currentPosition != null
                                    ? _currentPosition!.longitude
                                    : 0,
                          ),
                        ),
                        mapType: MapType.normal,
                        markers: {
                          Marker(
                            markerId: const MarkerId('marker'),
                            position: LatLng(
                              data.data["latitude"] != null
                                  ? double.parse(
                                      data.data['latitude'].toString())
                                  : _currentPosition != null
                                      ? _currentPosition!.latitude
                                      : 0,
                              data.data["longitude"] != null
                                  ? double.parse(
                                      data.data['longitude'].toString())
                                  : _currentPosition != null
                                      ? _currentPosition!.longitude
                                      : 0,
                            ),
                            infoWindow:
                                const InfoWindow(title: 'Current Location'),
                          )
                        },
                        myLocationButtonEnabled: false,
                      );
                    }
                    return Container();
                  },
                ),
                InkWell(
                  onTap: () => _openMapPicker(signupViewModel),
                )
              ],
            ),
          ),
        ),
        // Address fields.
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.street_number'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['street_number'] ?? '',
                index: 'street_number',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.street'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['street_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['street_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.building_number'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['building_number'] ?? '',
                index: 'building_number',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.building'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['building_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['building_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.floor'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['floor'] ?? '',
                index: 'floor',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.floor'),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['floor']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['floor']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.apartment_number'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['apartment_number'] ?? '',
                index: 'apartment_number',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.apartment'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['apartment_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['apartment_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.city'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                index: 'city',
                value: signupViewModel.getSignUpBody['city'] ?? '',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.city'),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['city']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['city']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.zone'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['zone'] ?? '',
                index: 'zone',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.zone'),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['zone']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['zone']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translate('formHints.address_label'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 12),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody["address_label"] ?? '',
                index: 'address_label',
                viewModel: signupViewModel.setInputValues,
                hintText: translate('formHints.address_label'),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['address_label']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['address_label']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      ],
    );

    // Page 5: Select Your Skills.
    Widget page5 = SingleChildScrollView(
      child: Column(
        children: [
          const Gap(25),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: SizedBox(
              width: context.appValues.appSizePercent.w100,
              child: Text(
                translate('signUp.selectYourSkills'),
                style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38), fontSize: 22),
              ),
            ),
          ),
          FutureBuilder(
              future: Provider.of<CategoriesViewModel>(context, listen: false)
                  .getCategoriesAndServices(),
              builder: (context, AsyncSnapshot data) {
                if (data.data != null) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 20),
                    child: CustomMultipleSelectionCheckBoxList(
                      // list: data.data,
                      onChange: (selectedValues) {
                        setState(() {}); // Optionally store selectedValues.
                        signupViewModel.setInputValues(
                            index: 'supplier_services', value: selectedValues);
                      },
                      viewModel: signupViewModel.setInputValues,
                      validator: (val) => signupViewModel.signUpErrors[context
                          .resources.strings.formKeys['supplier_services']!],
                      errorText: signupViewModel.signUpErrors[context
                          .resources.strings.formKeys['supplier_services']!],
                      index: 'supplier_services',
                      // servicesViewModel: Provider.of<ServicesViewModel>(context,
                      //     listen: false),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              }),
        ],
      ),
    );

    // Page 6: Complete Profile.
    Widget page6 = Column(
      children: [
        const Gap(25),
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 154,
            height: context.appValues.appSizePercent.h21,
            child: Stack(
              children: [
                Container(
                  width: 154,
                  height: 154,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: profileImageWidget,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(32)),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      color: Color(0xff4100E3),
                    ),
                    child: Center(
                      child: UploadOneImage(
                        callback: (picked, save) async {
                          if (picked != null) {
                            setState(() {
                              profileImage = {
                                'type': 'file',
                                'image': File(picked[0].path),
                              };
                            });
                          }
                          if (save != null) {
                            signupViewModel.setInputValues(
                                index: 'avatar', value: save[0]["image"]);
                          }
                        },
                        isImage: true,
                        widget: SvgPicture.asset('assets/img/editprofile.svg'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );

    final List<Widget> pages = [page1, page2, page3, page4, page5, page6];

    return Scaffold(
      body: Stack(
        children: [
          // Top header with purple background.
          Container(
            height: context.appValues.appSizePercent.h35,
            width: context.appValues.appSizePercent.w100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF20136C),
                  Color(0xFF4100E3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.of(context)
                            .push(_createRoute(const LoginScreen()));
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Gap(40),
                    _buildStepIndicator(),
                    const Gap(40),
                    Text(
                      "Let’s get things done!",
                      style: getPrimarySemiBoldStyle(
                          fontSize: 22, color: Colors.white),
                    ),
                    const Gap(10),
                    Text(
                      "Enter your details to proceed",
                      style: getPrimaryRegularStyle(
                          fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Draggable bottom sheet with fixed button.
          DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.70,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  color: Color(0xffFEFEFE),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: pages[_currentStep],
                      ),
                    ),
                    // Fixed bottom Next/Complete button.
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            backgroundColor: const Color(0xff4100E3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            if (_currentStep < pages.length - 1) {
                              if (signupViewModel.validate(
                                  index: _currentStep)) {
                                setState(() {
                                  _currentStep++;
                                });
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill in all required fields')),
                                );
                              }
                            } else {
                              if (signupViewModel.validate(
                                  index: _currentStep)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sign Up Complete!')),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SupplierAgreement(index: _currentStep),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Please fill in all required fields')),
                                );
                              }
                            }
                          },
                          child: Text(
                            _currentStep == pages.length - 1
                                ? "Complete"
                                : "Next",
                            style: getPrimarySemiBoldStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Route _createRoute(dynamic targetPage) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => targetPage,
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
