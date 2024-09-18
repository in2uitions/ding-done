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
    this.onChanged, this.hintText, this.onTap, this.keyboardType,
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
    return Material(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      elevation: 5,
      shadowColor: Colors.black,
      child: DropdownButtonFormField<String>(
        // value: widget.value,
        icon: const Icon(Icons.keyboard_arrow_down),
        elevation: 16,
        isExpanded: true,
        validator: widget.validator,
        style:
            // TextStyle(
            //     overflow: TextOverflow.ellipsis, color: Colors.black, fontSize: 9),
            getPrimaryRegularStyle(
                color: context.resources.color.colorBlack[50]),
        decoration: InputDecoration(
          // labelText: widget.hint,
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(width: 2, color: Color(0xfff7bb23)),
          ),
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
            borderSide: BorderSide(width: 0, color: Colors.transparent),
          ),
          isDense: true,
          errorText: widget.errorText,
          // contentPadding: EdgeInsets.all(context.appValues.appPadding.p8),
          border: OutlineInputBorder(
            // borderSide: BorderSide.,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          filled: true,
          fillColor: context.resources.color.colorWhite,
        ),
        onChanged: widget.onChange,
        hint: Text(widget.hint),
        items: widget.list
            .map<DropdownMenuItem<String>>((dynamic value) {
          return DropdownMenuItem<String>(
            value: value['code'],
            child: Text(
              value['name'] ?? '',
              // maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
          );
        }).toList(),
      ),
    );
  }
}
