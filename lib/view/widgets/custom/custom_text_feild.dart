import 'package:dingdone/res/app_validation.dart';
import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
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
    this.prefixIcon = '',
    this.isPrfixShown = false,
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
  final String prefixIcon;
  final bool isPrfixShown;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTap;
  final keyboardType;

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
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
        fontSize: 14,
      ),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p16,
          vertical: context.appValues.appPadding.p12,
        ),
        isDense: true,
        errorText: widget.errorText,
        // Using OutlineInputBorder for all borders so that they appear all around.
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
        prefixIcon: widget.isPrfixShown
            ? Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: 5,
                ),
                child: SvgPicture.asset(
                  widget.prefixIcon,
                  width: 15,
                  height: 15,
                ),
              )
            : null,
        filled: true,
        fillColor: context.resources.color.colorWhite,
        hintText: widget.hintText,
        hintStyle: getPrimaryRegularStyle(
          fontSize: 14,
          color: const Color(0xff343b61),
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
