// import 'package:dingdone/res/app_context_extension.dart';
// import 'package:dingdone/res/fonts/styles_manager.dart';
// import 'package:flutter/material.dart';

// class TimePickerWidget extends StatefulWidget {
//   const TimePickerWidget({super.key});

//   @override
//   State<TimePickerWidget> createState() => _TimePickerWidgetState();
// }

// class _TimePickerWidgetState extends State<TimePickerWidget> {
//   int selectedIndex = -1;
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: context.appValues.appSizePercent.w90,
//       height: context.appValues.appSizePercent.h5,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           bool isSelected = index == selectedIndex;

//           return InkWell(
//             onTap: () {
//               setState(() {
//                 if (isSelected) {
//                   selectedIndex = -1; // Deselect the item
//                 } else {
//                   selectedIndex = index; // Select the item
//                 }
//               });
//             },
//             child: Container(
//               width: 50,
//               margin: EdgeInsets.only(right: context.appValues.appMargin.m10),
//               color: isSelected ? Color(0xff040542) : Colors.transparent,
//               child: Center(
//                 child: Text(
//                   '$index',
//                   style: getPrimaryRegularStyle(
//                     fontSize: 13,
//                     color: isSelected ? Colors.white : Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TimePickerWidget extends StatefulWidget {
  const TimePickerWidget({Key? key}) : super(key: key);

  @override
  State<TimePickerWidget> createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Consumer<JobsViewModel>(builder: (context, jobsViewModel, _) {

      return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p10,
          ),
          child: SizedBox(
            width: context.appValues.appSizePercent.w90,
            height: context.appValues.appSizePercent.h5,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 24,
              itemBuilder: (context, index) {
                bool isSelected = index == selectedIndex;
                String time = '${index + 0}:00';

                return InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIndex = -1;
                      } else {
                        selectedIndex = index;
                      }
                    });
                    jobsViewModel.setInputValues(
                        index: 'time', value: time);
                    setState(() {
                      // _selectedValue = date;
                    });
                  },
                  child: Container(
                    width: context.appValues.appSizePercent.w14,
                    margin: EdgeInsets.only(right: context.appValues.appMargin.m5),
                    color:
                        isSelected ? const Color(0xff040542) : Colors.transparent,
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          fontSize: 13,
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      }
    );
  }
}
