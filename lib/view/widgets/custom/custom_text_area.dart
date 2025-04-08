import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomTextArea extends StatefulWidget {
  const CustomTextArea({
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
    this.maxlines = 8,
  });

  final dynamic viewModel;
  final String? value;
  final String index;
  final int arrayIndex, maxlines;
  final String tag;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final String? errorText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextInputType keyboardType;

  @override
  _CustomTextAreaState createState() => _CustomTextAreaState();
}

class _CustomTextAreaState extends State<CustomTextArea> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  bool obscureText = true;

  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _customController.text = widget.value ?? '';
    _customController.addListener(_updateValue);
  }

  void _updateValue() {
    widget.viewModel(index: widget.index, value: _customController.text);
    // if (widget.tag == '') {
    //   widget.viewModel(index: widget.index, value: _customController.text);
    // } else {
    //   widget.viewModel(
    //       index: widget.index,
    //       value: _customController.text,
    //       arrayIndex: widget.arrayIndex,
    //       tag: widget.tag);
    // }
  }

  @override
  void dispose() {
    _customController.removeListener(_updateValue);
    _customController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _customController,
      textAlignVertical: TextAlignVertical.center,
      obscureText: widget.hintText == "Password" ? obscureText : false,
      maxLines: widget.maxlines,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      cursorColor: context.resources.color.btnColorBlue,
      autofocus: false,
      style:
          getPrimaryRegularStyle(color: context.resources.color.colorBlack[50]),
      decoration: InputDecoration(
        hintStyle: getPrimaryRegularStyle(
          fontSize: 15,
          color: const Color(0xffC5C6CC),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: Color(0xffC5C6CC),
            width: 1.0,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
          borderSide: BorderSide(
            color: Color(0xffC5C6CC),
            width: 1.0,
          ),
        ),
        filled: true,
        fillColor: context.resources.color.colorWhite,
        hintText: widget.hintText,
      ),
    );
  }
}
