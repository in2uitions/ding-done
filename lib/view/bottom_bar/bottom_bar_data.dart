import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/login/login.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBarData extends StatefulWidget {
  const BottomBarData({Key? key}) : super(key: key);

  @override
  State<BottomBarData> createState() => _BottomBarDataState();
}

class _BottomBarDataState extends State<BottomBarData> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          Provider.of<LoginViewModel>(context, listen: false).isActiveUser(),
      builder: (context, AsyncSnapshot data) {
        if (data.hasData) {
          debugPrint('data . data ${data.data}');
          return BottomBar(userRole: data.data.role, currentTab: 0,);
        } else if (data.hasError) {
          return LoginScreen();
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
