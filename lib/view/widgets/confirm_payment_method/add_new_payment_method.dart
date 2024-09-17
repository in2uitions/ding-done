import 'package:dingdone/models/roles_model.dart';
import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/app_validation.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/confirm_payment_method/payments.dart';
import 'package:dingdone/view/widgets/custom/custom_dropdown.dart';
import 'package:dingdone/view/widgets/custom/custom_text_feild.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:ml_card_scanner/ml_card_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../res/fonts/styles_manager.dart';
import 'card_info.dart';

class AddNewPaymentMethodWidget extends StatefulWidget {
  var payment_method;

   AddNewPaymentMethodWidget({super.key,required this.payment_method});

  @override
  State<AddNewPaymentMethodWidget> createState() =>
      _AddNewPaymentMethodWidgetState();
}

class _AddNewPaymentMethodWidgetState extends State<AddNewPaymentMethodWidget> {
  CardInfo? _cardInfo;
  final ScannerWidgetController _controller = ScannerWidgetController();

  @override
  void initState() {
    super.initState();
    _controller
      ..setCardListener(_onListenCard)
      ..setErrorListener(_onError);
  }
  @override
  void dispose() {
    _controller
      ..removeCardListeners(_onListenCard)
      ..removeErrorListener(_onError)
      ..dispose();
    super.dispose();
  }

  void _onListenCard(CardInfo? value) {
    if (value != null) {
      debugPrint('popping');
      Navigator.of(context).pop(value);

    }
  }

  void _onError(ScannerException exception) {
    if (kDebugMode) {
      print('Error: ${exception.message}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(builder: (context, paymentViewModel, _) {
      return InkWell(
        onTap: () async{
          await _scanCard();
          paymentViewModel.setInputValues(index: 'brand',value: _cardInfo?.type);
          paymentViewModel.setInputValues(index: 'card-number',value: _cardInfo?.number);
          Navigator.of(context).pop();
          Future.delayed(const Duration(seconds: 0), () =>
              Navigator.of(context)
                  .push(_createRoute(
                  ConfirmPaymentMethod(
                      payment_method:widget.payment_method,
                      paymentViewModel: paymentViewModel,
                      role: Constants.customerRoleId))));

        },
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: context.appValues.appPadding.p20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                   'Scan here',
                    style: getPrimaryRegularStyle(
                      color: context.resources.color.btnColorBlue,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    height: context.appValues.appSizePercent.h5,
                    child: IconButton(
                      onPressed: () async {
                        await _scanCard();
                        paymentViewModel.setInputValues(index: 'brand',value: _cardInfo?.type);
                        paymentViewModel.setInputValues(index: 'card-number',value: _cardInfo?.number);
                        Navigator.of(context).pop();
                        Future.delayed(const Duration(seconds: 0), () =>
                            Navigator.of(context)
                                .push(_createRoute(
                                ConfirmPaymentMethod(
                                    payment_method:widget.payment_method,
                                    paymentViewModel: paymentViewModel,
                                    role: Constants.customerRoleId))));

                      },
                      icon: Icon(Icons.scanner,color:context.resources.color.btnColorBlue ,),
                    ),
                  ),
                ],
              ),
              CustomTextField(
                index: 'brand',
                value: paymentViewModel.getPaymentBody['brand']??'',
                viewModel: paymentViewModel.setInputValues,
                hintText: translate('paymentMethod.cardName'),
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: context.appValues.appSize.s15),
              CustomTextField(
                index: 'card-number',
                value: paymentViewModel.getPaymentBody['card-number']??'',
                viewModel: paymentViewModel.setInputValues,
                hintText: translate('paymentMethod.cardNumber'),
                validator: (val) => paymentViewModel.paymentError[''],
                errorText: paymentViewModel.paymentError['card-number'],
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: context.appValues.appSize.s15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.appValues.appSizePercent.w28,
                    child: CustomTextField(
                      index: 'expiry_year',
                      viewModel: paymentViewModel.setInputValues,
                      hintText: translate('paymentMethod.expiryYear'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: context.appValues.appSizePercent.w28,
                    child: CustomTextField(
                      index: 'expiry_month',
                      viewModel: paymentViewModel.setInputValues,
                      hintText: translate('paymentMethod.expiryMonth'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    width: context.appValues.appSizePercent.w28,
                    child: CustomTextField(
                      index: 'last_digits',
                      viewModel: paymentViewModel.setInputValues,
                      hintText: translate('paymentMethod.CVC'),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
    });
  }
  Future<void> _scanCard() async {
    // Request camera permission
    var status = await Permission.camera.request();
    debugPrint('Permission status: $status');  // Check the permission status in logs

    if (status.isGranted) {
      // If granted, proceed with scanning
      setState(() {
        _cardInfo = null;
      });
      final result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ScannerWidget(
              controller: _controller,
              overlayOrientation: CardOrientation.landscape,
              // cameraResolution: CameraResolution.high,
              oneShotScanning: true,
            );
          },
        ),
      ) as CardInfo?;
      if (result != null) {
        setState(() {
          _cardInfo = result;
        });
      }
    } else if (status.isDenied) {
      // If denied, explain the importance of permission
      _showPermissionDialog("Camera permission is required to scan cards.");
    } else if (status.isPermanentlyDenied) {
      // If permanently denied, guide the user to settings
      _showPermissionDialog(
          "Camera permission is permanently denied. Please go to settings to enable the camera."
      );
    }
  }

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
                openAppSettings();  // Open settings if permanently denied
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
