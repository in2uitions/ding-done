import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDatePicker extends StatefulWidget {
  const CustomDatePicker({
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
    return _CustomDatePicker();
  }
}

class _CustomDatePicker extends State<CustomDatePicker> {
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
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xffEAEAFF),
            width: 2.0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        hintStyle: getPrimaryRegularStyle(
          fontSize: 15,
          color: const Color(0xffB4B4B4),
        ),
        // suffixIcon: const Icon(
        //   Icons.calendar_today_outlined,
        //   color: Color(0xff57537A),
        // ),
      ),
      readOnly: true,
      onTap: () async {
        DateTime now = DateTime.now();
        DateTime eighteenYearsAgo = DateTime(now.year - 18, now.month, now.day);
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: eighteenYearsAgo,
          firstDate: DateTime(now.year - 100, 1, 1),
          lastDate: eighteenYearsAgo,
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
