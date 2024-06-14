import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

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
    return Center(
        child: Container(
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
        controller: dateinput,
        decoration: InputDecoration(
          isDense: true,
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
          suffixIcon: const Icon(
            Icons.calendar_today_outlined,
            color: Color(0xff57537A),
          ),
        ),
        readOnly: true,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            // firstDate: DateTime(19),
            // lastDate: DateTime(2101)
            firstDate: DateTime(DateTime.now().year - 100, 1),
            lastDate: DateTime(DateTime.now().year + 100, 1),
          );

          if (pickedDate != null) {
            String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

            setState(() {
              dateinput.text = formattedDate;
            });
            widget.viewModel(index:'date',value:formattedDate.toString());
          }
        },
      ),
    ));
  }
}
