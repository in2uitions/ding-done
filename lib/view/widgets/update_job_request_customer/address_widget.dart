import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AddressWidget extends StatefulWidget {
  var address;

  AddressWidget({super.key, required this.address});

  @override
  State<AddressWidget> createState() => _AddressWidgetState();
}

class _AddressWidgetState extends State<AddressWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p10,
      ),
      child: SizedBox(
        width: context.appValues.appSizePercent.w90,
        // height: context.appValues.appSizePercent.h10,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(15),
        //   color: Colors.white,
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p10,
                context.appValues.appPadding.p0,
                context.appValues.appPadding.p0,
              ),
              child: Text(
                translate('formHints.location'),
                style: getPrimaryBoldStyle(
                  fontSize: 20,
                  color: const Color(0xff38385E),
                ),
              ),
            ),
            SizedBox(
              width: context.appValues.appSizePercent.w100,
              child: Text(
                '${widget.address}',
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: getPrimaryRegularStyle(
                  fontSize: 18,
                  color: const Color(0xff78789D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
