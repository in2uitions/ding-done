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
  String responseID = "";
  String sdkStatus = "";
  String sdkErrorCode = "";
  String sdkErrorMessage = "";
  String sdkErrorDescription = "";
  late final WebViewController _controller;
  bool sdkLoading = false;
  Future<void> _handleRefresh() async {
    try {

      await Provider.of<PaymentViewModel>(context, listen: false).getPaymentMethodsTap();

    } catch (error) {
      // Handle the error, e.g., by displaying a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh: $error'),
        ),
      );
    }
  }
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
    try {
      widget.paymentViewModel.setLoading(true);
      setState(() => sdkLoading = true);

      tapSDKResult = await GoSellSdkFlutter.startPaymentSDK;
      debugPrint('SDK Result: ${tapSDKResult?['sdk_result']}');

      // Handle SDK result synchronously here.
      String resultStatus = tapSDKResult?['sdk_result'];
      if (resultStatus == "SUCCESS" || resultStatus == "FAILED") {
        handleSDKResult();
      } else if (resultStatus == "SDK_ERROR") {
        sdkErrorCode = tapSDKResult!['sdk_error_code'].toString();
        sdkErrorMessage = tapSDKResult!['sdk_error_message'] ?? "";
        sdkErrorDescription = tapSDKResult!['sdk_error_description'] ?? "";
      }

      // Perform asynchronous operations outside setState.
      await widget.paymentViewModel.getPaymentMethodsTap();
      dynamic result =
      await widget.paymentViewModel.authorizeCard(tapSDKResult);

      // Now update state synchronously.
      setState(() {
        // Update any state variables if needed.
      });

      if (result["transaction"] != null) {
        // Launch the WebView.
        // Make sure _createRoute is defined and returns a valid Route.
        late final PlatformWebViewControllerCreationParams params;
        if (WebViewPlatform.instance is WebKitWebViewPlatform) {
          params = WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
            mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
          );
        } else {
          params = const PlatformWebViewControllerCreationParams();
        }

        final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
        controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(NavigationDelegate(
            onProgress: (int progress) {
              debugPrint('WebView loading: $progress%');
            },
            onPageStarted: (String url) async {
              debugPrint('Page started: $url');
              if (url.contains('dingdone://com.in2uitions.dingdone')) {
                await Future.delayed(const Duration(seconds: 6));
                Navigator.pop(context);
                Provider.of<PaymentViewModel>(context, listen: false)
                    .getPaymentMethodsTap();

                // Consumer2<ProfileViewModel, PaymentViewModel>(
                //   builder: (context, profileViewModel, paymentViewModel, _) {
                //     // Ensure the payment methods are retrieved.
                //     paymentViewModel.getPaymentMethods();
                //
                //     // Schedule the navigation after the current frame is built.
                //     WidgetsBinding.instance.addPostFrameCallback((_) {
                //       Navigator.of(context).push(_createRoute(
                //         ConfirmPaymentMethod(
                //           payment_method: paymentViewModel.getPaymentBody['tap_payments_card'],
                //           paymentViewModel: paymentViewModel,
                //           profileViewModel: profileViewModel,
                //           role: userRole,
                //         ),
                //       ));
                //     });
                //
                //     // Return an empty widget since nothing needs to be displayed here.
                //     return Container();
                //   },
                // );
              }
            },
            onPageFinished: (String url) {
              debugPrint('Page finished: $url');
            },
            // onNavigationRequest: (NavigationRequest request) {
            //   if (request.url.startsWith('https://www.youtube.com/')) {
            //     return NavigationDecision.prevent;
            //   }
            //   return NavigationDecision.navigate;
            // },
            onWebResourceError: (WebResourceError error) {
              debugPrint('WebView error: ${error.description}');
            },
          ))
          ..addJavaScriptChannel('Toaster',
              onMessageReceived: (JavaScriptMessage message) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(message.message)),
                );
              })
          ..loadRequest(Uri.parse('${result["transaction"]["url"]}'));

        // If using Android-specific features.
        if (controller.platform is AndroidWebViewController) {
          AndroidWebViewController.enableDebugging(true);
          (controller.platform as AndroidWebViewController)
              .setMediaPlaybackRequiresUserGesture(false);
        }

        _controller = controller;
        Navigator.of(context).push(_createRoute(Scaffold(
          backgroundColor: Colors.green,
          appBar: AppBar(
            title: const Text('DingDone Payment'),
            // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            actions: <Widget>[
              NavigationControls(webViewController: _controller),
              SampleMenu(webViewController: _controller),
            ],
          ),
          body: WebViewWidget(controller: _controller),
          // floatingActionButton: favoriteButton(),
        )));
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) => simpleAlert(
                context,
                translate('button.failure'),
                '${result['errors'] != null ? result['errors'][0]['description'] : result['error']}'));
      }
      await widget.paymentViewModel.setLoading(false);
    } catch (error) {
      debugPrint('Error starting SDK: $error');
    }
  }

  Future<void> _launchUrl(String url) async {
    if (Uri.tryParse(url)?.hasAbsolutePath != true) {
      debugPrint('Invalid URL: $url');
      return;
    }

    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void handleSDKResult() {
    debugPrint('SDK Result>>>> $tapSDKResult');
    debugPrint('SDK Result TOKEN>>>> ${tapSDKResult?['token']}');

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
        debugPrint('Save Card : ${tapSDKResult!['token']}');
        break;

      case "TOKENIZE":
        debugPrint('TOKENIZE token : ${tapSDKResult!['token']}');
        debugPrint(
            'TOKENIZE token_currency  : ${tapSDKResult!['token_currency']}');
        debugPrint(
            'TOKENIZE card_first_six : ${tapSDKResult!['card_first_six']}');
        debugPrint(
            'TOKENIZE card_last_four : ${tapSDKResult!['card_last_four']}');
        debugPrint('TOKENIZE card_object  : ${tapSDKResult!['card_object']}');
        debugPrint(
            'TOKENIZE card_holder_name  : ${tapSDKResult!['card_holder_name']}');
        debugPrint(
            'TOKENIZE card_exp_month : ${tapSDKResult!['card_exp_month']}');
        debugPrint(
            'TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');
        debugPrint(
            'TOKENIZE card_exp_year    : ${tapSDKResult!['card_exp_year']}');
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
    debugPrint(
        '$trxMode  description        : ${tapSDKResult!['description']}');
    debugPrint('$trxMode  message           : ${tapSDKResult!['message']}');
    debugPrint('$trxMode  card_first_six : ${tapSDKResult!['card_first_six']}');
    debugPrint(
        '$trxMode  card_last_four   : ${tapSDKResult!['card_last_four']}');
    debugPrint(
        '$trxMode  card_object         : ${tapSDKResult!['card_object']}');
    debugPrint('$trxMode  card_id         : ${tapSDKResult!['card_id']}');
    debugPrint(
        '$trxMode  card_brand          : ${tapSDKResult!['card_brand']}');
    debugPrint(
        '$trxMode  card_exp_month  : ${tapSDKResult!['card_exp_month']}');
    debugPrint('$trxMode  card_exp_year: ${tapSDKResult!['card_exp_year']}');
    debugPrint('$trxMode  acquirer_id  : ${tapSDKResult!['acquirer_id']}');
    debugPrint(
        "$trxMode payment agreement : ${tapSDKResult!['payment_agreement']}");
    debugPrint(
        '$trxMode  acquirer_response_code : ${tapSDKResult!['acquirer_response_code']}');
    debugPrint(
        '$trxMode  acquirer_response_message: ${tapSDKResult!['acquirer_response_message']}');
    debugPrint('$trxMode  source_id: ${tapSDKResult!['source_id']}');
    debugPrint(
        '$trxMode  source_channel     : ${tapSDKResult!['source_channel']}');
    debugPrint(
        '$trxMode  source_object      : ${tapSDKResult!['source_object']}');
    debugPrint(
        '$trxMode source_payment_type : ${tapSDKResult!['source_payment_type']}');

    if (trxMode == "Authorize") {
      responseID = tapSDKResult!['authorize_id'] ?? "";
    } else {
      responseID = tapSDKResult!['charge_id'] ?? "";
    }

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
                  return RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: Container(
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
            ? SvgPicture.asset('assets/img/booking-confirmation-icon.svg')
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

enum MenuOptions {
  showUserAgent,
  listCookies,
  clearCookies,
  addToCache,
  listCache,
  clearCache,
  navigationDelegate,
  doPostRequest,
  loadLocalFile,
  loadFlutterAsset,
  loadHtmlString,
  transparentBackground,
  setCookie,
  logExample,
  basicAuthentication,
}

class SampleMenu extends StatelessWidget {
  SampleMenu({
    super.key,
    required this.webViewController,
  });

  final WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MenuOptions>(
      key: const ValueKey<String>('ShowPopupMenu'),
      onSelected: (MenuOptions value) {
        switch (value) {
          case MenuOptions.showUserAgent:
            _onShowUserAgent();
          case MenuOptions.listCookies:
            _onListCookies(context);
          case MenuOptions.clearCookies:
            _onClearCookies(context);
          case MenuOptions.addToCache:
            _onAddToCache(context);
          case MenuOptions.listCache:
            _onListCache();
          case MenuOptions.clearCache:
            _onClearCache(context);
          case MenuOptions.navigationDelegate:
          // _onNavigationDelegateExample();
          case MenuOptions.doPostRequest:
            _onDoPostRequest();
          case MenuOptions.loadLocalFile:
          // _onLoadLocalFileExample();
          case MenuOptions.loadFlutterAsset:
            _onLoadFlutterAssetExample();
          case MenuOptions.loadHtmlString:
          // _onLoadHtmlStringExample();
          case MenuOptions.transparentBackground:
          // _onTransparentBackground();
          case MenuOptions.setCookie:
            _onSetCookie();
          case MenuOptions.logExample:
          // _onLogExample();
          case MenuOptions.basicAuthentication:
          // _promptForUrl(context);
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuItem<MenuOptions>>[
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.showUserAgent,
          child: Text('Show user agent'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCookies,
          child: Text('List cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCookies,
          child: Text('Clear cookies'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.addToCache,
          child: Text('Add to cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.listCache,
          child: Text('List cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.clearCache,
          child: Text('Clear cache'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.navigationDelegate,
          child: Text('Navigation Delegate example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.doPostRequest,
          child: Text('Post Request'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadHtmlString,
          child: Text('Load HTML string'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadLocalFile,
          child: Text('Load local file'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.loadFlutterAsset,
          child: Text('Load Flutter Asset'),
        ),
        const PopupMenuItem<MenuOptions>(
          key: ValueKey<String>('ShowTransparentBackgroundExample'),
          value: MenuOptions.transparentBackground,
          child: Text('Transparent background example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.setCookie,
          child: Text('Set cookie'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.logExample,
          child: Text('Log example'),
        ),
        const PopupMenuItem<MenuOptions>(
          value: MenuOptions.basicAuthentication,
          child: Text('Basic Authentication Example'),
        ),
      ],
    );
  }

  Future<void> _onShowUserAgent() {
    // Send a message with the user agent string to the Toaster JavaScript channel we registered
    // with the WebView.
    return webViewController.runJavaScript(
      'Toaster.postMessage("User Agent: " + navigator.userAgent);',
    );
  }

  Future<void> _onListCookies(BuildContext context) async {
    final String cookies = await webViewController
        .runJavaScriptReturningResult('document.cookie') as String;
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text('Cookies:'),
            _getCookieList(cookies),
          ],
        ),
      ));
    }
  }

  Future<void> _onAddToCache(BuildContext context) async {
    await webViewController.runJavaScript(
      'caches.open("test_caches_entry"); localStorage["test_localStorage"] = "dummy_entry";',
    );
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Added a test entry to cache.'),
      ));
    }
  }

  Future<void> _onListCache() {
    return webViewController.runJavaScript('caches.keys()'
    // ignore: missing_whitespace_between_adjacent_strings
        '.then((cacheKeys) => JSON.stringify({"cacheKeys" : cacheKeys, "localStorage" : localStorage}))'
        '.then((caches) => Toaster.postMessage(caches))');
  }

  Future<void> _onClearCache(BuildContext context) async {
    await webViewController.clearCache();
    await webViewController.clearLocalStorage();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Cache cleared.'),
      ));
    }
  }

  Future<void> _onClearCookies(BuildContext context) async {
    final bool hadCookies = await cookieManager.clearCookies();
    String message = 'There were cookies. Now, they are gone!';
    if (!hadCookies) {
      message = 'There are no cookies.';
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
      ));
    }
  }

  // Future<void> _onNavigationDelegateExample() {
  //   final String contentBase64 = base64Encode(
  //     const Utf8Encoder().convert(kNavigationExamplePage),
  //   );
  //   return webViewController.loadRequest(
  //     Uri.parse('data:text/html;base64,$contentBase64'),
  //   );
  // }

  Future<void> _onSetCookie() async {
    await cookieManager.setCookie(
      const WebViewCookie(
        name: 'foo',
        value: 'bar',
        domain: 'httpbin.org',
        path: '/anything',
      ),
    );
    await webViewController.loadRequest(Uri.parse(
      'https://httpbin.org/anything',
    ));
  }

  Future<void> _onDoPostRequest() {
    return webViewController.loadRequest(
      Uri.parse('https://httpbin.org/post'),
      method: LoadRequestMethod.post,
      headers: <String, String>{'foo': 'bar', 'Content-Type': 'text/plain'},
      body: Uint8List.fromList('Test Body'.codeUnits),
    );
  }

  // Future<void> _onLoadLocalFileExample() async {
  //   final String pathToIndex = await _prepareLocalFile();
  //   await webViewController.loadFile(pathToIndex);
  // }

  Future<void> _onLoadFlutterAssetExample() {
    return webViewController.loadFlutterAsset('assets/www/index.html');
  }

  // Future<void> _onLoadHtmlStringExample() {
  //   return webViewController.loadHtmlString(kLocalExamplePage);
  // }

  // Future<void> _onTransparentBackground() {
  //   return webViewController.loadHtmlString(kTransparentBackgroundPage);
  // }

  Widget _getCookieList(String cookies) {
    if (cookies == '""') {
      return Container();
    }
    final List<String> cookieList = cookies.split(';');
    final Iterable<Text> cookieWidgets =
    cookieList.map((String cookie) => Text(cookie));
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: cookieWidgets.toList(),
    );
  }

  // static Future<String> _prepareLocalFile() async {
  //   final String tmpDir = (await getTemporaryDirectory()).path;
  //   final File indexFile = File(
  //       <String>{tmpDir, 'www', 'index.html'}.join(Platform.pathSeparator));
  //
  //   await indexFile.create(recursive: true);
  //   await indexFile.writeAsString(kLocalExamplePage);
  //
  //   return indexFile.path;
  // }

  // Future<void> _onLogExample() {
  //   webViewController
  //       .setOnConsoleMessage((JavaScriptConsoleMessage consoleMessage) {
  //     debugPrint(
  //         '== JS == ${consoleMessage.level.name}: ${consoleMessage.message}');
  //   });
  //
  //   return webViewController.loadHtmlString(kLogExamplePage);
  // }

  Future<void> _promptForUrl(BuildContext context) {
    final TextEditingController urlTextController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Input URL to visit'),
          content: TextField(
            decoration: const InputDecoration(labelText: 'URL'),
            autofocus: true,
            controller: urlTextController,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                if (urlTextController.text.isNotEmpty) {
                  final Uri? uri = Uri.tryParse(urlTextController.text);
                  if (uri != null && uri.scheme.isNotEmpty) {
                    webViewController.loadRequest(uri);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Visit'),
            ),
          ],
        );
      },
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
