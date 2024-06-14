import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonsConfirmAddresses extends StatefulWidget {
  final ValueChanged<String> action; //callback value change
  final String tag; //tag of button
  final String text;
  final bool active; // state of button
  var address; // address data
  ButtonsConfirmAddresses(
      {required this.action,
      required this.text,
      required this.active,
      required this.address,
      required this.tag});
  @override
  _ButtonsConfirmAddressesState createState() =>
      _ButtonsConfirmAddressesState();
}

class _ButtonsConfirmAddressesState extends State<ButtonsConfirmAddresses> {
  // void handleTap() {
  //   setState(() {
  //     widget.action(widget.tag);
  //   });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
      return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: const Color(0xff000000).withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: ElevatedButton(
          // splashColor: Colors.transparent,
          // highlightColor: Colors.transparent,
          onPressed: () {
            setState(() {
              widget.action(widget.tag);
            });
            jobsViewModel.setInputValues(
                index: 'longitude', value: widget.address['longitude'] ?? '');
            jobsViewModel.setInputValues(
                index: 'latitude', value: widget.address['latitude'] ?? '');
            jobsViewModel.setInputValues(
                index: 'address',
                value: widget.address['state_district'] ?? '');
            jobsViewModel.setInputValues(
                index: 'city', value: widget.address['state_district'] ?? '');
            jobsViewModel.setInputValues(
                index: 'state', value: widget.address['state'] ?? '');
            jobsViewModel.setInputValues(
                index: 'street_name', value: widget.address['road'] ?? '');
            jobsViewModel.setInputValues(
                index: 'postal_code', value: widget.address['postcode'] ?? '');
            jobsViewModel.setInputValues(
                index: 'job_address', value: widget.address ?? '');
          },
          style: ElevatedButton.styleFrom(
            elevation: 0.0,
            shadowColor: Colors.transparent,
            backgroundColor: widget.active
                ? const Color(0xff9E9AB7)
                : context.resources.color.colorWhite,
            // side: BorderSide(
            //   width: 2,
            //   color: widget.active
            //       ? context.resources.color.btnColorBlue
            //       : context.resources.color.colorWhite,
            // ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            fixedSize: Size(
              context.appValues.appSizePercent.w90,
              context.appValues.appSizePercent.h7,
            ),
          ),
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
                    color: widget.active
                        ? context.resources.color.colorWhite
                        : const Color(0xff180C38),
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: widget.active
                    ? context.resources.color.colorWhite
                    : const Color(0xff180C38),
                size: 12,
              ),
            ],
          ),
        ),
      );
    });
  }
}
