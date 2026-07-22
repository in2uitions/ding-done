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

  late final TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    // Constructor does not notify listeners — avoids wiping the selected
    // cancellation reason with '' when this field mounts for "Other".
    _customController = TextEditingController(text: widget.value ?? '');
  }

  void _pushValue(String value) {
    widget.viewModel(index: widget.index, value: value);
    widget.onChanged?.call(value);
  }

  @override
  void dispose() {
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
      onChanged: _pushValue,
      keyboardType: widget.keyboardType,
      cursorColor: context.resources.color.btnColorBlue,
      autofocus: false,
      style:
          getPrimaryRegularStyle(color: context.resources.color.colorBlack[50]),
      decoration: InputDecoration(
        hintStyle: getPrimaryRegularStyle(
          fontSize: 14,
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
