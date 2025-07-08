import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:gap/gap.dart';

class CustomIncrementField extends StatefulWidget {
  const CustomIncrementField({
    super.key,
    this.hintText,
    this.value,
    required this.index,
    required this.minimumOrder,
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
    this.keyboardType = TextInputType.number,
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
  final TextInputType keyboardType;

  final dynamic minimumOrder;

  @override
  _CustomIncrementFieldState createState() => _CustomIncrementFieldState();
}

class _CustomIncrementFieldState extends State<CustomIncrementField> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  int currentValue = 1;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('value is ${widget.value}');

    currentValue = widget.value != null && widget.value != '' && widget.value != '0'
        ? int.parse(widget.value.toString())
        : 1;
    widget.viewModel(index: widget.index, value: widget.value);
    _customController.text = currentValue.toString();
    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: _customController.text);
    });
  }

  void _increment() {
    if (currentValue < 99999) {
      setState(() {
        currentValue++;
        _customController.text = currentValue.toString();
      });
      widget.viewModel(index: widget.index, value: _customController.text);
      if (widget.onChanged != null) {
        widget.onChanged!(_customController.text);
      }
    }
  }

  void _decrement() {
    if (currentValue > widget.minimumOrder) {
      setState(() {
        currentValue--;
        _customController.text = currentValue.toString();
      });
      widget.viewModel(index: widget.index, value: _customController.text);
      if (widget.onChanged != null) {
        widget.onChanged!(_customController.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _decrement,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffEAEAFF).withOpacity(0.35),
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                '–',
                style: getPrimaryRegularStyle(
                  color: const Color(0xff6E6BE8).withOpacity(0.35),
                  fontSize: 20,
                ),
              ),
            ),
            const Gap(12),
            SizedBox(
              width: 32,
              child: TextFormField(
                controller: _customController,
                textAlign: TextAlign.center,
                keyboardType: widget.keyboardType,
                style: getPrimaryRegularStyle(
                  color: const Color(0xff78789D),
                  fontSize: 15,
                ),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(width: 12),
            TextButton(
              onPressed: _increment,
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xffEAEAFF),
                minimumSize: const Size(32, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: const CircleBorder(),
                padding: EdgeInsets.zero,
              ),
              child: Text(
                '+',
                style: getPrimaryRegularStyle(
                  color: const Color(0xff4100E3),
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _customController.removeListener(() {});
    _customController.dispose();
    super.dispose();
  }
}
