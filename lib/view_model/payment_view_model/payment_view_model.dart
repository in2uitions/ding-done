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
  bool _isloading=false;
  late ProfileViewModel _profileViewModel;
  late JobsViewModel _jobsViewModel;
  Map<String, dynamic>? paymentIntent;
  PaymentsRepository _paymentsRepository = PaymentsRepository();
  ApiResponse<PaymentsModelMain> _paymentsResponse = ApiResponse.loading();

  List<dynamic> _paymentsList = List.empty();

  Map<String?, String?> paymentError = {};

  PaymentViewModel(ProfileViewModel profileViewModel) {
    _profileViewModel = profileViewModel;
    // getPaymentMethodsTap();
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

  Future<dynamic> getPaymentMethodsTap() async {
    try {
      var response = await http.get(
          Uri.parse(
              'https://api.tap.company/v2/card/${_profileViewModel.getProfileBody["tap_id"]}'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['TAP_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      var res = jsonDecode(response.body);
      debugPrint('response geetting cardn ${res["data"]}');
      return res["data"];
    } catch (e) {
      debugPrint('error in getting payments tap $e');
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

  // Future<void> deletePaymentMethod(dynamic id) async {
  //   Map<String, dynamic> body = {};
  //   body["card_id"] = id.toString();
  //   try {
  //     dynamic response = _paymentsRepository.deletePaymentCard(body);
  //
  //     debugPrint('response deleting card $response');
  //   } catch (e) {
  //     debugPrint('error in deleting payment $e');
  //   }
  // }
  Future<void> deletePaymentMethod(dynamic id) async {
    Map<String, dynamic> body = {};
    body["card_id"] = id.toString();
    try {
      var response =
      await http.delete(Uri.parse('https://api.tap.company/v2/card/${_profileViewModel.getProfileBody["tap_id"]}/${body["card_id"]}'),
          headers: {
            'Authorization': 'Bearer ${dotenv.env['TAP_SECRET']}',
            'Content-Type': 'application/x-www-form-urlencoded'
          });
      var res=jsonDecode(response.body);
      debugPrint('response deleting card $res');
    } catch (e) {
      debugPrint('error in deleting payment $e');
    }
  }
  setLoading(var value) async {
    _isloading=value;
    notifyListeners();
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
  createPaymentIntent(
      String amount, String currency, dynamic payment_method) async {
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
      if (_profileViewModel.getProfileBody["tap_id"] == null) {
        var response1 = await createCustomerTapId();
        body["tap_id"] = '${response1["id"]}';
        bodyattach["customer"] = '${response1["id"]}';
        debugPrint(
            '_profile view model body ${_profileViewModel.getProfileBody}');
        _paymentsRepository.patchCustomerTapId(
            id: _profileViewModel.getProfileBody['id'],
            customer_id: '${response1["id"]}');
      } else {
        bodyattach["customer"] =
            '${_profileViewModel.getProfileBody["tap_id"]}';
      }

      debugPrint('bodyy $body');
    } catch (e) {
      debugPrint('error in create payment $e');
    }
  }

  Future<dynamic> authorizeCard(dynamic body) async {
    try {
      debugPrint('authorizing card body $body');
      dynamic result = await _paymentsRepository.authorizeCard(body: body);
      return result;
    } catch (e) {
      debugPrint('error authorizing card body $e');
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
  get isLoading => _isloading;

  @override
  void disposeValues() {
    // _homeRepository = ProfileRepository();
  }
}
