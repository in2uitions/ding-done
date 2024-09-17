import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomDatePicker2 extends StatefulWidget {
  const CustomDatePicker2({
    super.key,
    required this.index,
    required this.viewModel,
    this.hintText,
    this.value,
  });

  final dynamic viewModel;
  final String index;
  final String? hintText;
  final String? value;

  @override
  State<StatefulWidget> createState() {
    return _CustomDatePicker2();
  }
}

class _CustomDatePicker2 extends State<CustomDatePicker2> {
  TextEditingController dateinput = TextEditingController();

  @override
  void initState() {
    dateinput.text = widget.value ?? '';

    dateinput.addListener(() {
      widget.viewModel(index: widget.index, value: dateinput.text);
    });
    super.initState();
  }

  @override
  void dispose() {
    dateinput.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: dateinput,
      decoration: InputDecoration(
        isDense: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: context.resources.color.colorTransparent,
        hintText: widget.hintText,
        hintStyle: getPrimaryRegularStyle(
          fontSize: 15,
          color: const Color(0xffB4B4B4),
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 5,
          ),
          child: SvgPicture.asset(
            'assets/img/calendar.svg',
            width: 15,
            height: 15,
          ),
        ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(DateTime.now().year - 100, 1),
          lastDate: DateTime(DateTime.now().year + 100, 1),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

          setState(() {
            dateinput.text = formattedDate;
          });
          widget.viewModel(index: 'date', value: formattedDate.toString());
        }
      },
    );
  }
}
