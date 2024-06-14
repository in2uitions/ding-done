// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:dingdone/res/app_context_extension.dart';
// import 'package:dingdone/res/fonts/styles_manager.dart';

// class CustomTimePicker extends StatefulWidget {
//   const CustomTimePicker({
//     super.key,
//     required this.index,
//     required this.viewModel,
//     this.hintText,
//     this.value,
//   });

//   final dynamic viewModel;
//   final String index;
//   final String? hintText;
//   final String? value;

//   @override
//   State<StatefulWidget> createState() {
//     return _CustomTimePicker();
//   }
// }

// class _CustomTimePicker extends State<CustomTimePicker> {
//   TextEditingController dateinput = TextEditingController();

//   @override
//   void initState() {
//     dateinput.text = widget.value ?? '';

//     dateinput.addListener(() {
//       widget.viewModel(index: widget.index, value: dateinput.text);
//     });
//     super.initState();
//   }

//   @override
//   void dispose() {
//     dateinput.removeListener(() {});
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//         child: TextFormField(
//       controller: dateinput,
//       decoration: InputDecoration(
//         isDense: true,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.all(
//             Radius.circular(context.appValues.appSize.s10),
//           ),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xff9E9AB7),
//             width: 2,
//           ),
//         ),
//         focusedBorder: const UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xff9E9AB7),
//             width: 2,
//           ),
//         ),
//         filled: true,
//         fillColor: context.resources.color.colorWhite,
//         hintText: widget.hintText,
//         hintStyle: getPrimaryRegularStyle(),
//         prefixIcon: const Icon(
//           Icons.access_time_rounded,
//           color: Color(0xff57537A),
//         ),
//       ),
//       readOnly: true,
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: context,
//           initialDate: DateTime.now(),
//           // firstDate: DateTime(19),
//           // lastDate: DateTime(2101)
//           firstDate: DateTime(DateTime.now().year - 100, 1),
//           lastDate: DateTime(DateTime.now().year + 100, 1),
//         );

//         if (pickedDate != null) {
//           String formattedDate = DateFormat('dd-MM-yyyy').format(pickedDate);

//           setState(() {
//             dateinput.text = formattedDate;
//           });
//         }
//       },
//     ));
//   }
// }

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
    super.key,
    required this.index,
    required this.viewModel,
  });

  final dynamic viewModel;
  final String index;

  @override
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    debugPrint('picked time ${picked}');

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.viewModel(index: widget.index, value: _selectedTime.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: InkWell(
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xff9E9AB7), // Bottom border color
                      width: 2, // Bottom border width
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Gap(15),
                        const Icon(
                          Icons.access_time_rounded,
                          color: Color(0xff57537A),
                        ),
                        const Gap(12),
                        Text(
                          _selectedTime.format(context),
                          style: getPrimaryRegularStyle(
                            fontSize: 18,
                            color: context.resources.color.btnColorBlue,
                          ),
                        ),
                      ],
                    ),
                    const Gap(8),
                  ],
                ),
              ),
              onTap: () => _selectTime(context),
            ),
          ),
        ],
      ),
    );
  }
}
