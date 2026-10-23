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
                                      await payVM.setLoading(true);
                                      try {
                                        final url = await payVM.initiateCardSave();
                                        if (!dialogContext.mounted) return;
                                        await payVM.setLoading(false);
                                        await _openCardSave(url);
                                      } catch (error) {
                                        if (!dialogContext.mounted) return;
                                        final message = error
                                            .toString()
                                            .replaceFirst('Exception: ', '');
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
