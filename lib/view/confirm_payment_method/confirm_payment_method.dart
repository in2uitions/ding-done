// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:io';

import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/add_new_payment_method.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/card_info.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';

class ConfirmPaymentMethod extends StatefulWidget {
  var payment_method;
  var role;

  var paymentViewModel;
  var profileViewModel;

  ConfirmPaymentMethod(
      {super.key,
      required this.payment_method,
      required this.paymentViewModel,
      required this.profileViewModel,
      required this.role});

  @override
  State<ConfirmPaymentMethod> createState() => _ConfirmPaymentMethodState();
}

class _ConfirmPaymentMethodState extends State<ConfirmPaymentMethod> {
  Map<dynamic, dynamic>? tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode = "";
  String sdkErrorMessage = "";
  String sdkErrorDescription = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // configure app
    configureApp();
    // sdk session configurations
    setupSDKSession();
  }

  // configure app key and bundle-id (You must get those keys from tap)
  Future<void> configureApp() async {
    try{
      debugPrint('configuring app');
      GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid
            ? "com.in2uitions.dingdone"
            : "com.in2uitions.dingdone",
        productionSecretKey:
        Platform.isAndroid ? "sk_live_y1TzabNF6M5pCW3mGPwDVr4L" : "sk_live_y1TzabNF6M5pCW3mGPwDVr4L",
        sandBoxSecretKey:
        Platform.isAndroid
            ? "sk_test_z3V2Wvgo9AiH1qxOUKaZ4mXn"
            : "sk_test_z3V2Wvgo9AiH1qxOUKaZ4mXn",
        lang: "en",
        // bundleId: '23e85@tap',
      );

      // GoSellSdkFlutter.configureApp(
      //   bundleId: Platform.isAndroid? "ANDROID-PACKAGE-NAME" : "IOS-APP-ID",
      //   lang: "en",
      //   productionSecretKey:  Platform.isAndroid? "Android-Live-KEY" : "iOS-Live-KEY",
      //   sandBoxSecretKey:  Platform.isAndroid?"Android-SANDBOX-KEY" : "iOS-SANDBOX-KEY",
      // );
    }catch(error){
      debugPrint('error configuring app $error');

    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> setupSDKSession() async {
    try {
      debugPrint('setup sdk  app');
      debugPrint('setup sdk  app ${widget.profileViewModel.getProfileBody}');

      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.TOKENIZE_CARD,
        transactionCurrency: "QAR",
        amount: 1,
        customer: Customer(
          // customerId: widget.profileViewModel.getProfileBody['stripe_customer_id'],
          customerId:"",
          // customer id is important to retrieve cards saved for this customer
          email: 'rim.zakhour@in2uitions.com',
          isdNumber: "965",
          number: "00000000",
          firstName: 'Rim',
          middleName: "test",
          lastName: 'Zakhour',
          metaData: null,
        ),
        paymentItems: <PaymentItem>[

        ],
        // List of taxes
        taxes: [

        ],
        // List of shipping
        shippings: [

        ],
        postURL: "https://tap.company",
        // Payment description
        paymentDescription: "paymentDescription",
        // Payment Metadata
        paymentMetaData: {
          "a": "a meta",
          "b": "b meta",
        },
        // Payment Reference
        paymentReference: Reference(
          acquirer: "acquirer",
          gateway: "gateway",
          payment: "payment",
          track: "track",
          transaction: "trans_910101",
          order: "order_262625",
        ),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: true,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction:
        AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
        // Destinations
        destinations: null,
        // merchant id
        merchantID: "49941248",
        // Allowed cards
        allowedCadTypes: CardType.ALL,
        applePayMerchantID: "merchant.applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: true,
        // pass the card holder name to the SDK
        cardHolderName: "${widget.profileViewModel.getProfileBody['first_name']} ${widget.profileViewModel.getProfileBody['last_name']}",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: PaymentType.ALL,
        // Supported payment methods List
        supportedPaymentMethods: [
          "VISA",
          "MASTERCARD",
          "AMERICAN_EXPRESS",
          // "knet",
          // "Benefit",
          "GOOGLE_PAY"
        ],
        // Transaction mode
        sdkMode: SDKMode.Sandbox,
        appearanceMode: SDKAppearanceMode.fullscreen,
        googlePayWalletMode: GooglePayWalletMode.ENVIRONMENT_TEST,
      );
    } catch(error) {
      debugPrint('error setting up sdk $error');
      // platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      tapSDKResult = {};
    });
  }

  Future<void> startSDK() async {
    // setState(() {
    //   // loaderController.start();
    // });
    try {
      debugPrint('Start sdk');

      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;

      // loaderController.stopWhenFull();
      debugPrint('SDK Result>>>> ${tapSDKResult?['sdk_result']}');

      setState(() {
        switch (tapSDKResult!['sdk_result']) {
          case "SUCCESS":
            sdkStatus = "SUCCESS";
            handleSDKResult();
            break;
          case "FAILED":
            sdkStatus = "FAILED";
            handleSDKResult();
            break;
          case "CANCELLED":
            sdkStatus = "CANCELLED";
            // handleSDKResult();
            break;
          case "SDK_ERROR":
            debugPrint('sdk error............');
            debugPrint(tapSDKResult!['sdk_error_code']);
            debugPrint(tapSDKResult!['sdk_error_message']);
            debugPrint(tapSDKResult!['sdk_error_description']);
            debugPrint('sdk error............');
            sdkErrorCode = tapSDKResult!['sdk_error_code'].toString();
            sdkErrorMessage = tapSDKResult!['sdk_error_message'] ?? "";
            sdkErrorDescription = tapSDKResult!['sdk_error_description'] ?? "";
            break;

          case "NOT_IMPLEMENTED":
            sdkStatus = "NOT_IMPLEMENTED";
            break;
        }
      });
    }catch(error){
      debugPrint('error starting sdk $error');
    }
  }

  void handleSDKResult() {
    debugPrint('SDK Result>>>> $tapSDKResult');

    debugPrint('Transaction mode>>>> ${tapSDKResult!['trx_mode']}');

    switch (tapSDKResult!['trx_mode']) {
      case "CHARGE":
        printSDKResult('Charge');
        break;

      case "AUTHORIZE":
        printSDKResult('Authorize');
        break;

      case "SAVE_CARD":
        printSDKResult('Save Card');
        break;

      case "TOKENIZE":
        debugPrint('TOKENIZE token : ${tapSDKResult!['token']}');
        debugPrint('TOKENIZE token_currency  : ${tapSDKResult!['token_currency']}');
        debugPrint('TOKENIZE card_first_six : ${tapSDKResult!['card_first_six']}');
        debugPrint('TOKENIZE card_last_four : ${tapSDKResult!['card_last_four']}');
        debugPrint('TOKENIZE card_object  : ${tapSDKResult!['card_object']}');
        debugPrint(
            'TOKENIZE card_holder_name  : ${tapSDKResult!['card_holder_name']}');
        debugPrint('TOKENIZE card_exp_month : ${tapSDKResult!['card_exp_month']}');
        debugPrint('TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');
        debugPrint('TOKENIZE issuer_id    : ${tapSDKResult!['issuer_id']}');
        debugPrint('TOKENIZE issuer_bank    : ${tapSDKResult!['issuer_bank']}');
        debugPrint(
            'TOKENIZE issuer_country    : ${tapSDKResult!['issuer_country']}');
        responseID = tapSDKResult!['token'] ?? "";
        break;
    }
  }

  void printSDKResult(String trxMode) {
    debugPrint('$trxMode status                : ${tapSDKResult!['status']}');
    if (trxMode == "Authorize") {
      debugPrint('$trxMode id              : ${tapSDKResult!['authorize_id']}');
    } else {
      debugPrint('$trxMode id               : ${tapSDKResult!['charge_id']}');
    }
    debugPrint('$trxMode  description        : ${tapSDKResult!['description']}');
    debugPrint('$trxMode  message           : ${tapSDKResult!['message']}');
    debugPrint('$trxMode  card_first_six : ${tapSDKResult!['card_first_six']}');
    debugPrint('$trxMode  card_last_four   : ${tapSDKResult!['card_last_four']}');
    debugPrint('$trxMode  card_object         : ${tapSDKResult!['card_object']}');
    debugPrint('$trxMode  card_id         : ${tapSDKResult!['card_id']}');
    debugPrint('$trxMode  card_brand          : ${tapSDKResult!['card_brand']}');
    debugPrint('$trxMode  card_exp_month  : ${tapSDKResult!['card_exp_month']}');
    debugPrint('$trxMode  card_exp_year: ${tapSDKResult!['card_exp_year']}');
    debugPrint('$trxMode  acquirer_id  : ${tapSDKResult!['acquirer_id']}');
    debugPrint("$trxMode payment agreement : ${tapSDKResult!['payment_agreement']}");
    debugPrint(
        '$trxMode  acquirer_response_code : ${tapSDKResult!['acquirer_response_code']}');
    debugPrint(
        '$trxMode  acquirer_response_message: ${tapSDKResult!['acquirer_response_message']}');
    debugPrint('$trxMode  source_id: ${tapSDKResult!['source_id']}');
    debugPrint('$trxMode  source_channel     : ${tapSDKResult!['source_channel']}');
    debugPrint('$trxMode  source_object      : ${tapSDKResult!['source_object']}');
    debugPrint(
        '$trxMode source_payment_type : ${tapSDKResult!['source_payment_type']}');

    if (trxMode == "Authorize") {
      responseID = tapSDKResult!['authorize_id'] ?? "";
    } else {
      responseID = tapSDKResult!['charge_id'] ?? "";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer3<ProfileViewModel, JobsViewModel, PaymentViewModel>(builder:
        (context, profileViewModel, jobsViewModel, paymentViewModel, _) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              padding: EdgeInsets.zero,
              children: [
                SafeArea(
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                        context.appValues.appPadding.p20,
                        context.appValues.appPadding.p10,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            child: SvgPicture.asset('assets/img/back.svg'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: context.appValues.appPadding.p20),
                  child: Text(
                    translate('paymentMethod.confirmPaymentMethod'),
                    style: getPrimaryRegularStyle(
                        color: context.resources.color.btnColorBlue,
                        fontSize: 32),
                  ),
                ),
                const Gap(30),
                const CardInfo1(),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.appValues.appPadding.p20,
                    vertical: context.appValues.appPadding.p20,
                  ),
                  child: Text(
                    translate('paymentMethod.addPaymentMethod'),
                    style: getPrimaryRegularStyle(
                        fontSize: 28,
                        color: context.resources.color.btnColorBlue),
                  ),
                ),
                AddNewPaymentMethodWidget(
                    payment_method: widget.payment_method),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                    context.appValues.appPadding.p20,
                  ),
                  child: Text(
                    translate('paymentMethod.paymentMethods'),
                    style: getPrimaryRegularStyle(
                        fontSize: 28,
                        color: context.resources.color.btnColorBlue),
                  ),
                ),
                PaymentMethodButtons(
                  payment_method: widget.payment_method,
                  jobsViewModel: jobsViewModel,
                  fromWhere: 'confirm_payment',
                  role: widget.role,
                ),
                const Gap(60),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: context.appValues.appSizePercent.h10,
                width: context.appValues.appSizePercent.w100,
                // decoration: BoxDecoration(
                //   borderRadius: const BorderRadius.only(
                //       topLeft: Radius.circular(20),
                //       topRight: Radius.circular(20)),
                //   color: context.resources.color.btnColorBlue,
                // ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: context.appValues.appPadding.p10,
                    horizontal: context.appValues.appPadding.p15,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: context.appValues.appSizePercent.w90,
                        height: context.appValues.appSizePercent.h100,
                        child: ElevatedButton(
                          onPressed: () async {
                            dynamic payments = await widget.paymentViewModel
                                .getPaymentMethods();
                            debugPrint('widget payment ${payments}');
                            var found = false;
                            if(payments.isNotEmpty){
                              for (var payment in payments) {
                                if (payment['card_number'] ==
                                    widget.paymentViewModel
                                        .getPaymentBody['card_number']) {
                                  found = true;
                                }
                              }
                            }

                            if (!found) {
                              await widget.paymentViewModel
                                  .createPaymentMethodTap();
                              startSDK();
                              await widget.paymentViewModel.getPaymentMethods();
                              Navigator.of(context).pop();
                              Future.delayed(
                                  const Duration(seconds: 0),
                                  () => Navigator.of(context).push(
                                          _createRoute(ConfirmPaymentMethod(
                                        payment_method: widget.payment_method,
                                        paymentViewModel:
                                            widget.paymentViewModel,
                                        role: Constants.customerRoleId,
                                            profileViewModel: widget.profileViewModel,
                                      ))));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      simpleAlert(
                                          context,
                                          translate('button.failure'),
                                          'Card Number is already chosen'));
                            }

                            },
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: const Color(0xff4100E3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            translate('paymentMethod.addPaymentMethod'),
                            style: getPrimaryRegularStyle(
                              fontSize: 18,
                              color: context.resources.color.colorWhite,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

Widget simpleAlert(BuildContext context, String message, String message2) {
  return AlertDialog(
    elevation: 15,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: context.appValues.appPadding.p8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                child: SvgPicture.asset('assets/img/x.svg'),
                onTap: () {
                  Navigator.pop(context);
                  Future.delayed(const Duration(seconds: 0),
                      () => Navigator.of(context).pop());
                },
              ),
            ],
          ),
        ),
        message == 'Success'
            ? SvgPicture.asset('assets/img/service-popup-image.svg')
            : SvgPicture.asset('assets/img/failure.svg'),
        SizedBox(height: context.appValues.appSize.s40),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.appValues.appPadding.p32,
          ),
          child: Text(
            message2,
            textAlign: TextAlign.center,
            style: getPrimaryRegularStyle(
              fontSize: 17,
              color: context.resources.color.btnColorBlue,
            ),
          ),
        ),
        SizedBox(height: context.appValues.appSize.s20),
      ],
    ),
  );
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
