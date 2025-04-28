import 'dart:io';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/card_info.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class ConfirmPaymentMethod extends StatefulWidget {
  final dynamic payment_method;
  final dynamic role;
  final PaymentViewModel paymentViewModel;
  final ProfileViewModel profileViewModel;

  ConfirmPaymentMethod({
    super.key,
    required this.payment_method,
    required this.paymentViewModel,
    required this.profileViewModel,
    required this.role,
  });

  @override
  State<ConfirmPaymentMethod> createState() => _ConfirmPaymentMethodState();
}

class _ConfirmPaymentMethodState extends State<ConfirmPaymentMethod> {
  Map<dynamic, dynamic>? tapSDKResult;
  late final WebViewController _controller;
  String responseID = "";
  bool sdkLoading = false;

  @override
  void initState() {
    super.initState();
    configureApp();
    setupSDKSession();
  }

  Future<void> configureApp() async {
    try {
      GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid
            ? "com.in2uitions.dingdone"
            : "com.in2uitions.dingdone",
        productionSecretKey: Platform.isAndroid
            ? "sk_live_y1TzabNF6M5pCW3mGPwDVr4L"
            : "sk_live_y1TzabNF6M5pCW3mGPwDVr4L",
        sandBoxSecretKey: Platform.isAndroid
            ? "sk_test_z3V2Wvgo9AiH1qxOUKaZ4mXn"
            : "sk_test_z3V2Wvgo9AiH1qxOUKaZ4mXn",
        lang: "en",
      );
    } catch (error) {
      debugPrint('error configuring app $error');
    }
  }

  Future<void> setupSDKSession() async {
    try {
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.TOKENIZE_CARD,
        transactionCurrency: "QAR",
        amount: 1,
        customer: Customer(
          customerId: widget.profileViewModel.getProfileBody['tap_id'] ?? "",
          email: '${widget.profileViewModel.getProfileBody['user']['email']}',
          isdNumber: "961",
          number:
              '${widget.profileViewModel.getProfileBody['user']['phone_number']}',
          firstName:
              '${widget.profileViewModel.getProfileBody['user']['first_name']}',
          middleName: "",
          lastName:
              '${widget.profileViewModel.getProfileBody['user']['last_name']}',
        ),
        paymentItems: <PaymentItem>[],
        taxes: [],
        shippings: [],
        postURL: "https://tap.company",
        paymentDescription: "Save Card",
        paymentMetaData: {"a": "a meta", "b": "b meta"},
        paymentReference: Reference(
          acquirer: "acquirer",
          gateway: "gateway",
          payment: "payment",
          track: "track",
          transaction: "trans_910101",
          order: "order_262625",
        ),
        paymentStatementDescriptor: "paymentStatementDescriptor",
        isUserAllowedToSaveCard: true,
        isRequires3DSecure: true,
        receipt: Receipt(true, false),
        authorizeAction: AuthorizeAction(
          type: AuthorizeActionType.CAPTURE,
          timeInHours: 10,
        ),
        merchantID: "49941248",
        allowedCadTypes: CardType.ALL,
        applePayMerchantID: "merchant.applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: true,
        cardHolderName:
            "${widget.profileViewModel.getProfileBody['user']['first_name']} ${widget.profileViewModel.getProfileBody['user']['last_name']}",
        allowsToEditCardHolderName: true,
        paymentType: PaymentType.ALL,
        supportedPaymentMethods: [
          "VISA",
          "MASTERCARD",
          "AMERICAN_EXPRESS",
          "GOOGLE_PAY",
        ],
        sdkMode: SDKMode.Sandbox,
        appearanceMode: SDKAppearanceMode.fullscreen,
        googlePayWalletMode: GooglePayWalletMode.ENVIRONMENT_TEST,
      );
    } catch (error) {
      debugPrint('error setting up sdk $error');
    }
    if (mounted) setState(() => tapSDKResult = {});
  }

  Future<void> startSDK() async {
    setState(() => sdkLoading = true);
    tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
    await widget.paymentViewModel.getPaymentMethodsTap();
    dynamic result = await widget.paymentViewModel.authorizeCard(tapSDKResult);
    setState(() => sdkLoading = false);
    // handle navigation or errors...
  }

  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileViewModel, JobsViewModel, PaymentViewModel>(
      builder: (context, profileVM, jobsVM, payVM, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Container(
                width: context.appValues.appSizePercent.w100,
                height: context.appValues.appSizePercent.h50,
                decoration: const BoxDecoration(
                  color: Color(0xff4100E3),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20,
                      vertical: context.appValues.appPadding.p10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_sharp,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        const Gap(10),
                        Text(
                          translate('profile.paymentMethods'),
                          style: getPrimarySemiBoldStyle(
                            color: context.resources.color.colorWhite,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.85,
                minChildSize: 0.85,
                maxChildSize: 1,
                builder: (context, scrollController) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Color(0xffFEFEFE),
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            children: [
                              const Gap(20),
                              const CardInfo1(),
                              const Gap(20),
                              PaymentMethodButtons(
                                payment_method: widget.payment_method,
                                jobsViewModel: jobsVM,
                                fromWhere: 'confirm_payment',
                                role: widget.role,
                              ),
                              const Gap(10),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Divider(
                              color: Color(0xffD4D6DD),
                              thickness: 1,
                            ),
                            const Gap(10),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.appValues.appPadding.p20,
                                vertical: context.appValues.appPadding.p10,
                              ),
                              child: Container(
                                height: context.appValues.appSizePercent.h6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0xff4100E3),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    await payVM.setLoading(true);
                                    dynamic methods =
                                        await payVM.getPaymentMethodsTap();
                                    var exists = payVM.paymentList.any((c) =>
                                        c['card_number'] ==
                                        payVM.getPaymentBody['card_number']);
                                    if (!exists) {
                                      await payVM.createPaymentMethodTap();
                                      await startSDK();
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (_) => simpleAlert(
                                          context,
                                          translate('button.failure'),
                                          'Card Number is already chosen',
                                        ),
                                      );
                                    }
                                    await payVM.setLoading(false);
                                  },
                                  child: Center(
                                    child: payVM.isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white)
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.add,
                                                  color: Colors.white,
                                                  size: 18),
                                              const Gap(5),
                                              Text(
                                                translate(
                                                    'paymentMethod.addPaymentMethod'),
                                                style: getPrimaryBoldStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SafeArea(child: SizedBox()),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Widget simpleAlert(BuildContext context, String title, String message) {
  return AlertDialog(
    backgroundColor: Colors.white,
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            InkWell(
              onTap: () => Navigator.pop(context),
              child: SvgPicture.asset('assets/img/x.svg'),
            ),
          ],
        ),
        const Gap(20),
        title == 'Success'
            ? SvgPicture.asset('assets/img/service-popup-image.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        const Gap(20),
        Text(
          message,
          textAlign: TextAlign.center,
          style: getPrimaryRegularStyle(
            fontSize: 17,
            color: context.resources.color.btnColorBlue,
          ),
        ),
      ],
    ),
  );
}

class NavigationControls extends StatelessWidget {
  const NavigationControls({super.key, required this.webViewController});
  final WebViewController webViewController;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () async {
            if (await webViewController.canGoBack()) {
              await webViewController.goBack();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No back history item')),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (await webViewController.canGoForward()) {
              await webViewController.goForward();
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No forward history item')),
              );
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.replay),
          onPressed: () => webViewController.reload(),
        ),
      ],
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
