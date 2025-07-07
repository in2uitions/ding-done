import 'package:flutter/material.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';

class CustomIncrementFieldRequest extends StatefulWidget {
  const CustomIncrementFieldRequest({
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
    this.editable,
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
  final bool? editable;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onTap;
  final TextInputType keyboardType;

  @override
  _CustomIncrementFieldRequestState createState() =>
      _CustomIncrementFieldRequestState();
}

class _CustomIncrementFieldRequestState
    extends State<CustomIncrementFieldRequest> {
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
    // Keeping the listener in case the viewModel needs to know the updates.
    _customController.addListener(() {
      widget.viewModel(index: widget.index, value: _customController.text);
    });
  }

  void _increment() {
    if (widget.editable != null && widget.editable!) {
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
  }

  void _decrement() {
    if (widget.editable != null && widget.editable!) {
      // Preserve the lower bound (original value) if provided.
      final lowerBound = widget.value != null ? int.parse(widget.value!) : 0;
      if (currentValue > lowerBound) {
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
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                _customController.text,
                textAlign: TextAlign.center,
                style: getPrimaryRegularStyle(
                  color: const Color(0xff78789D),
                  fontSize: 15,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: _increment,
              color: const Color(0xffB4B4B4),
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
