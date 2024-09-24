import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomStatusDropDown extends StatefulWidget {
  var state;

  CustomStatusDropDown({super.key, required this.state});
  @override
  State<CustomStatusDropDown> createState() => _CustomStatusDropDownState();
}

class _CustomStatusDropDownState extends State<CustomStatusDropDown> {
  // String dropdownvalue = 'Job in Progress';

  // List of items in our dropdown menu
  var items = [
    'Job in Progress',
    'Available for hire',
    'Not Available',
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // items=widget.body["state"];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(builder: (context, profileViewModel, _) {
      return DropdownButtonHideUnderline(
        child: DropdownButton(
          value: widget.state.toString(),
          style: getPrimaryBoldStyle(
            color: const Color(0xff180C38),
            fontSize: 15,
          ),
          dropdownColor: const Color(0xffFEFEFE),
          icon: const Icon(Icons.keyboard_arrow_down),

          // Array list of items
          items: items.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: getPrimaryBoldStyle(
                  color: context.resources.color.colorWhite,
                  fontSize: 17,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              profileViewModel.setInputValues(index: "state", value: newValue);
              profileViewModel.patchProfileState(newValue);
              // dropdownvalue = newValue!;
            });
          },
        ),
      );
    });
  }
}
