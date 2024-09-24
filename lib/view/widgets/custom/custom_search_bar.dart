import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomSearchBar extends StatefulWidget {
  const CustomSearchBar({
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

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  bool obscureText = true;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    _customController.text = widget.value ?? '';
    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: _customController.text);
      // if (widget.tag == '') {
      //   // widget.viewModel(index: widget.index, value: _customController.text);
      // } else {
      //   // widget.viewModel(
      //   //     index: widget.index,
      //   //     value: _customController.text,
      //   //     arrayIndex: widget.arrayIndex,
      //   //     tag: widget.tag);
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
      obscureText: widget.hintText == "Password" ? obscureText : false,
      // maxLength: 32,
      onSaved: widget.onSaved,
      validator: widget.validator,
      // onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onChanged,
      // onTap: (() => widget.onTap),
      style:
          getPrimaryRegularStyle(color: context.resources.color.colorBlack[50]),
      decoration: InputDecoration(
        isDense: true,
        errorText: widget.errorText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: context.resources.color.colorWhite,
        hintText: widget.hintText,
        hintStyle: getPrimaryBoldStyle(
          color: const Color(0xffB4B4B4),
          fontSize: 15,
        ),
        // labelText: widget.hintText,
        helperText: widget.helperText,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: Color(0xff9F9AB7),
          size: 25,
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
