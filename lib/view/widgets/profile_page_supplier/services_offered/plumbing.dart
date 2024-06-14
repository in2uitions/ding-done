import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class PlumbingServicesOfferedWidget extends StatefulWidget {
  const PlumbingServicesOfferedWidget({super.key});

  @override
  State<PlumbingServicesOfferedWidget> createState() =>
      _PlumbingServicesOfferedWidgetState();
}

class _PlumbingServicesOfferedWidgetState
    extends State<PlumbingServicesOfferedWidget> {
  bool value1 = false;
  bool value2 = false;
  bool value3 = false;
  bool value4 = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.appValues.appPadding.p10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plumbing',
            style: getPrimaryRegularStyle(
              fontSize: 15,
              color: context.resources.color.btnColorBlue,
            ),
          ),
          Row(
            children: [
              Checkbox(
                value: this.value1,
                activeColor: context.resources.color.btnColorBlue,
                onChanged: (bool? value1) {
                  setState(() {
                    this.value1 = value1!;
                  });
                },
              ),
              Text(
                'Leaks repair',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: this.value2,
                activeColor: context.resources.color.btnColorBlue,
                onChanged: (bool? value2) {
                  setState(() {
                    this.value2 = value2!;
                  });
                },
              ),
              Text(
                'Drainage unblock',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: this.value3,
                activeColor: context.resources.color.btnColorBlue,
                onChanged: (bool? value3) {
                  setState(() {
                    this.value3 = value3!;
                  });
                },
              ),
              Text(
                'Toilet repair',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: this.value4,
                activeColor: context.resources.color.btnColorBlue,
                onChanged: (bool? value4) {
                  setState(() {
                    this.value4 = value4!;
                  });
                },
              ),
              Text(
                'Pipe replacement',
                style: getPrimaryRegularStyle(
                  fontSize: 15,
                  color: context.resources.color.secondColorBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
