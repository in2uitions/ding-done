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
    return Stack(
      children: [
        Container(
          height: context.appValues.appSizePercent.h8,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        IntlPhoneField(
          style: getPrimaryRegularStyle(
            fontSize: 16,
            // color: const Color(0xffB4B4B4),
          ),
          textAlign: TextAlign.start,
          controller: _customController,
          decoration: InputDecoration(
            errorText: widget.errorText,
            hintText: translate('formHints.phone_number'),
            // labelStyle: TextStyle(),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(context.appValues.appSize.s10),
              ),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: context.resources.color.colorWhite,
          ),
          initialCountryCode: 'QA',
          disableLengthCheck: true,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customController.removeListener(() {});
    _customController.dispose();
    super.dispose();
  }
}
