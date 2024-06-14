import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomPasswordTextField extends StatefulWidget {
  const CustomPasswordTextField({
    super.key,
    this.hintText,
    this.value,
    required this.index,
    this.arrayIndex = 0,
    this.tag = '',
    // required this.viewModel,
    this.labelText,
    this.helperText,
    this.errorText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
    this.onChanged,
    this.onTap,
    required this.keyboardType,
  });

  // final dynamic viewModel;
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
  _CustomPasswordTextFieldState createState() =>
      _CustomPasswordTextFieldState();
}

class _CustomPasswordTextFieldState extends State<CustomPasswordTextField> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  bool obscureText = true;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    _customController.text = widget.value ?? '';
    _customController.addListener(() {
      // if (widget.tag == '') {
        // widget.viewModel(index: widget.index, value: _customController.text);
      // } else {
        // widget.viewModel(
        //     index: widget.index,
        //     value: _customController.text,
        //     arrayIndex: widget.arrayIndex,
        //     tag: widget.tag);
      // }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _customController,
      textAlignVertical: TextAlignVertical.center,
      key: globalKey,
      obscureText: obscureText,
      // maxLength: 32,
      // onSaved: widget.onSaved,
      validator: widget.validator,
      // onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      onTap: (() => widget.onTap),
      style:
          getPrimaryRegularStyle(color: context.resources.color.colorBlack[50]),
      decoration: InputDecoration(
        isDense: true,
        errorText: widget.errorText,
        // border: InputBorder.none,
        // contentPadding: EdgeInsets.all(context.appValues.appPadding.p8),
        // border: OutlineInputBorder(
        //   // borderSide: BorderSide.,
        //   borderRadius: BorderRadius.all(
        //     Radius.circular(context.appValues.appSize.s10),
        //   ),
        // ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(context.appValues.appSize.s10),
          ),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: context.resources.color.colorWhite,
        hintText: widget.hintText,
        // labelText: widget.hintText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              obscureText = !obscureText;
            });
          },
          child: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
            color: Color(0xffC5CEE0),
          ),
        ),
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
