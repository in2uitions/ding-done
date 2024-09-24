import 'package:dingdone/res/app_validation.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_translate/flutter_translate.dart';

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
    this.keyboardType = TextInputType.text,
  });

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
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    _customController.text = widget.value ?? '';
    _customController.addListener(() {
      // if (widget.tag == '') {
      widget.viewModel(index: widget.index, value: _customController.text);
      // } else {
      //   widget.viewModel(
      //       index: widget.index,
      //       value: _customController.text,
      //       arrayIndex: widget.arrayIndex,
      //       tag: widget.tag);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xffB4B4B4),
      controller: _customController,
      textAlignVertical: TextAlignVertical.center,
      obscureText: widget.hintText == "Password" ? obscureText : false,
      validator: widget.hintText == translate('paymentMethod.cardNumber')
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
        hintStyle: getPrimaryBoldStyle(
          fontSize: 15,
          color: const Color(0xffB4B4B4),
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
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
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
