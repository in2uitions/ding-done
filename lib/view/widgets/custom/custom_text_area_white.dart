import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomTextAreaWhite extends StatefulWidget {
  const CustomTextAreaWhite({
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
    required this.keyboardType,
    required this.maxlines,
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
  _CustomTextAreaWhiteState createState() => _CustomTextAreaWhiteState();
}

class _CustomTextAreaWhiteState extends State<CustomTextAreaWhite> {
  final GlobalKey<FormFieldState<String>> globalKey = GlobalKey<FormFieldState<String>>();
  bool obscureText = true;
  late TextEditingController _customController;

  @override
  void initState() {
    super.initState();
    _customController = TextEditingController(text: widget.value ?? '');
    // _customController.addListener(_updateValue);
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
    return Container(
      child: TextFormField(
        controller: _customController,
        textAlignVertical: TextAlignVertical.center,
        key: globalKey,
        obscureText: widget.hintText == "Password" ? obscureText : false,
        maxLines: widget.maxlines,
        // onSaved: widget.onSaved,
        validator: widget.validator,
        // onFieldSubmitted: widget.onFieldSubmitted,
        onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        autofocus: false,
        // onTap: widget.onTap,
        style: getPrimaryRegularStyle(
            color: context.resources.color.colorBlack[50]),
        decoration: InputDecoration(
          hintStyle: getPrimaryRegularStyle(
              fontSize: 15, color: context.resources.color.secondColorBlue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(context.appValues.appSize.s10),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: context.resources.color.colorWhite,
          hintText: widget.hintText,
        ),
      ),
    );
  }
}
