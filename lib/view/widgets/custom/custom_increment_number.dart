import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomIncrementField extends StatefulWidget {
  const CustomIncrementField({
    super.key,
    this.hintText,
    this.value,
    required this.index,
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

  @override
  _CustomIncrementFieldState createState() => _CustomIncrementFieldState();
}

class _CustomIncrementFieldState extends State<CustomIncrementField> {
  final GlobalKey<FormFieldState<String>> globalKey =
      GlobalKey<FormFieldState<String>>();
  int currentValue = 0;
  final TextEditingController _customController = TextEditingController();

  @override
  void initState() {
    super.initState();
    debugPrint('value is ${widget.value}');
    currentValue = widget.value != null && widget.value != ''
        ? int.parse(widget.value.toString())
        : 0;
    _customController.text = currentValue.toString();
    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: _customController.text);
    });
  }

  void _increment() {
    if (currentValue < 99) {
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
    if (currentValue > 0) {
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
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: _decrement,
              color: const Color(0xffB4B4B4),
            ),
            Expanded(
              child: TextFormField(
                cursorColor: const Color(0xffB4B4B4),
                controller: _customController,
                textAlign: TextAlign.center,
                keyboardType: widget.keyboardType,
                style: getPrimaryRegularStyle(
                  color: const Color(0xff78789D),
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  errorText: widget.errorText,
                  border: InputBorder.none, // Removed the border here
                  hintText: widget.hintText,
                  hintStyle: getPrimaryRegularStyle(
                    fontSize: 15,
                    color: const Color(0xffB4B4B4),
                  ),
                  helperText: widget.helperText,
                ),
                onChanged: (value) {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= 0 && newValue <= 99) {
                    setState(() {
                      currentValue = newValue;
                    });
                    widget.viewModel(index: widget.index, value: value);
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
                  } else {
                    _customController.text = currentValue.toString();
                  }
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increment,
              color: const Color(0xffB4B4B4),
            ),
          ],
        ),
        const Divider(
          color: Color(0xffEAEAFF),
          thickness: 2,
          height: 5,
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
