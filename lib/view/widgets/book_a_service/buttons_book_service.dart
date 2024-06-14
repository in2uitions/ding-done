import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view/widgets/book_a_service/buttons/button_no_radius.dart';
// import 'package:dingdone/view/widgets/book_a_service/buttons/button_no_radius.dart';
import 'package:dingdone/view/widgets/book_a_service/buttons/buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ButtonsBookService extends StatefulWidget {
  const ButtonsBookService({super.key});

  @override
  State<ButtonsBookService> createState() => _ButtonsBookServiceState();
}

class _ButtonsBookServiceState extends State<ButtonsBookService> {
  String? _active;

  void active(String btn) {
    setState(() => _active = btn);
  }

  @override
  void initState() {
    active('minor');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: context.appValues.appPadding.p20,
        vertical: context.appValues.appPadding.p20,
      ),
      child: Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ThreeButtons(
              action: active, //pass data from child to parent
              tag: "minor", //specifies attribute of button
              active: _active == "minor"
                  ? true
                  : false, //set button active based on value in this parent
              text: 'Minor',
              jobsViewModel: jobsViewModel,
            ),
            // const VerticalDivider(
            //   width: 5,
            //   thickness: 0,
            //   indent: 0,
            //   endIndent: 0,
            //   color: Color(0xffEDF1F7),
            //   // color: Colors.red,
            // ),
            ThreeButtons(
              action: active,
              tag: "medium",
              active: _active == "medium" ? true : false,
              text: 'Medium',
              jobsViewModel: jobsViewModel,
            ),
            // const VerticalDivider(
            //   width: 5,
            //   thickness: 0,
            //   indent: 0,
            //   endIndent: 0,
            //   color: Color(0xffEDF1F7),
            //   // color: Colors.red,
            // ),
            ThreeButtons(
              action: active,
              tag: "major",
              active: _active == "major" ? true : false,
              text: 'Major',
              jobsViewModel: jobsViewModel,
            ),
          ],
        );
      }),
    );
  }
}
