import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';

class ElectricalServicesOfferedWidget extends StatefulWidget {
  const ElectricalServicesOfferedWidget({super.key});

  @override
  State<ElectricalServicesOfferedWidget> createState() =>
      _ElectricalServicesOfferedWidgetState();
}

class _ElectricalServicesOfferedWidgetState
    extends State<ElectricalServicesOfferedWidget> {
  bool value1 = false;
  bool value2 = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.appValues.appPadding.p10,
        context.appValues.appPadding.p5,
        context.appValues.appPadding.p10,
        context.appValues.appPadding.p10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Electrical',
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
                'Changing lamp fixture',
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
                'Other',
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
