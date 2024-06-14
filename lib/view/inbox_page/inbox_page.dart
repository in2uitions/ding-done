import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEFEFE),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          SafeArea(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(context.appValues.appPadding.p20),
                child: InkWell(
                  child: SvgPicture.asset('assets/img/back.svg'),
                  onTap: () {
                    // Navigator.pop(context);
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: context.appValues.appPadding.p20),
            child: Text(
              translate('inbox.inbox'),
              style: getPrimaryRegularStyle(
                  color: context.resources.color.btnColorBlue, fontSize: 32),
            ),
          ),
        ],
      ),
    );
  }
}
