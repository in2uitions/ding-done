import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/widgets/custom/custom_dropdown.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:card_scanner/card_scanner.dart';

import '../../../res/app_validation.dart';
import '../../../res/fonts/styles_manager.dart';

class AddNewPaymentMethodWidget extends StatefulWidget {
  var payment_method;

  AddNewPaymentMethodWidget({super.key, required this.payment_method});

  @override
  State<AddNewPaymentMethodWidget> createState() =>
      _AddNewPaymentMethodWidgetState();
}

class _AddNewPaymentMethodWidgetState extends State<AddNewPaymentMethodWidget> {
  var card = ScannedCardModel();

  // final ScannerWidgetController _controller = ScannerWidgetController();

  @override
  void initState() {
    super.initState();

  }
  // Function to get the expiry year list
  List<Map<String, String>> getExpiryYears() {
    final currentYear = DateTime.now().year;
    final currentYearShort = int.parse(DateFormat('yy').format(DateTime.now())); // Last 2 digits of current year

    // Create a list of the current year and the next two years
    return List.generate(10, (index) {
      final year = currentYearShort + index;
      return {'code': '$year', 'name': '$year'};
    });
  }
  // Function to get the months list
  List<Map<String, String>> getMonths() {
    // Create a list of months from 01 to 12
    return List.generate(12, (index) {
      final month = (index + 1).toString().padLeft(2, '0'); // Pads single digits with '0'
      return {'code': month, 'name': month};
    });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
      return InkWell(
        onTap: () async {
          // await _scanCard();
          // paymentViewModel.setInputValues(
          //     index: 'nickname', value: card?.cardholder);
          // paymentViewModel.setInputValues(
          //     index: 'card_number', value: card?.number);
          // paymentViewModel.setInputValues(
          //     index: 'expiry_month', value: card?.expiry.split('/').first);
          // paymentViewModel.setInputValues(
          //     index: 'expiry_year', value: card?.expiry.split('/').last);
          // // Future.delayed(const Duration(seconds: 0), () =>
          // //     Navigator.pop(context));
          // Future.delayed(
          //     const Duration(seconds: 0), () => Navigator.pop(context));
          // Future.delayed(
          //     const Duration(seconds: 0),
          //     () => Navigator.of(context).push(_createRoute(
          //         ConfirmPaymentMethod(
          //             payment_method: widget.payment_method,
          //             paymentViewModel: paymentViewModel,
          //             role: Constants.customerRoleId))));
        },
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.appValues.appPadding.p20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Text(
                  //   'Scan here',
                  //   style: getPrimaryRegularStyle(
                  //     color: context.resources.color.btnColorBlue,
                  //     fontSize: 15,
                  //   ),
                  // ),
                  Container(
                    height: context.appValues.appSizePercent.h5,
                    child: IconButton(
                      onPressed: () async {
                        await _scanCard();
                        paymentViewModel.setInputValues(
                            index: 'nickname', value: card?.cardholder);
                        paymentViewModel.setInputValues(
                            index: 'card_number', value: card?.number);
                        paymentViewModel.setInputValues(
                            index: 'expiry_month',
                            value: card?.expiry.split('/').first);
                        paymentViewModel.setInputValues(
                            index: 'expiry_year',
                            value: card?.expiry.split('/').last);
                        // Future.delayed(const Duration(seconds: 0), () =>
                        //     Navigator.pop(context));
                        Future.delayed(const Duration(seconds: 0),
                            () => Navigator.pop(context));
                        Future.delayed(
                            const Duration(seconds: 0),
                            () => Navigator.of(context).push(_createRoute(
                                ConfirmPaymentMethod(
                                    payment_method: widget.payment_method,
                                    paymentViewModel: paymentViewModel,
                                    role: Constants.customerRoleId))));
                      },
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: context.resources.color.btnColorBlue,
                      ),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                index: 'card_number',
                value: paymentViewModel.getPaymentBody['card_number'] ?? '',
                viewModel: paymentViewModel.setInputValues,
                hintText: translate('paymentMethod.cardNumber'),
                validator: (val) => paymentViewModel.paymentError['card-number'],
                errorText: paymentViewModel.paymentError['card-number'],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: context.appValues.appSize.s15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.appValues.appSizePercent.w28,
                        child: CustomDropDown(
                          index: 'expiry_year',
                          value:
                              paymentViewModel.getPaymentBody['expiry_year'] ??
                                  '00',
                          validator: AppValidation().cardNumberValidator,

                          viewModel: paymentViewModel.setInputValues,
                          hintText: 'YY',
                          // hintText: translate('paymentMethod.expiryYear'),
                          keyboardType: TextInputType.text,
                          list:getExpiryYears(),
                          onChange: (value) {
                            paymentViewModel.setInputValues(
                                index: 'expiry_year', value: value);
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: const Text(
                      //     'ex:29',
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //       fontSize: 15.0,
                      //       fontWeight: FontWeight.w300,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: context.appValues.appSizePercent.w28,
                        child: CustomDropDown(
                          index: 'expiry_month',
                          value:
                              paymentViewModel.getPaymentBody['expiry_month'] ??
                                  '0',
                          validator: AppValidation().cardNumberValidator,
                          viewModel: paymentViewModel.setInputValues,
                          hintText: 'MM',
                          // hintText: translate('paymentMethod.expiryMonth'),
                          keyboardType: TextInputType.text,
                          list:getMonths(),
                          onChange: (value) {
                            paymentViewModel.setInputValues(
                                index: 'expiry_month', value: value);
                          },
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: const Text(
                      //     'ex:08',
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //       fontSize: 15.0,
                      //       fontWeight: FontWeight.w300,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),

                  Column(
                    children: [
                      SizedBox(
                        width: context.appValues.appSizePercent.w28,
                        child: CustomTextField(
                          index: 'last_digits',
                          viewModel: paymentViewModel.setInputValues,
                          hintText: translate('paymentMethod.CVC'),
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: const Text(
                      //     '',
                      //     style: TextStyle(
                      //       color: Colors.grey,
                      //       fontSize: 15.0,
                      //       fontWeight: FontWeight.w300,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: context.appValues.appSize.s15),

              CustomTextField(
                index: 'nickname',
                value: paymentViewModel.getPaymentBody['nickname'] ?? '',
                viewModel: paymentViewModel.setInputValues,
                hintText: translate('paymentMethod.cardName'),
                keyboardType: TextInputType.text,
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> _scanCard() async {
    const scanOptions = ScanOptions(scanCardHolderName: true);
    try {
      final receivedCard = await CardScanner.scanCard(scanOptions: scanOptions);
      if (receivedCard == null) return;
      if (!mounted) return;
      card = receivedCard;
      debugPrint('card $card');
      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // Future<void> _scanCard() async {
  //   // Request camera permission
  //   var status = await Permission.camera.request();
  //   debugPrint(
  //       'Permission status: $status'); // Check the permission status in logs
  //
  //   if (status.isGranted) {
  //
  //     // If granted, proceed with scanning
  //     setState(() {
  //       _cardInfo = null;
  //     });
  //     final result = await Navigator.of(context).push(
  //       MaterialPageRoute(
  //         builder: (context) {
  //           return Scaffold(
  //             appBar: AppBar(
  //               leading: IconButton(
  //                 icon: Icon(Icons.arrow_back),
  //                 onPressed: () {
  //                   Navigator.pop(context); // Navigate back when back button is pressed
  //                 },
  //               ),
  //               title: Text("Scan Your Card"),
  //             ),
  //             body: Stack(
  //               children: [
  //                 ScannerWidget(
  //                   controller: _controller,
  //                   overlayOrientation: CardOrientation.landscape,
  //                   // cameraResolution: CameraResolution.high,
  //                   oneShotScanning: true,
  //                 ),
  //               ],
  //             ),
  //           );
  //         },
  //       ),
  //     ) as CardInfo?;
  //     if (result != null) {
  //       setState(() {
  //         _cardInfo = result;
  //       });
  //     }
  //   } else if (status.isDenied) {
  //     // If denied, explain the importance of permission
  //     _showPermissionDialog("Camera permission is required to scan cards.");
  //   } else if (status.isPermanentlyDenied) {
  //     // If permanently denied, guide the user to settings
  //     _showPermissionDialog(
  //         "Camera permission is permanently denied. Please go to settings to enable the camera.");
  //   }
  // }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Permission Required"),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
                openAppSettings(); // Open settings if permanently denied
              },
            ),
          ],
        );
      },
    );
  }

  Route _createRoute(Widget child) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
