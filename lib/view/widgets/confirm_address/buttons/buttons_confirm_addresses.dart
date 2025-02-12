import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonsConfirmAddresses extends StatefulWidget {
  final ValueChanged<String> action;
  final String tag;
  final String text;
  final bool active;
  final Map<String, dynamic> address;

  ButtonsConfirmAddresses({
    required this.action,
    required this.text,
    required this.active,
    required this.address,
    required this.tag,
  });

  @override
  _ButtonsConfirmAddressesState createState() => _ButtonsConfirmAddressesState();
}

class _ButtonsConfirmAddressesState extends State<ButtonsConfirmAddresses> {
  void handleTap() {
    setState(() {
      widget.action(widget.tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          setState(() {
            widget.action(widget.tag);
          });
          jobsViewModel.setInputValues(index: 'longitude', value: widget.address['longitude'] ?? '');
          jobsViewModel.setInputValues(index: 'latitude', value: widget.address['latitude'] ?? '');
          jobsViewModel.setInputValues(index: 'address', value: widget.address['state_district'] ?? '');
          jobsViewModel.setInputValues(index: 'city', value: widget.address['state_district'] ?? '');
          jobsViewModel.setInputValues(index: 'state', value: widget.address['state'] ?? '');
          jobsViewModel.setInputValues(index: 'street_name', value: widget.address['road'] ?? '');
          jobsViewModel.setInputValues(index: 'postal_code', value: widget.address['postcode'] ?? '');
          jobsViewModel.setInputValues(index: 'job_address', value: widget.address ?? '');
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Container(
            decoration: BoxDecoration(
              color: widget.active ? context.resources.color.btnColorBlue.withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              // border: Border.all(
              //   color: widget.active ? context.resources.color.btnColorBlue : const Color(0xffEDF1F7),
              //   width: 2,
              // ),
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: context.appValues.appSizePercent.w70,
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: getPrimaryRegularStyle(
                      fontSize: 18,
                      color: widget.active ? Colors.white : const Color(0xff180C38),
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: widget.active ? Colors.white : const Color(0xff180C38),
                  size: 12,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
