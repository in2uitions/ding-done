import 'dart:convert';
import 'package:dingdone/data/remote/response/ApiResponse.dart';
import 'package:dingdone/models/payments_model.dart';
import 'package:dingdone/repository/payments/payments_repository.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view_model/dispose_view_model/dispose_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:http/http.dart' as http;
import '../../res/app_validation.dart';
import '../profile_view_model/profile_view_model.dart';

class PaymentViewModel extends DisposableViewModel {
  Map<String, dynamic> paymentBody = {};

  late ProfileViewModel _profileViewModel;
  late JobsViewModel _jobsViewModel;
  Map<String, dynamic>? paymentIntent;
  PaymentsRepository _paymentsRepository = PaymentsRepository();
  ApiResponse<PaymentsModelMain> _paymentsResponse = ApiResponse.loading();

  List<dynamic> _paymentsList = List.empty();

  Map<String?, String?> paymentError = {};

  PaymentViewModel(ProfileViewModel profileViewModel) {
    _profileViewModel = profileViewModel;
    getPaymentMethods();
    // if(_profileViewModel.profileBody["user"]["role"]==Constants.customerRoleId){
    //   getPaymentMethods();
    //
    // }else{
    //   getCustomerPayments(_profileViewModel.profileBody["user"]["id"]);
    // }
  }

  Future<void> readJson() async {}

  get errorMsg => null;

  void setInputValues({required String index, dynamic value}) {
    paymentBody[index] = value;
    debugPrint('payment body ${paymentBody}');
  }

  Future<List<dynamic>?> getPaymentMethods() async {
    try {
      var response = await _paymentsRepository
          .getPayments(int.parse('${_profileViewModel.getProfileBody["id"]}'));
      _paymentsResponse = await ApiResponse.completed(response);
      _paymentsList = _paymentsResponse.data?.toJson()["payments"];
      // notifyListeners();
      return _paymentsList;
    } catch (e) {
      debugPrint('error in getting payments $e');
      return [];
    }
  }

  Future<List<dynamic>?> getCustomerPayments(dynamic customer_id) async {
    try {
      var response = await _paymentsRepository.getPayments(customer_id);
      _paymentsResponse = await ApiResponse.completed(response);
      _paymentsList = _paymentsResponse.data?.toJson()["payments"];
      notifyListeners();
      return _paymentsList;
    } catch (e) {
      debugPrint('error in getting payments $e');
      return [];
    }
  }
  Future<void> deletePaymentMethod(dynamic id) async {
    Map<String, dynamic> body = {};
    body["card_id"] = id.toString();
    try {
      dynamic response = _paymentsRepository.deletePaymentCard(body);

      debugPrint('response deleting card $response');
    } catch (e) {
      debugPrint('error in deleting payment $e');
    }
  }

  displayPaymentSheet() async {
    try {
      // 3. display the payment sheet.
      await Stripe.instance.presentPaymentSheet();

      debugPrint('Payment succesfully completed');
      // Fluttertoast.showToast(msg: 'Payment succesfully completed');
    } on Exception catch (e) {
      if (e is StripeException) {
        debugPrint('Error from Stripe: ${e.error.localizedMessage}');

        // Fluttertoast.showToast(
        //     msg: 'Error from Stripe: ${e.error.localizedMessage}');
      } else {
        debugPrint('Unforeseen error: ${e}');

        // Fluttertoast.showToast(msg: 'Unforeseen error: ${e}');
      }
    }
  }

  Future<void> makePayment() async {
    try {
      //STEP 1: Create Payment Intent
      paymentIntent = await createPaymentIntent1('100', 'USD');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet1();
    } catch (err) {
      throw Exception(err);
    }
  }

  createPaymentIntent1(String amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  displayPaymentSheet1() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Clear paymentIntent variable after successful payment
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
    } catch (e) {
      print('$e');
    }
  }

  Future<void> stripeMakePayment(dynamic payment_card) async {
    try {
      await getCustomerPayments(_profileViewModel.getProfileBody["user"]["id"]);
      debugPrint('payment list $paymentList');
      List<dynamic> filteredPaymentMethods = paymentList
          .where((paymentMethod) =>
      paymentMethod['id'].toString() == payment_card["id"].toString())
          .toList();

      debugPrint('hahahahahah ${filteredPaymentMethods}');

      paymentIntent =
      await createPaymentIntent('100', 'INR', filteredPaymentMethods[0]);
      debugPrint('payment intent $paymentIntent');

      await Stripe.instance
          .initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetails: BillingDetails(
                name:
                '${_profileViewModel.getProfileBody["user"]["first_name"]} ${_profileViewModel.getProfileBody["user"]["last_name"]}',
                email:
                '${_profileViewModel.getProfileBody["user"]["email"]}',
                phone:
                '${_profileViewModel.getProfileBody["user"]["phone_number"]}',

                // address: Address(
                //     city: 'YOUR CITY',
                //     country: 'YOUR COUNTRY',
                //     line1: 'YOUR ADDRESS 1',
                //     line2: 'YOUR ADDRESS 2',
                //     postalCode: 'YOUR PINCODE',
                //     state: 'YOUR STATE')
              ),
              paymentIntentClientSecret: paymentIntent![
              'client_secret'], //Gotten from payment intent
              style: ThemeMode.dark,
              merchantDisplayName: 'Ikay'))
          .then((value) {
        debugPrint('value ${value}');
      });

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (e) {
      debugPrint('error in make payment $e');

      // Fluttertoast.showToast(msg: e.toString());
    }
  }

//create Payment
  createPaymentIntent(String amount, String currency, dynamic payment_method) async {
    try {
      //Request body
      debugPrint('payment body customer ${payment_method["customer"]}');
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        // 'payment_method': payment_method["payment_method_id"],
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // await Stripe.instance.confirmPayment(
      //   paymentIntentClientSecret: payment_method["customer"]["stripe_customer_id"],
      //   // data: payment_method["payment_method_id"]
      // );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

// attach payment method to customer
  attachCustomerToPaymentMethod(dynamic body, dynamic payment_method_id) async {
    try {
      debugPrint('Payment method id $payment_method_id');
      debugPrint('Body attach $body');

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse(
            'https://api.stripe.com/v1/payment_methods/$payment_method_id/attach'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      // await Stripe.instance.confirmPayment(
      //   paymentIntentClientSecret: payment_method["customer"]["stripe_customer_id"],
      //   // data: payment_method["payment_method_id"]
      // );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> createPaymentMethod() async {
    Map<String, dynamic> body = {};
    Map<String, dynamic> bodyattach = {};
    String? cardNumberMessage = '';
    cardNumberMessage =
        AppValidation().cardNumberValidator(paymentBody["card_number"] ?? '');

    if (cardNumberMessage == null || cardNumberMessage == '') {
      try {
        await Stripe.instance.dangerouslyUpdateCardDetails(CardDetails(
          number: '${paymentBody["card_number"]}',
          cvc: '${paymentBody["last_digits"]}',
          expirationMonth: int.parse('${paymentBody["expiry_month"]}'),
          expirationYear: int.parse('${paymentBody["expiry_year"]}'),
        ));
        // paymentIntent = await createPaymentIntent('100', 'INR');
        // debugPrint('payment intent $paymentIntent');

        var response = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
            paymentMethodData: PaymentMethodData(
              billingDetails: BillingDetails(
                name:
                    '${_profileViewModel.getProfileBody["user"]["first_name"]} ${_profileViewModel.getProfileBody["user"]["last_name"]}',
                email: '${_profileViewModel.getProfileBody["user"]["email"]}',
                phone:
                    '${_profileViewModel.getProfileBody["user"]["phone_number"]}',
                // address: Address(
                //   city: 'Houston',
                //   country: 'US',
                //   line1: '1459  Circle Drive',
                //   line2: '',
                //   state: 'Texas',
                //   postalCode: '77063',
                // ),
              ),
            ),
          ),
        );
        debugPrint('response in creating payment card $response');
        //     .then((value) {
        //       debugPrint('value ${value}');
        // });
        body["customer_info"] =
            int.parse('${_profileViewModel.getProfileBody["id"]}');
        body["payment_method_id"] = response.id;
        body["brand"] = response.card.brand;
        body["country"] = response.card.country;
        body["expiry_month"] = response.card.expMonth;
        body["expiry_year"] = response.card.expYear;
        body["funding"] = response.card.funding;
        body["last_digits"] = response.card.last4;
        body["nickname"] = paymentBody["nickname"];
        body["card_number"] = paymentBody["card_number"];

        debugPrint('bodyy $body');

        if (_profileViewModel.getProfileBody["stripe_customer_id"] == null) {
          var response1 = await createCustomerId();
          debugPrint('id of the new customer ${response1["id"]}');
          debugPrint('id of the new customer ${response1["id"]}');
          body["stripe_customer_id"] = '${response1["id"]}';
          bodyattach["customer"] = '${response1["id"]}';
        } else {
          bodyattach["customer"] =
              '${_profileViewModel.getProfileBody["stripe_customer_id"]}';
        }

        debugPrint('bodyy $body');
        await _paymentsRepository.addPaymentCard(body);
        await attachCustomerToPaymentMethod(bodyattach, response.id);
        // await getCustomerPayments(_profileViewModel.getProfileBody["user"]["id"]);
      } catch (e) {
        debugPrint('error in create payment $e');
      }
    } else {
      paymentError['card_number'] = cardNumberMessage;
      notifyListeners();
    }
  }

  Future<void> createPaymentMethodTap() async {
    // setupSDKSession();
    Map<String, dynamic> body = {};
    Map<String, dynamic> bodyattach = {};
    String? cardNumberMessage = '';
    try {
      debugPrint('creating tap payment ');

      body = {
        "card": {
          "number": paymentBody["card_number"],
          "exp_month": paymentBody["expiry_month"],
          "exp_year": paymentBody["expiry_year"],
          "cvc": paymentBody["last_digits"],
          "name": paymentBody["nickname"],
          // "address": {
          //   "country":
          //       "${_profileViewModel.getProfileBody['current_address']['country']}",
          //   // "line1": "Salmiya, 21",
          //   "city":
          //       "${_profileViewModel.getProfileBody['current_address']['city']}",
          //   "street":
          //       "${_profileViewModel.getProfileBody['current_address']['street_name']}",
          //   // "avenue": "Gulf"
          // }
        },

        "client_ip": "192.168.1.20"
      };

      debugPrint('bodyy $body');
      if (_profileViewModel.getProfileBody["stripe_customer_id"] == null) {
        var response1 = await createCustomerTapId();
        debugPrint('done creating customer tap id $response1');
        debugPrint('id of the new customer ${response1["id"]}');
        debugPrint('id of the new customer ${response1["id"]}');
        body["stripe_customer_id"] = '${response1["id"]}';
        bodyattach["customer"] = '${response1["id"]}';
        debugPrint(
            '_profile view model body ${_profileViewModel.getProfileBody}');
        _paymentsRepository.patchCustomerTapId(
            id: _profileViewModel.getProfileBody['id'],
            customer_id: '${response1["id"]}');
      } else {
        bodyattach["customer"] =
            '${_profileViewModel.getProfileBody["stripe_customer_id"]}';
      }

      debugPrint('bodyy $body');

      var response =
          await http.post(Uri.parse('https://api.tap.company/v2/tokens'),
              headers: {
                'Authorization': 'Bearer ${dotenv.env['TAP_SECRET']}',
                'Content-Type': 'application/json',

              },
              body: jsonEncode(body));
      debugPrint('response creating a card ${response.body}');

      // await _paymentsRepository.addPaymentCard(body);
      // await attachCustomerToPaymentMethod(bodyattach, response.id);
      // await getCustomerPayments(_profileViewModel.getProfileBody["user"]["id"]);
    } catch (e) {
      debugPrint('error in create payment $e');
    }
    // }
    // else {
    //   paymentError['card_number'] = cardNumberMessage;
    //   notifyListeners();
    // }
  }
  Future<void> setupSDKSession() async {
    try {
      GoSellSdkFlutter.sessionConfigurations(
        trxMode: TransactionMode.SAVE_CARD,
        transactionCurrency: "kwd",
        amount: 100,
        customer: Customer(
          customerId: "${_profileViewModel.getProfileBody["stripe_customer_id"]}",
          // customer id is important to retrieve cards saved  for this   customer
          firstName:
          '${_profileViewModel.getProfileBody["user"]["first_name"]} ',
          lastName: '${_profileViewModel.getProfileBody["user"]["last_name"]}',
          email: '${_profileViewModel.getProfileBody["user"]["email"]}',
          isdNumber: "965",
          number: "00000000",
          middleName: "test",
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
                  maximumFee: 10,
                  minimumFee: 1,
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
              maximumFee: 10,
              minimumFee: 1,
            ),
            name: "tax1",
            description: "tax description",
          ),
          Tax(
            amount: Amount(
              type: "F",
              value: 10,
              maximumFee: 10,
              minimumFee: 1,
            ),
            name: "tax1",
            description: "tax description",
          ),
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
            amount: 100,
            description: "shipping description 2",
          ),
        ],
        // Post URL
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
            order: "order_262625"),
        // payment Descriptor
        paymentStatementDescriptor: "paymentStatementDescriptor",
        // Save Card Switch
        isUserAllowedToSaveCard: true,
        // Enable/Disable 3DSecure
        isRequires3DSecure: false,
        // Receipt SMS/Email
        receipt: Receipt(true, false),
        // Authorize Action [Capture - Void]
        authorizeAction:
        AuthorizeAction(type: AuthorizeActionType.CAPTURE, timeInHours: 10),
        // Destinations
        destinations: Destinations(
          amount: 100,
          currency: 'kwd',
          count: 2,
          destinationlist: [
            Destination(
                id: "",
                amount: 100,
                currency: "kwd",
                description: "des",
                reference: "ref_121299"),
            Destination(
                id: "",
                amount: 100,
                currency: "kwd",
                description: "des",
                reference: "ref_22444444")
          ],
        ),
        // merchant id
        merchantID: "",
        // Allowed cards
        allowedCadTypes: CardType.ALL,
        applePayMerchantID: "merchant.applePayMerchantID",
        allowsToSaveSameCardMoreThanOnce: false,
        // pass the card holder name to the SDK
        cardHolderName: "Card Holder NAME",
        // disable changing the card holder name by the user
        allowsToEditCardHolderName: false,
        // Supported payment methods List  supportedPaymentMethods: ["knet", "visa"],

        /// SDK Appearance Mode appearanceMode: SDKAppearanceMode.fullscreen,
        paymentType: PaymentType.ALL,
        sdkMode: SDKMode.Sandbox,
      );
      var tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;

      debugPrint('tap sdk result $tapSDKResult');

    } catch(error){
      debugPrint('tap sdk error $error');
    }
  }

//create Customer
  createCustomerId() async {
    try {
      Map<String, dynamic> body = {
        "name":
            '${_profileViewModel.getProfileBody["user"]["first_name"]} ${_profileViewModel.getProfileBody["user"]["last_name"]}',
        "email": '${_profileViewModel.getProfileBody["user"]["email"]}',
        "phone": '${_profileViewModel.getProfileBody["user"]["phone_number"]}',
      };
      //Make post request to Stripe
      var response =
          await http.post(Uri.parse('https://api.stripe.com/v1/customers'),
              headers: {
                'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body);
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  createCustomerTapId() async {
    try {
      Map<String, dynamic> body = {
        "first_name":
            '${_profileViewModel.getProfileBody["user"]["first_name"]} ',
        "last_name": '${_profileViewModel.getProfileBody["user"]["last_name"]}',
        "email": '${_profileViewModel.getProfileBody["user"]["email"]}',
        // "phone": {
        //   "code": "",
        //   "number":
        //       '${_profileViewModel.getProfileBody["user"]["phone_number"]}'
        // },
        // "description": "test",
        // "metadata": {
        //   "sample string 1": "string1",
        //   "sample string 3": "string2"
        // },
        // "currency": ""
      };
      //Make post request to Stripe
      var response =
          await http.post(Uri.parse('https://api.tap.company/v2/customers'),
              headers: {
                'Authorization': 'Bearer ${dotenv.env['TAP_SECRET']}',
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: body);
      debugPrint('response of creating new customer id ${response.body}');
      return json.decode(response.body);
    } catch (err) {
      debugPrint('error of creating new customer id ${err}');

      throw Exception(err.toString());
    }
  }

//calculate Amount
  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  Future<String> getUserId() async {
    try {
      String? token =
          await AppPreferences().get(key: userIdKey, isModel: false);
      return token ?? '';
    } catch (err) {
      return '';
    }
  }

  get getPaymentBody => paymentBody;

  get paymentList => _paymentsList;

  @override
  void disposeValues() {
    // _homeRepository = ProfileRepository();
  }
}
