import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/edit_account/edit_account.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
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
    return FutureBuilder(
        future: Provider.of<PaymentViewModel>(context, listen: false)
            .getPaymentMethods(),
        builder: (context, AsyncSnapshot data) {
          if (data.connectionState == ConnectionState.done) {
            if (data.hasData) {
              return Padding(
                padding: EdgeInsets.fromLTRB(
                  context.appValues.appPadding.p20,
                  context.appValues.appPadding.p15,
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
                                // Container(
                                //   width: 40,
                                //   height: 40,
                                //   decoration: BoxDecoration(
                                //       borderRadius: const BorderRadius.all(
                                //         Radius.circular(50),
                                //       ),
                                //       color: context.resources.color
                                //           .btnColorBlue),
                                //   child: Align(
                                //     alignment: Alignment.center,
                                //     child: SvgPicture.asset(
                                //       'assets/img/account.svg',
                                //       width: 16,
                                //       height: 16,
                                //     ),
                                //   ),
                                // ),
                                SvgPicture.asset(
                                  'assets/img/account.svg',
                                  // width: 16,
                                  // height: 16,
                                ),
                                const Gap(10),
                                Text(
                                  translate('profile.account'),
                                  style: getPrimaryRegularStyle(
                                    fontSize: 20,
                                    color: const Color(0xff1F1F39),
                                  ),
                                ),
                              ],
                            ),
                            // SvgPicture.asset('assets/img/right-arrow.svg'),
                          ],
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context)
                            .push(_createRoute(const EditAccount()));
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: context.appValues.appPadding.p15,
                        right: context.appValues.appPadding.p100,
                      ),
                      child: const Divider(
                        height: 50,
                        thickness: 2,
                        color: Color(0xffEAEAFF),
                      ),
                    ),
                    Consumer<PaymentViewModel>(
                        builder: (context, paymentViewModel, _) {
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
                                  // Container(
                                  //   width: 40,
                                  //   height: 40,
                                  //   decoration: BoxDecoration(
                                  //       borderRadius: const BorderRadius.all(
                                  //         Radius.circular(50),
                                  //       ),
                                  //       color: context
                                  //           .resources.color.btnColorBlue),
                                  //   child: Align(
                                  //     alignment: Alignment.center,
                                  //     child: SvgPicture.asset(
                                  //       'assets/img/credit-card.svg',
                                  //       width: 16,
                                  //       height: 16,
                                  //     ),
                                  //   ),
                                  // ),
                                  SvgPicture.asset(
                                    'assets/img/payment-method.svg',
                                    // width: 16,
                                    // height: 16,
                                  ),
                                  const Gap(10),
                                  Text(
                                    translate('profile.paymentMethods'),
                                    style: getPrimaryRegularStyle(
                                      fontSize: 20,
                                      color: const Color(0xff1F1F39),
                                    ),
                                  ),
                                ],
                              ),
                              // SvgPicture.asset('assets/img/right-arrow.svg'),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(_createRoute(ConfirmPaymentMethod(
                            payment_method: data.data,
                            paymentViewModel: paymentViewModel,
                            role: widget.role,
                          )));
                        },
                      );
                    }),
                    // Padding(
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: context.appValues.appPadding.p15),
                    //   child: const Divider(
                    //     height: 20,
                    //     thickness: 2,
                    //     color: Color(0xffEDF1F7),
                    //   ),
                    // ),
                    // Padding(
                    //     padding: EdgeInsets.only(
                    //         top: context.appValues.appPadding.p5,
                    //         left: context.appValues.appPadding.p15,
                    //         right: context.appValues.appPadding.p15),
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       children: [
                    //         Row(
                    //           children: [
                    //             Container(
                    //               width: 40,
                    //               height: 40,
                    //               decoration: BoxDecoration(
                    //                   borderRadius: const BorderRadius.all(
                    //                     Radius.circular(50),
                    //                   ),
                    //                   color: context.resources.color
                    //                       .btnColorBlue),
                    //               child: Align(
                    //                 alignment: Alignment.center,
                    //                 child: SvgPicture.asset(
                    //                   'assets/img/bell.svg',
                    //                   width: 16,
                    //                   height: 16,
                    //                 ),
                    //               ),
                    //             ),
                    //             SizedBox(width: context.appValues.appSize.s10),
                    //             Text(
                    //               translate('profile.notifications'),
                    //               style: getPrimaryRegularStyle(
                    //                   fontSize: 20,
                    //                   color: context.resources.color
                    //                       .btnColorBlue),
                    //             ),
                    //           ],
                    //         ),
                    //         // SvgPicture.asset('assets/img/right-arrow.svg'),
                    //       ],
                    //     )),
                  ],
                ),
                // ),
              );
            } else if (data.hasError) {
              return Container(
                child: Text(translate('button.error')),
              );
            }
          }
          return Container();
        });
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
