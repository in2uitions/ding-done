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
  bool obscureText = true;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    _customController.text = widget.value ?? '';
    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: _customController.text);
    });
    super.initState();
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
    );
  }

  @override
  void dispose() {
    _customController.removeListener(() {});
    _customController.dispose();
    super.dispose();
  }
}
