import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/edit_account/edit_account.dart';
import 'package:dingdone/view/my_address_book/my_address_book.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

class ProfileComponent extends StatefulWidget {
  var payment_method;
  var role;

  ProfileComponent({super.key, this.payment_method, required this.role});

  @override
  State<ProfileComponent> createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //     future: Provider.of<PaymentViewModel>(context, listen: false)
    //         .getPaymentMethodsTap(),
    //     builder: (context, AsyncSnapshot data) {
    //       if (data.connectionState == ConnectionState.done) {
    //         if (data.hasData) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p0,
        context.appValues.appPadding.p20,
        context.appValues.appPadding.p0,
      ),
      child:
          // Container(
          // height: context.appValues.appSizePercent.h17,
          // width: context.appValues.appSizePercent.w100,
          // decoration: BoxDecoration(
          //   boxShadow: [
          //     BoxShadow(
          //       color: Colors.grey.withOpacity(0.5), // Shadow color
          //       spreadRadius: 1, // Spread radius
          //       blurRadius: 5, // Blur radius
          //       offset:
          //           const Offset(0, 2), // changes position of shadow
          //     ),
          //   ],
          //   color: context.resources.color.colorWhite,
          //   borderRadius: const BorderRadius.all(Radius.circular(20)),
          // ),
          // child:
          Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            child: Padding(
              padding: EdgeInsets.only(
                  top: context.appValues.appPadding.p15,
                  left: context.appValues.appPadding.p15,
                  right: context.appValues.appPadding.p15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/img/account.svg',
                      ),
                      const Gap(10),
                      Text(
                        translate('profile.myProfile'),
                        style: getPrimaryRegularStyle(
                          fontSize: 14,
                          color: context.resources.color.btnColorBlue,
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Color(0xff8F9098),
                    size: 12,
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.of(context).push(_createRoute(const EditAccount()));
            },
          ),
          const Gap(30),
          Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.only(
                    top: context.appValues.appPadding.p5,
                    left: context.appValues.appPadding.p15,
                    right: context.appValues.appPadding.p15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/img/address-book.svg',
                          // width: 16,
                          // height: 16,
                        ),
                        const Gap(10),
                        Text(
                          translate('drawer.myAddressBook'),
                          style: getPrimaryRegularStyle(
                            fontSize: 14,
                            color: context.resources.color.btnColorBlue,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xff8F9098),
                      size: 12,
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(_createRoute(const MyaddressBook()));
              },
            );
          }),
          const Gap(30),
          Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
            return InkWell(
              child: Padding(
                padding: EdgeInsets.only(
                    top: context.appValues.appPadding.p5,
                    left: context.appValues.appPadding.p15,
                    right: context.appValues.appPadding.p15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/img/payment-method.svg',
                          // width: 16,
                          // height: 16,
                        ),
                        const Gap(10),
                        Text(
                          translate('profile.paymentMethods'),
                          style: getPrimaryRegularStyle(
                            fontSize: 14,
                            color: context.resources.color.btnColorBlue,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_sharp,
                      color: Color(0xff8F9098),
                      size: 12,
                    ),
                  ],
                ),
              ),
              onTap: () async {
                await Provider.of<PaymentViewModel>(context, listen: false)
                    .getPaymentMethodsTap();
                Navigator.of(context).push(
                  _createRoute(
                    Consumer<ProfileViewModel>(
                        builder: (context, profileViewModel, _) {
                      return ConfirmPaymentMethod(
                        profileViewModel: profileViewModel,
                        payment_method: paymentViewModel
                            .getPaymentBody['tap_payments_card'],
                        paymentViewModel: paymentViewModel,
                        role: widget.role,
                      );
                    }),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}

Route _createRoute(dynamic classname) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => classname,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
