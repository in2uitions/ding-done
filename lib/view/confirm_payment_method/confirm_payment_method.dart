import 'package:dingdone/res/app_context_extension.dart';
import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/card_info.dart';
import 'package:dingdone/view/widgets/confirm_payment_method/payment_method_buttons.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
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
  bool _cardSaveClosed = false;
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
  bool _isCardSaveReturn(String url) {
    return url.contains('dingdone://com.in2uitions.dingdone');
  }

  Future<void> _completeCardSave() async {
    if (_cardSaveClosed || !mounted) return;
    _cardSaveClosed = true;
    Navigator.of(context).pop();
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    await Provider.of<PaymentViewModel>(context, listen: false)
        .getPaymentMethodsTap();
  }

  String _cardholderName() {
    final user = widget.profileViewModel.profileBody['user'];
    if (user is! Map) return '';
    final first = user['first_name']?.toString().trim() ?? '';
    final last = user['last_name']?.toString().trim() ?? '';
    return [first, last].where((part) => part.isNotEmpty).join(' ');
  }

  Future<Map<String, dynamic>?> _askForCard() {
    return showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) => _CardSaveSheet(
        initialName: _cardholderName(),
      ),
    );
  }

  Future<void> _openCardSave(String url) async {
    _cardSaveClosed = false;
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
        onNavigationRequest: (NavigationRequest request) {
          if (_isCardSaveReturn(request.url)) {
            _completeCardSave();
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
        onPageStarted: (String pageUrl) {
          if (_isCardSaveReturn(pageUrl)) {
            _completeCardSave();
          }
        },
        onWebResourceError: (WebResourceError error) {
          final failedUrl = error.url ?? '';
          if (_isCardSaveReturn(failedUrl)) {
            _completeCardSave();
          } else {
            debugPrint('WebView error: ${error.description}');
          }
        },
      ))
      ..loadRequest(Uri.parse(url));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    if (!mounted) return;
    await Navigator.of(context).push(_createRoute(Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('paymentMethod.addPaymentMethod'.tr()),
      ),
      body: WebViewWidget(controller: controller),
    )));
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
                          'profile.paymentMethods'.tr(),
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
                maxChildSize: 0.85,
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
                                      final dialogContext = context;
                                      final card = await _askForCard();
                                      if (card == null || !dialogContext.mounted) {
                                        return;
                                      }
                                      await payVM.setLoading(true);
                                      try {
                                        final url =
                                            await payVM.initiateCardSave(card);
                                        if (!dialogContext.mounted) return;
                                        await payVM.setLoading(false);
                                        if (url != null && url.isNotEmpty) {
                                          await _openCardSave(url);
                                        }
                                      } catch (error) {
                                        if (!dialogContext.mounted) return;
                                        final message = error
                                            .toString()
                                            .replaceFirst('Exception: ', '')
                                            .replaceFirst(
                                              'Error During Communication: ',
                                              '',
                                            );
                                        showDialog(
                                          context: dialogContext,
                                          builder: (_) => simpleAlert(
                                            dialogContext,
                                            'button.failure'.tr(),
                                            message,
                                          ),
                                        );
                                      } finally {
                                        await payVM.setLoading(false);
                                      }
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

                                                      'paymentMethod.addPaymentMethod'.tr(),
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

class _CardNumberInputFormatter extends TextInputFormatter {
  const _CardNumberInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final isAmex = digits.startsWith('34') || digits.startsWith('37');
    final maxDigits = isAmex ? 15 : 19;
    final trimmed =
        digits.length > maxDigits ? digits.substring(0, maxDigits) : digits;
    final text = _groupCardDigits(trimmed, isAmex);
    final digitOffset = _digitCount(newValue.text, newValue.selection.end);
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(
        offset: _offsetForDigits(text, digitOffset),
      ),
    );
  }

  static String _groupCardDigits(String digits, bool isAmex) {
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final breakHere = isAmex ? (i == 4 || i == 10) : i % 4 == 0;
      if (i > 0 && breakHere) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  static int _digitCount(String text, int offset) {
    final end = offset.clamp(0, text.length);
    return text.substring(0, end).replaceAll(RegExp(r'\D'), '').length;
  }

  static int _offsetForDigits(String text, int digits) {
    if (digits <= 0) return 0;
    var seen = 0;
    for (var i = 0; i < text.length; i++) {
      if (RegExp(r'\d').hasMatch(text[i])) seen++;
      if (seen >= digits) return i + 1;
    }
    return text.length;
  }
}

class _CardSaveSheet extends StatefulWidget {
  const _CardSaveSheet({required this.initialName});

  final String initialName;

  @override
  State<_CardSaveSheet> createState() => _CardSaveSheetState();
}

class _CardSaveSheetState extends State<_CardSaveSheet> {
  late final TextEditingController _nameController;
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    super.dispose();
  }

  InputDecoration _decoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xffF6F6F8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  void _submit() {
    final name = _nameController.text.trim();
    final number = _numberController.text.replaceAll(RegExp(r'\D'), '');
    final expiryDigits = _expiryController.text.replaceAll(RegExp(r'\D'), '');
    final month = expiryDigits.length >= 2
        ? int.tryParse(expiryDigits.substring(0, 2))
        : null;
    final yearText =
        expiryDigits.length > 2 ? expiryDigits.substring(2) : '';
    final year = int.tryParse(yearText);
    final cvc = _cvcController.text.trim();
    final isAmex = number.startsWith('34') || number.startsWith('37');
    final valid = name.isNotEmpty &&
        number.length >= 13 &&
        number.length <= 19 &&
        (isAmex ? number.length == 15 : true) &&
        month != null &&
        month >= 1 &&
        month <= 12 &&
        year != null &&
        (yearText.length == 2 || yearText.length == 4) &&
        cvc.length >= 3 &&
        cvc.length <= 4;
    if (!valid) {
      setState(() {
        _errorText = 'paymentMethod.cardDetailsRequired'.tr();
      });
      return;
    }
    Navigator.of(context).pop({
      'card_number': number,
      'exp_month': month,
      'exp_year': year,
      'cvc': cvc,
      'name': name,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'paymentMethod.addPaymentMethod'.tr(),
              style: getPrimarySemiBoldStyle(
                fontSize: 16,
                color: const Color(0xff4100E3),
              ),
            ),
            const Gap(16),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: _decoration('paymentMethod.cardHolder'.tr()),
            ),
            const Gap(12),
            TextField(
              controller: _numberController,
              keyboardType: TextInputType.number,
              inputFormatters: const [_CardNumberInputFormatter()],
              decoration: _decoration('1234 5678 9012 3456').copyWith(
                labelText: 'paymentMethod.cardNumber'.tr(),
              ),
            ),
            const Gap(12),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: TextField(
                    controller: _expiryController,
                    keyboardType: TextInputType.number,
                    inputFormatters: const [_ExpiryInputFormatter()],
                    decoration: _decoration('MM/YY').copyWith(
                      labelText: 'paymentMethod.expiryMonth'.tr(),
                    ),
                  ),
                ),
                const Gap(8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _cvcController,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: _decoration('123').copyWith(
                      labelText: 'paymentMethod.CVC'.tr(),
                    ),
                  ),
                ),
              ],
            ),
            if (_errorText != null) ...[
              const Gap(12),
              Text(
                _errorText!,
                style: getPrimaryRegularStyle(
                  fontSize: 13,
                  color: Colors.red,
                ),
              ),
            ],
            const Gap(16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff4100E3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _submit,
                child: Text(
                  'paymentMethod.addPaymentMethod'.tr(),
                  style: getPrimaryBoldStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpiryInputFormatter extends TextInputFormatter {
  const _ExpiryInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 6) digits = digits.substring(0, 6);
    if (digits.length == 1 && int.parse(digits) > 1) {
      digits = '0$digits';
    }
    final text = digits.length <= 2 ? digits : '${digits.substring(0, 2)}/${digits.substring(2)}';
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
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
