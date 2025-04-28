import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  CustomDropDown({
    super.key,
    required this.list,
    required this.onChange,
    this.value,
    this.hint = '',
    this.errorText,
    required this.index,
    this.validator,
    required this.viewModel,
    this.labelText,
    this.onSaved,
    this.onFieldSubmitted,
    this.onChanged,
    this.hintText,
    this.onTap,
    this.keyboardType,
  });

  final List<dynamic> list;
  final dynamic onChange;
  final String? value;
  final String hint;
  final String? errorText;
  final String index;
  final FormFieldValidator<String>? validator;
  final dynamic viewModel;
  final String? hintText;
  final String? labelText;
  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTap;
  final keyboardType;

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      icon: const Icon(Icons.keyboard_arrow_down),
      elevation: 16,
      isExpanded: true,
      dropdownColor: Colors.white, // Set dropdown background color to white
      validator: widget.validator,
      style: getPrimaryRegularStyle(
          fontSize: 14, color: context.resources.color.colorBlack[50]),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.appValues.appPadding.p16,
          vertical: context.appValues.appPadding.p12,
        ),
        hintText: widget.hintText,
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
        isDense: true,
        errorText: widget.errorText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: widget.onChange,
      hint: Text(
        widget.hintText!,
        style: getPrimaryRegularStyle(
          fontSize: 14,
          color: const Color(0xff343b61),
        ),
      ),
      items: widget.list.map<DropdownMenuItem<String>>((dynamic value) {
        return DropdownMenuItem<String>(
          value: value['code'],
          child: Text(
            value['name'] ?? '',
            overflow: TextOverflow.ellipsis,
            softWrap: true,
          ),
        );
      }).toList(),
    );
  }
}
