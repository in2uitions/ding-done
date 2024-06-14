import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

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
    return Container(
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
      child: TextFormField(

        cursorColor: const Color(0xffB4B4B4),
        controller: _customController,
        textAlignVertical: TextAlignVertical.center,
        // key: globalKey,
        obscureText: widget.hintText == "Password" ? obscureText : false,
        // maxLength: 32,
        // onSaved: widget.onSaved,
        // validator: widget.validator,
        // onFieldSubmitted: widget.onFieldSubmitted,
        // onChanged: widget.onChanged,
        keyboardType: widget.keyboardType,
        // onTap: (() => widget.onTap),
        style: getPrimaryRegularStyle(
          // color: const Color(0xffB4B4B4),
          fontSize: 15,
        ),
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

          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(15),
            ),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: context.resources.color.colorWhite,
          hintText: widget.hintText,
          hintStyle: getPrimaryRegularStyle(
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
                  child: Icon(
                      obscureText ? Icons.visibility : Icons.visibility_off),
                )
              : null,
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
