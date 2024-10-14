import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';

class CustomLocationDropDown extends StatefulWidget {
  CustomLocationDropDown(
      {super.key,
      required this.profileViewModel,
      this.color = 0xfff0f0f0,
      this.backgroundColor = 0xff040542});

  ProfileViewModel profileViewModel;
  int color, backgroundColor;

  @override
  State<CustomLocationDropDown> createState() => _CustomLocationDropDownState();
}

class _CustomLocationDropDownState extends State<CustomLocationDropDown> {
  // Initial Selected Value
  // var items=[];
  // List of items in our dropdown menu
  // var items = [
  //   'Lordou Vyrona 57, Larnaca 6023, Cyprus',
  //   'Oktovriou 28, Larnaca 6055, Cyprus',
  //   '7c Solonos, Nicosia 1011, Cyprus',
  // ];
  //
  var items = [];
  var dropdownvalue = '';

  @override
  void initState() {
    // TODO: implement initState
    items = widget.profileViewModel.getProfileBody["address"] != null
        ? widget.profileViewModel.getProfileBody["address"]
        : [];
    dropdownvalue = widget.profileViewModel.getProfileBody["address"] != null
        ? '${items[0]["street_number"]} ${items[0]["building_number"]}, ${items[0]["city"]}, ${items[0]["zone"]} '
        : '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        value: dropdownvalue,
        style:
            getPrimaryBoldStyle(color: const Color(0xffEDF1F7), fontSize: 13),
        dropdownColor: Color(widget.backgroundColor),
        icon: const Icon(Icons.keyboard_arrow_down),

        // Array list of items
        items: items.map((dynamic items) {
          return DropdownMenuItem(
            value:
                '${items["street_number"]} ${items["building_number"]}, ${items["city"]}, ${items["zone"]} ',
            child: SizedBox(
              width: context.appValues.appSizePercent.w75,
              child: Text(
                '${items["street_number"]} ${items["building_number"]}, ${items["city"]}, ${items["zone"]} ',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: getPrimaryRegularStyle(
                  fontSize: 13,
                  color: Color(widget.color),
                ),
              ),
            ),
          );
        }).toList(),
        onChanged: (dynamic newValue) {
          setState(() {
            dropdownvalue = newValue!;
          });
        },
      ),
    );
  }
}
