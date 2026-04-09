import 'dart:async';
import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/agreement/user_agreement.dart';
import 'package:dingdone/view/widgets/custom/custom_date_picker.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view/widgets/custom/custom_phone_field_controller.dart';
import 'package:dingdone/view/widgets/image_component/upload_one_image.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:provider/provider.dart';

class SignUpNew extends StatefulWidget {
  const SignUpNew({Key? key}) : super(key: key);

  @override
  State<SignUpNew> createState() => _SignUpNewState();
}

class _SignUpNewState extends State<SignUpNew> {
  // We use 5 pages: Personal, Contact, Security, Address, Complete Profile.
  int _currentStep = 0;
  final int _totalSteps = 5;
  final TextEditingController _phoneController = TextEditingController();
  dynamic image = {};
  Position? _currentPosition;
  final FocusNode _phoneOtpFocusNode = FocusNode();
  final FocusNode _emailOtpFocusNode = FocusNode();

  final TextEditingController _phoneOtpController = TextEditingController();
  final TextEditingController _emailOtpController = TextEditingController();

  bool _phoneOtpSent = false;
  bool _emailOtpSent = false;

  bool _phoneOtpVerified = false;
  bool _emailOtpVerified = false;

  bool _sendingPhoneOtp = false;
  bool _sendingEmailOtp = false;

  bool _resendingPhoneOtp = false;
  bool _resendingEmailOtp = false;

  Timer? _phoneResendTimer;
  Timer? _emailResendTimer;

  int _phoneResendSecondsRemaining = 0;
  int _emailResendSecondsRemaining = 0;

  bool get _canResendPhoneOtp => _phoneResendSecondsRemaining == 0;
  bool get _canResendEmailOtp => _emailResendSecondsRemaining == 0;
  bool get _canProceedFromContactStep => _phoneOtpVerified && _emailOtpVerified;
  @override
  void initState() {

    super.initState();
    _getCurrentPosition();
  }

  // ─────────────────────────────────────────────
  // LOCATION PERMISSION & CURRENT POSITION
  // ─────────────────────────────────────────────
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content:
            Text('Location services are disabled. Please enable the services'),
      ));
      return false;
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are denied'),
        ));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Location permissions are permanently denied, we cannot request permissions.'),
      ));
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
  // OPEN MAP LOCATION PICKER (AS IN OLD UI)
  // ─────────────────────────────────────────────
  Future<void> _openMapPicker(SignUpViewModel signupViewModel) async {
    const String googleApiKey = 'AIzaSyC0LlzC9LKEbyDDgM2pLnBZe-39Ovu2Z7I';
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
  // STEP PROGRESS INDICATOR (Same as Old UI header progress bar)
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


  Future<void> _sendPhoneOtp(SignUpViewModel vm) async {
    if (!_hasValidPhone(vm)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number')),
      );
      return;
    }

    setState(() => _sendingPhoneOtp = true);

    final success = await vm.requestOtp();

    if (!mounted) return;

    setState(() => _sendingPhoneOtp = false);

    if (success == true) {
      setState(() {
        _phoneOtpSent = true;
        _phoneOtpVerified = false;
      });

      _phoneOtpController.clear();
      _startPhoneResendCountdown();
      FocusScope.of(context).requestFocus(_phoneOtpFocusNode);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phone OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage.isNotEmpty ? vm.errorMessage : 'Failed to send phone OTP',
          ),
        ),
      );
    }
  }

  Future<void> _sendEmailOtp(SignUpViewModel vm) async {
    if (!_hasValidEmail(vm)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
      return;
    }

    setState(() => _sendingEmailOtp = true);

    final success = await vm.requestEmailOtp();

    if (!mounted) return;

    setState(() => _sendingEmailOtp = false);

    if (success == true) {
      setState(() {
        _emailOtpSent = true;
        _emailOtpVerified = false;
      });

      _emailOtpController.clear();
      _startEmailResendCountdown();
      FocusScope.of(context).requestFocus(_emailOtpFocusNode);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            vm.errorMessage.isNotEmpty ? vm.errorMessage : 'Failed to send email OTP',
          ),
        ),
      );
    }
  }

  Future<void> _verifyPhoneOtp(SignUpViewModel vm) async {
    if (_phoneOtpController.text.trim().length != 4) return;

    final success = vm.getOtp.toString() == _phoneOtpController.text.trim();

    if (!mounted) return;

    setState(() {
      _phoneOtpVerified = success;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _phoneOtpVerified ? 'Phone number verified' : 'Invalid phone OTP',
        ),
      ),
    );
  }

  Future<void> _verifyEmailOtp(SignUpViewModel vm) async {
    if (_emailOtpController.text.trim().length != 4) return;

    final success = vm.getEmailOtp.toString() == _emailOtpController.text.trim();

    if (!mounted) return;

    setState(() {
      _emailOtpVerified = success;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _emailOtpVerified ? 'Email verified' : 'Invalid email OTP',
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneResendTimer?.cancel();
    _emailResendTimer?.cancel();

    _phoneController.dispose();
    _phoneOtpController.dispose();
    _emailOtpController.dispose();

    _phoneOtpFocusNode.dispose();
    _emailOtpFocusNode.dispose();

    super.dispose();
  }
  void _startPhoneResendCountdown() {
    _phoneResendTimer?.cancel();
    setState(() => _phoneResendSecondsRemaining = 60);

    _phoneResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_phoneResendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() => _phoneResendSecondsRemaining = 0);
      } else {
        setState(() => _phoneResendSecondsRemaining--);
      }
    });
  }

  void _startEmailResendCountdown() {
    _emailResendTimer?.cancel();
    setState(() => _emailResendSecondsRemaining = 60);

    _emailResendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_emailResendSecondsRemaining <= 1) {
        timer.cancel();
        setState(() => _emailResendSecondsRemaining = 0);
      } else {
        setState(() => _emailResendSecondsRemaining--);
      }
    });
  }

  String _formatCountdown(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  bool _hasValidPhone(SignUpViewModel vm) {
    final phone = vm.signUpBody['phone_number'];
    return phone != null && phone.toString().trim().isNotEmpty;
  }

  bool _hasValidEmail(SignUpViewModel vm) {
    final email = vm.signUpBody['email']?.toString().trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email);
  }
  @override
  Widget build(BuildContext context) {
    // Get view model & image preview as in old UI
    final signupViewModel = Provider.of<SignUpViewModel>(context);
    dynamic imageWidget = image['image'] != null
        ? (image['type'] == 'file'
            ? FileImage(image['image'])
            : NetworkImage(
                '${context.resources.image.networkImagePath}${image['image']}'))
        : const NetworkImage(
            'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          );
    final hasLocation =
        signupViewModel.getSignUpBody['latitude'] != null &&
            signupViewModel.getSignUpBody['latitude'].toString().isNotEmpty &&
            signupViewModel.getSignUpBody['longitude'] != null &&
            signupViewModel.getSignUpBody['longitude'].toString().isNotEmpty;
    // ─────────────────────────────────────────────
    // PAGE 1: PERSONAL INFORMATION (Same as Onboarding)
    // ─────────────────────────────────────────────
    Widget page1 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for page 1
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 30, 10, 20),
        //   child: SizedBox(
        //     width: context.appValues.appSizePercent.w100,
        //     child: Text(
        //       translate('profile.personalInformation'),
        //       style: getPrimaryBoldStyle(
        //         color: const Color(0xff180C38),
        //         fontSize: 28,
        //       ),
        //     ),
        //   ),
        // ),
        // First Name
        const Gap(25),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'formHints.first_name'.tr(),
                style: getPrimarySemiBoldStyle(
                  color: const Color(0xff180C38),
                  fontSize: 12,
                ),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody['first_name'] ?? '',
                index: 'first_name',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.first_name'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['first_name']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['first_name']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        // Last Name
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'formHints.last_name'.tr(),
                style: getPrimarySemiBoldStyle(
                  color: const Color(0xff180C38),
                  fontSize: 12,
                ),
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody['last_name'] ?? '',
                index: 'last_name',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.last_name'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['last_name']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['last_name']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
        // Date of Birth
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'formHints.dob'.tr(),
                style: getPrimarySemiBoldStyle(
                  color: const Color(0xff180C38),
                  fontSize: 12,
                ),
              ),
              const Gap(10),
              CustomDatePicker(
                value: signupViewModel.signUpBody['dob'] ?? '',
                index: 'dob',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.dob'.tr(),
              ),
            ],
          ),
        ),
      ],
    );

    // ─────────────────────────────────────────────
    // PAGE 2: CONTACT INFORMATION (Same as Onboarding)
    // ─────────────────────────────────────────────
    Widget page2 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(25),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Contact Verification',
            style: getPrimarySemiBoldStyle(
              color: const Color(0xff180C38),
              fontSize: 22,
            ),
          ),
        ),
        const Gap(8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Verify both your phone number and email address before continuing.',
            style: getPrimaryRegularStyle(
              color: const Color(0xFF8F9098),
              fontSize: 13,
            ),
          ),
        ),
        const Gap(20),

        _buildVerificationCard(
          title: 'Phone Number',
          icon: Icons.phone_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomPhoneFieldController(
                value: signupViewModel.signUpBody["phone"],
                phone_code: signupViewModel.signUpBody["phone_code"],
                phone_number: signupViewModel.signUpBody["phone_number"],
                index: 'phone',
                viewModel: signupViewModel.setInputValues,
                controller: _phoneController,
                keyboardType: TextInputType.number,
              ),
              const Gap(14),
              _buildActionButton(
                text: _phoneOtpVerified ? 'Verified' : 'Send Phone OTP',
                loading: _sendingPhoneOtp,
                enabled: !_phoneOtpVerified,
                onTap: () => _sendPhoneOtp(signupViewModel),
              ),
              if (_phoneOtpSent && !_phoneOtpVerified) ...[
                const Gap(16),
                _buildOtpBoxes(
                  controller: _phoneOtpController,
                  focusNode: _phoneOtpFocusNode,
                  onCompleted: (_) => _verifyPhoneOtp(signupViewModel),
                ),
                const Gap(12),
                _buildOtpFooter(
                  secondsRemaining: _phoneResendSecondsRemaining,
                  canResend: _canResendPhoneOtp,
                  resending: _resendingPhoneOtp,
                  onResend: () async {
                    setState(() => _resendingPhoneOtp = true);
                    await _sendPhoneOtp(signupViewModel);
                    if (mounted) setState(() => _resendingPhoneOtp = false);
                  },
                ),
              ],
            ],
          ),
        ),

        const Gap(16),

        _buildVerificationCard(
          title: 'Email Address',
          icon: Icons.email_outlined,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                value: signupViewModel.signUpBody['email'] ?? '',
                index: 'email',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.email'.tr(),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['email']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['email']!],
                keyboardType: TextInputType.emailAddress,
              ),
              const Gap(14),
              _buildActionButton(
                text: _emailOtpVerified ? 'Verified' : 'Send Email OTP',
                loading: _sendingEmailOtp,
                enabled: !_emailOtpVerified,
                onTap: () => _sendEmailOtp(signupViewModel),
              ),
              if (_emailOtpSent && !_emailOtpVerified) ...[
                const Gap(16),
                _buildOtpBoxes(
                  controller: _emailOtpController,
                  focusNode: _emailOtpFocusNode,
                  onCompleted: (_) => _verifyEmailOtp(signupViewModel),
                ),
                const Gap(12),
                _buildOtpFooter(
                  secondsRemaining: _emailResendSecondsRemaining,
                  canResend: _canResendEmailOtp,
                  resending: _resendingEmailOtp,
                  onResend: () async {
                    setState(() => _resendingEmailOtp = true);
                    await _sendEmailOtp(signupViewModel);
                    if (mounted) setState(() => _resendingEmailOtp = false);
                  },
                ),
              ],
            ],
          ),
        ),

        const Gap(14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              _buildStatusChip('Phone', _phoneOtpVerified),
              const SizedBox(width: 10),
              _buildStatusChip('Email', _emailOtpVerified),
            ],
          ),
        ),
        const Gap(10),
      ],
    );

    Widget buildPasswordRequirements(String password) {
      final requirements = [
        {
          'label': 'passRequirments.req1'.tr(),
          'valid': password.length >= 8,
        },
        {
          'label': 'passRequirments.req2'.tr(),
          'valid': RegExp(r'[A-Z]').hasMatch(password),
        },
        {
          'label': 'passRequirments.req3'.tr(),
          'valid': RegExp(r'[a-z]').hasMatch(password),
        },
        {
          'label': 'passRequirments.req4'.tr(),
          'valid': RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password),
        },
        {
          'label': 'passRequirments.req5'.tr(),
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

    // ─────────────────────────────────────────────
    // PAGE 3: SECURITY INFORMATION (Same as Onboarding)
    // ─────────────────────────────────────────────
    Widget page3 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for page 3
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        //   child: SizedBox(
        //     width: context.appValues.appSizePercent.w100,
        //     child: Text(
        //       translate('signUp.securityInformation'),
        //       style: getPrimaryBoldStyle(
        //         color: const Color(0xff180C38),
        //         fontSize: 28,
        //       ),
        //     ),
        //   ),
        // ),
        // Password Field
        const Gap(25),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'formHints.password'.tr(),
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
                hintText: 'formHints.password'.tr(),
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

    // ─────────────────────────────────────────────
    // PAGE 4: ADDRESS INFORMATION (Includes full map functionality)
    // ─────────────────────────────────────────────
    Widget page4 = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title for page 4
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        //   child: SizedBox(
        //     width: context.appValues.appSizePercent.w100,
        //     child: Text(
        //       translate('signUp.addressInformation'),
        //       style: getPrimaryBoldStyle(
        //         color: const Color(0xff180C38),
        //         fontSize: 28,
        //       ),
        //     ),
        //   ),
        // ),
        // Location Row with "Choose Location" button
        const Gap(25),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20,
              vertical: context.appValues.appPadding.p10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
               'formHints.location'.tr(),
                style: getPrimarySemiBoldStyle(
                  fontSize: 12,
                  color: context.resources.color.btnColorBlue,
                ),
              ),
              Column(
                children: [
                  InkWell(
                    child: Text(
                      'signUp.chooseLocation'.tr(),
                      style: getPrimaryBoldStyle(
                        fontSize: 15,
                        color: context.resources.color.btnColorBlue,
                      ),
                    ),
                    onTap: () => _openMapPicker(signupViewModel),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: context.resources.color.btnColorBlue,
                    size: 20,
                  ),
                ],
              ),
            ],
          ),
        ),
        // Error messages for location if they exist
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
        // Map preview using FutureBuilder (as in the old UI)
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
                // Overlay InkWell so tapping triggers map picker
                InkWell(
                  onTap: () => _openMapPicker(signupViewModel),
                )
              ],
            ),
          ),
        ),
        // Address fields (same as the old UI)
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'formHints.street_number'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['street_number'] ?? '',
                index: 'street_number',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.street'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['street_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['street_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'formHints.building_number'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['building_number'] ?? '',
                index: 'building_number',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.building'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['building_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['building_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                  'formHints.floor'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['floor'] ?? '',
                index: 'floor',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.floor'.tr(),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['floor']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['floor']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                   'formHints.apartment_number'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['apartment_number'] ?? '',
                index: 'apartment_number',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.apartment'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['apartment_number']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['apartment_number']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'formHints.city'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                index: 'city',
                value: signupViewModel.getSignUpBody['city'] ?? '',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.city'.tr(),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['city']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['city']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'formHints.zone'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.getSignUpBody['zone'] ?? '',
                index: 'zone',
                viewModel: signupViewModel.setInputValues,
                hintText:'formHints.zone'.tr(),
                validator: (val) => signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['zone']!],
                errorText: signupViewModel
                    .signUpErrors[context.resources.strings.formKeys['zone']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
        hasLocation?
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'formHints.address_label'.tr(),
                    style: getPrimarySemiBoldStyle(
                      color: const Color(0xff180C38),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Gap(10),
              CustomTextField(
                value: signupViewModel.signUpBody["address_label"] ?? '',
                index: 'address_label',
                viewModel: signupViewModel.setInputValues,
                hintText: 'formHints.address_label'.tr(),
                validator: (val) => signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['address_label']!],
                errorText: signupViewModel.signUpErrors[
                    context.resources.strings.formKeys['address_label']!],
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ):Container(),
      ],
    );

    // ─────────────────────────────────────────────
    // PAGE 5: COMPLETE PROFILE (Includes image preview and upload)
    // ─────────────────────────────────────────────
    Widget page5 = Column(
      children: [
        // Title for page 5
        // Padding(
        //   padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        //   child: SizedBox(
        //     width: context.appValues.appSizePercent.w100,
        //     child: Text(
        //       translate('signUp.completeProfile'),
        //       style: getPrimaryBoldStyle(
        //         color: const Color(0xff180C38),
        //         fontSize: 28,
        //       ),
        //     ),
        //   ),
        // ),
        // Profile image preview
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
                  height: 155,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageWidget,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(32),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                      color: Color(0xff4100E3),
                    ),
                    child: Center(
                      child: UploadOneImage(
                        callback: (picked, save) async {
                          if (picked != null) {
                            setState(() {
                              image = {
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
        // Container(
        //   decoration: BoxDecoration(
        //     color: const Color(0xff9E9AB7),
        //     borderRadius: BorderRadius.circular(30.0),
        //   ),
        //   padding: EdgeInsets.symmetric(
        //     horizontal: context.appValues.appPadding.p20,
        //     vertical: context.appValues.appPadding.p10,
        //   ),
        // child: UploadOneImage(
        //   callback: (picked, save) async {
        //     if (picked != null) {
        //       setState(() {
        //         image = {
        //           'type': 'file',
        //           'image': File(picked[0].path),
        //         };
        //       });
        //     }
        //     if (save != null) {
        //       signupViewModel.setInputValues(
        //           index: 'avatar', value: save[0]["image"]);
        //     }
        //   },
        //   isImage: true,
        //   widget: Text(
        //     translate('signUp.uploadProfilePhoto'),
        //     style: getPrimaryBoldStyle(
        //       fontSize: 21,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // ),
      ],
    );

    // List all pages in order.
    final List<Widget> pages = [page1, page2, page3, page4, page5];

    return Scaffold(
      body: Stack(
        children: [
          // Top header with purple background, back button, progress bar, and title.
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
                  horizontal: context.appValues.appPadding.p20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button.
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back_ios_new_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const Gap(40),
                    // Progress indicator.
                    _buildStepIndicator(),
                    const Gap(40),
                    // Title.
                    Text(
                      "Let’s get things done!",
                      style: getPrimaryBoldStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                    const Gap(10),
                    Text(
                      "Enter you’re email and set up a password",
                      style: getPrimaryRegularStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Draggable bottom sheet with fixed bottom button.
          DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.70,
            maxChildSize: 1,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
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
                    // Fixed bottom button.
                    if (_currentStep != 1 || (_currentStep == 1 && _canProceedFromContactStep))                    Padding(
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
                          onPressed: () async {
                            if (_currentStep == 1 && !_canProceedFromContactStep) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please verify both phone number and email'),
                                ),
                              );
                              return;
                            }

                            // Validate current page before navigating.
                            if (_currentStep < _totalSteps - 1) {
                              if (await signupViewModel.validate(
                                  index: _currentStep)) {
                                setState(() {
                                  _currentStep++;
                                });
                              } else {
                                // ScaffoldMessenger.of(context).showSnackBar(
                                //   const SnackBar(
                                //       content: Text(
                                //           'Please fill in all required fields')),
                                // );
                              }
                            } else {
                              // Last page: final validation and complete signup.
                              if (await signupViewModel.validate(
                                  index: _currentStep)) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Sign Up Complete!')),
                                );
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        UserAgreement(index: _currentStep),
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
                            _currentStep == _totalSteps - 1
                                ? "Complete"
                                : "Next",
                            style: getPrimaryBoldStyle(
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
  Widget _buildVerificationCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEAEAEA)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xff4100E3), size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: getPrimarySemiBoldStyle(
                    color: const Color(0xff180C38),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const Gap(14),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required bool loading,
    required bool enabled,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled && !loading ? onTap : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xff4100E3),
          disabledBackgroundColor: const Color(0xFFBDBDBD),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: loading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: getPrimarySemiBoldStyle(
            fontSize: 15,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label, bool verified) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: verified ? const Color(0xFFE8F7EE) : const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: verified ? const Color(0xFF34A853) : const Color(0xFFE0E0E0),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            verified ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: verified ? const Color(0xFF34A853) : const Color(0xFF8F9098),
          ),
          const SizedBox(width: 6),
          Text(
            '$label ${verified ? "Verified" : "Pending"}',
            style: getPrimarySemiBoldStyle(
              fontSize: 12,
              color: verified ? const Color(0xFF34A853) : const Color(0xFF8F9098),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpBoxes({
    required TextEditingController controller,
    required FocusNode focusNode,
    required ValueChanged<String> onCompleted,
  }) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(focusNode),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.01,
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.number,
                maxLength: 4,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  if (value.length == 4) {
                    FocusScope.of(context).unfocus();
                    onCompleted(value);
                  }
                  setState(() {});
                },
              ),
            ),
          ),
          IgnorePointer(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, (index) {
                final digit =
                index < controller.text.length ? controller.text[index] : '';
                final isActive = controller.text.length == index ||
                    (controller.text.isEmpty && index == 0);

                return Container(
                  width: 60,
                  height: 56,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F9FB),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xff4100E3)
                          : const Color(0xFFE5E7EB),
                      width: isActive ? 1.5 : 1,
                    ),
                  ),
                  child: Text(
                    digit,
                    style: getPrimarySemiBoldStyle(
                      fontSize: 20,
                      color: const Color(0xff180C38),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpFooter({
    required int secondsRemaining,
    required bool canResend,
    required bool resending,
    required VoidCallback onResend,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Enter the 4-digit code',
          style: getPrimaryRegularStyle(
            fontSize: 13,
            color: const Color(0xFF8F9098),
          ),
        ),
        if (!canResend)
          Text(
            _formatCountdown(secondsRemaining),
            style: getPrimarySemiBoldStyle(
              fontSize: 13,
              color: const Color(0xff4100E3),
            ),
          )
        else
          GestureDetector(
            onTap: resending ? null : onResend,
            child: Text(
              resending ? 'Sending...' : 'Resend',
              style: getPrimarySemiBoldStyle(
                fontSize: 13,
                color: const Color(0xff4100E3),
              ),
            ),
          ),
      ],
    );
  }
}
