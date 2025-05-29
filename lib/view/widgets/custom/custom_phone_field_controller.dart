import 'package:dingdone/res/app_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../../res/fonts/styles_manager.dart';

class CustomPhoneFieldController extends StatefulWidget {
  const CustomPhoneFieldController({
    super.key,
    this.hintText,
    this.value,
    required this.index,
    this.arrayIndex = 0,
    this.tag = '',
    required this.viewModel,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    this.phone_code,
    this.phone_number,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    required this.controller,
  });

  final dynamic viewModel;
  final String? value;
  final String? phone_code;
  final String? phone_number;
  final String index;
  final int arrayIndex;
  final String tag;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTap;
  final keyboardType;
  final bool obscureText;
  final TextEditingController controller;

  @override
  _CustomPhoneFieldControllerState createState() =>
      _CustomPhoneFieldControllerState();
}

class _CustomPhoneFieldControllerState
    extends State<CustomPhoneFieldController> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  bool obscureText = false;

  // PhoneNumber initialNumber = PhoneNumber(countryISOCode: 'US',countryCode: 'US', number: ''); // Default country code
  var phone = '';
  @override
  Widget build(BuildContext context) {
    debugPrint('phone code ${widget.phone_code}');
    return IntlPhoneField(
      initialValue: widget.phone_number != null ? widget.phone_number : '',
      initialCountryCode: widget.phone_code != null ? widget.phone_code : 'AE',
      dropdownTextStyle: getPrimaryRegularStyle(
        fontSize: 14,
      ),
      style: getPrimaryRegularStyle(
        fontSize: 14,
      ),
      onChanged: (PhoneNumber number) {
        // Concatenate the country code and phone number
        final fullPhoneNumber = '${number.countryCode}${number.number}';
        phone = number.number;
        // Update the controller text
        widget.controller.text = phone;

        // Pass the full phone number to the view model
        widget.viewModel(index: widget.index, value: fullPhoneNumber);
        widget.viewModel(index: 'phone_number', value: phone);
        widget.viewModel(index: 'phone_code', value: number.countryISOCode);
        debugPrint('phone code on change  ${number.countryISOCode}');

        debugPrint('country code ${number.countryISOCode}');
      },
      onCountryChanged: (country) {
        final fullPhoneNumber = '+${country.dialCode}${phone}';

        // Update the controller text
        widget.controller.text = fullPhoneNumber;

        // Pass the full phone number to the view model
        widget.viewModel(index: widget.index, value: fullPhoneNumber);
        widget.viewModel(index: 'phone_number', value: phone);
        widget.viewModel(index: 'phone_code', value: country.code);
        debugPrint('country code 2 ${country.code}');
      },
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: translate('formHints.phone_number'),
        hintStyle: getPrimaryRegularStyle(
          fontSize: 14,
        ),
        labelStyle: getPrimaryRegularStyle(
          fontSize: 14,
        ),
        suffixStyle: getPrimaryRegularStyle(
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xffC5C6CC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xffC5C6CC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xffC5C6CC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color(0xffC5C6CC),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: context.resources.color.colorWhite,
      ),
    );
  }
}
