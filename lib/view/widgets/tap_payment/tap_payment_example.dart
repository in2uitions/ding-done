import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
// import 'package:go_sell_sdk_flutter_example/tap_loader/awesome_loader.dart';


class TapPaymentExample extends StatefulWidget {
  var profileViewModel;
  TapPaymentExample({super.key,required this.profileViewModel});

  @override
  _TapPaymentExampleState createState() => _TapPaymentExampleState();
}

class _TapPaymentExampleState extends State<TapPaymentExample> {
  Map<dynamic, dynamic>? tapSDKResult;
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode = "";
  String sdkErrorMessage = "";
  String sdkErrorDescription = "";
  // AwesomeLoaderController loaderController = AwesomeLoaderController();

  @override
  void initState() {
    super.initState();
    configureSDK();
  }

  // configure SDK
  Future<void> configureSDK() async {
    // configure app
    configureApp();
    // sdk session configurations
    setupSDKSession();
  }

  // configure app key and bundle-id (You must get those keys from tap)
  Future<void> configureApp() async {
    try{
      GoSellSdkFlutter.configureApp(
        bundleId: Platform.isAndroid
            ? "com.in2uitions.dingdone"
            : "com.in2uitions.dingdone",
        productionSecretKey:
        Platform.isAndroid ? "sk_live_y1TzabNF6M5pCW3mGPwDVr4L" : "sk_live_y1TzabNF6M5pCW3mGPwDVr4L",
        sandBoxSecretKey:
        Platform.isAndroid
            ? "sk_test_MsZe1YiJK3qFgGLdfQxvTUIh"
            : "sk_test_MsZe1YiJK3qFgGLdfQxvTUIh",
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
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.SAVE_CARD,
        transactionCurrency: "USD",
        amount: 0,
        customer: Customer(
          customerId: widget.profileViewModel.getProfileBody['stripe_customer_id'],
          // customer id is important to retrieve cards saved for this customer
          email: widget.profileViewModel.getProfileBody['email'],
          isdNumber: "965",
          number: "00000000",
          firstName: widget.profileViewModel.getProfileBody['first_name'],
          middleName: "test",
          lastName: widget.profileViewModel.getProfileBody['last_name'],
          metaData: null,
        ),
        paymentItems: <PaymentItem>[
          PaymentItem(
            name: "item1",
            amountPerUnit: 1,
            quantity: Quantity(value: 1),
            discount: {
              "type": "F",
              "value": 10,
              "maximum_fee": 10,
              "minimum_fee": 1
            },
            description: "Item 1 Apple",
            taxes: [
              Tax(
                amount: Amount(
                  type: "F",
                  value: 10,
                  minimumFee: 1,
                  maximumFee: 10,
                ),
                name: "tax1",
                description: "tax description",
              )
            ],
            totalAmount: 100,
          ),
        ],
        // List of taxes
        taxes: [
          Tax(
            amount: Amount(
              type: "F",
              value: 10,
              minimumFee: 1,
              maximumFee: 10,
            ),
            name: "tax1",
            description: "tax description",
          ),
          Tax(
            amount: Amount(
              type: "F",
              value: 10,
              minimumFee: 1,
              maximumFee: 10,
            ),
            name: "tax1",
            description: "tax description",
          )
        ],
        // List of shipping
        shippings: [
          Shipping(
            name: "shipping 1",
            amount: 100,
            description: "shipping description 1",
          ),
          Shipping(
            name: "shipping 2",
            amount: 150,
            description: "shipping description 2",
          )
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
        cardHolderName: "Card Holder NAME",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: true,
        // select payments you need to show [Default is all, and you can choose between WEB-CARD-APPLEPAY ]
        paymentType: PaymentType.ALL,
        // Supported payment methods List
        supportedPaymentMethods: [
          "VISA",
          "MASTERCARD",
          "AMERICAN_EXPRESS",
          "knet",
          "Benefit",
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
        print('TOKENIZE token : ${tapSDKResult!['token']}');
        print('TOKENIZE token_currency  : ${tapSDKResult!['token_currency']}');
        print('TOKENIZE card_first_six : ${tapSDKResult!['card_first_six']}');
        print('TOKENIZE card_last_four : ${tapSDKResult!['card_last_four']}');
        print('TOKENIZE card_object  : ${tapSDKResult!['card_object']}');
        print(
            'TOKENIZE card_holder_name  : ${tapSDKResult!['card_holder_name']}');
        print('TOKENIZE card_exp_month : ${tapSDKResult!['card_exp_month']}');
        print('TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');
        print('TOKENIZE issuer_id    : ${tapSDKResult!['issuer_id']}');
        print('TOKENIZE issuer_bank    : ${tapSDKResult!['issuer_bank']}');
        print(
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
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned(
                top: 300,
                left: 18,
                right: 18,
                child: Text(
                  "Status: [$sdkStatus $responseID ]",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 15.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Positioned(
                bottom: Platform.isIOS ? 0 : 10,
                left: 18,
                right: 18,
                child: SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    clipBehavior: Clip.hardEdge,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2ace00),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: startSDK,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 25,
                          height: 25,
                          // child: AwesomeLoader(
                          //   outerColor: Colors.white,
                          //   innerColor: Colors.white,
                          //   strokeWidth: 3.0,
                          //   controller: loaderController,
                          // ),
                          child:Container()
                        ),
                        Spacer(),
                        Text(
                          'PAY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}