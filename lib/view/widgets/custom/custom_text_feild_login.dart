import 'package:dingdone/res/app_validation.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomTextFieldLogin extends StatefulWidget {
  const CustomTextFieldLogin({
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
    this.controller,
    this.autofillHints,

    this.keyboardType = TextInputType.text,
  });
  final TextEditingController? controller;
  final List<String>? autofillHints;

  final dynamic viewModel;
  final String? value;
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

  @override
  _CustomTextFieldLoginState createState() => _CustomTextFieldLoginState();
}

class _CustomTextFieldLoginState extends State<CustomTextFieldLogin> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  bool obscureText = true;
  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();

    _customController =
        widget.controller ?? TextEditingController(text: widget.value ?? '');

    _customController.addListener(() {
      widget.viewModel(
        index: widget.index,
        value: _customController.text,
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _customController,
      autofillHints: widget.autofillHints,
      cursorColor: const Color(0xffB4B4B4),
      textAlignVertical: TextAlignVertical.center,
      obscureText: widget.hintText == "Password" ? obscureText : false,
      validator: widget.hintText == 'paymentMethod.cardNumber'.tr()
          ? AppValidation().cardNumberValidator
          : widget.validator,
      keyboardType: widget.keyboardType,
      style: getPrimaryRegularStyle(
        fontSize: 15,
      ),
      decoration: InputDecoration(
        isDense: true,
        errorText: widget.errorText,
        filled: true,
        fillColor: context.resources.color.colorWhite,
        hintText: widget.hintText,
        hintStyle: getPrimaryRegularStyle(
          fontSize: 14,
          color: const Color(0xff8F9098),
        ),
        helperText: widget.helperText,
        suffixIcon: widget.hintText == "Password"
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                child:
                    Icon(obscureText ? Icons.visibility : Icons.visibility_off),
              )
            : null,
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 13.0, horizontal: 16.0),
      ),
    );
  }

  @override
  void dispose() {
    _customController.removeListener(() {});
    _customController.dispose();
    super.dispose();
  }
}
