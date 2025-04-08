import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class CustomTimePicker extends StatefulWidget {
  const CustomTimePicker({
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
  _CustomTimePickerState createState() => _CustomTimePickerState();
}

class _CustomTimePickerState extends State<CustomTimePicker> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    // If a value is provided, you could parse it to get a TimeOfDay.
    // For simplicity, if no value is provided, we default to the current time.
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    debugPrint('Picked time: $picked');
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
      widget.viewModel(
          index: widget.index, value: _selectedTime.format(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p10,
      ),
      child: InkWell(
        onTap: () => _selectTime(context),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Clock icon from SVG
                SvgPicture.asset(
                  'assets/img/clock.svg',
                  width: 20,
                  height: 20,
                ),
                const Gap(10),
                // Column with a title and the formatted time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Working Time',
                      style: getPrimaryRegularStyle(
                        color: const Color(0xff180B3C),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      // Display the selected time.
                      _selectedTime.format(context),
                      style: getPrimaryRegularStyle(
                        color: const Color(0xff71727A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // Trailing arrow icon
            const Icon(
              Icons.arrow_forward_ios_sharp,
              size: 20,
              color: Color(0xff8F9098),
            ),
          ],
        ),
      ),
    );
  }
}
