import 'package:dingdone/res/fonts/styles_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class JobPaymentWebView extends StatefulWidget {
  const JobPaymentWebView({
    super.key,
    required this.redirectUrl,
  });

  final String redirectUrl;

  static const deepLink = 'dingdone://com.in2uitions.dingdone/job_payment';

  @override
  State<JobPaymentWebView> createState() => _JobPaymentWebViewState();
}

class _JobPaymentWebViewState extends State<JobPaymentWebView> {
  late final WebViewController _controller;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            if (_isPaymentReturn(request.url)) {
              _complete(true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            if (_isPaymentReturn(url)) {
              _complete(true);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.redirectUrl));

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
  }

  bool _isPaymentReturn(String url) {
    return url.contains('job_payment') ||
        url.startsWith(JobPaymentWebView.deepLink);
  }

  void _complete(bool success) {
    if (_completed || !mounted) return;
    _completed = true;
    Navigator.of(context).pop(success);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xff4100E3),
        foregroundColor: Colors.white,
        title: Text(
          'payment.authorizeTitle'.tr(),
          style: getPrimarySemiBoldStyle(fontSize: 16, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => _complete(false),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
