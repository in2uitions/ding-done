import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CustomPhoneFeild extends StatefulWidget {
  const CustomPhoneFeild({
    super.key,
    this.hintText,
    this.value,
    required this.index,
    required this.viewModel,
    required this.errorText,
    this.validator,
  });

  final dynamic viewModel;
  final String index;
  final String? value;
  final String? hintText;
  final String? errorText;
  final FormFieldValidator<String>? validator;

  @override
  _CustomPhoneFeildState createState() => _CustomPhoneFeildState();
}

class _CustomPhoneFeildState extends State<CustomPhoneFeild> {
  final GlobalKey<FormFieldState<String>> globalKey =
  GlobalKey<FormFieldState<String>>();
  final TextEditingController _customController = TextEditingController();

  String countryCode = '+974'; // Default country code (e.g., Qatar)

  @override
  void initState() {
    super.initState();
    _customController.text = widget.value ?? '';

    // Initialize the full phone number with the default country code
    widget.viewModel(index: widget.index, value: '$countryCode${_customController.text}');
    widget.viewModel(index: 'phone', value: '${_customController.text}');

    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: '$countryCode${_customController.text}');
      widget.viewModel(index: 'phone', value: '${_customController.text}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      style: getPrimaryRegularStyle(
        fontSize: 16,
      ),
      textAlign: TextAlign.start,
      controller: _customController,
      decoration: InputDecoration(
        errorText: widget.errorText,
        hintText: translate('formHints.phone_number'),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: context.resources.color.colorWhite,
      ),
      initialCountryCode: 'QA',
      disableLengthCheck: true,
      onChanged: (phone) {
        // Update the full phone number when the text changes
        widget.viewModel(index: widget.index, value: '$countryCode${phone.number}');
        widget.viewModel(index: 'phone', value: '${phone.number}');
      },
      onCountryChanged: (country) {
        setState(() {
          // Update the country code when the selected country changes
          countryCode = '+${country.dialCode}';
        });
        // Update the full phone number in the view model
        widget.viewModel(index: widget.index, value: '$countryCode${_customController.text}');
        widget.viewModel(index: 'phone', value: '${_customController.text}');
      },
    );
  }

  @override
  void dispose() {
    _customController.dispose();
    super.dispose();
  }
}

