import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/job_details_supplier/job_details_supplier.dart';
import 'package:dingdone/view/job_payment/pending_job_payments_screen.dart';
import 'package:dingdone/view/new_password/new_password.dart';
import 'package:dingdone/view/on_boarding/on_boarding.dart';
import 'package:dingdone/view/update_job_request_customer/update_job_request_customer.dart';
import 'package:dingdone/services/app_update_service.dart';
import 'package:dingdone/view/widgets/custom/force_update_dialog.dart';
import 'package:dingdone/utils/navigation_service.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/country_view_model/country_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/on_boarding_view_model/on_boarding_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:dingdone/services/onesignal_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app_links/app_links.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    runApp(const DingDoneBootstrap());
    return;
  }

  await EasyLocalization.ensureInitialized();
  runApp(
    RestartWidget(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('el'),
          Locale('ru'),
        ],
        fallbackLocale: const Locale('en'),
        path: 'assets/i18n',
        saveLocale: true,
        child: const MyApp(),
      ),
    ),
  );
}

class _StartupSplash extends StatelessWidget {
  const _StartupSplash();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/img/onboarding_bg.png',
              fit: BoxFit.cover,
            ),
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: Image.asset(
                  'assets/img/app-icon.png',
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DingDoneBootstrap extends StatefulWidget {
  const DingDoneBootstrap({super.key});

  @override
  State<DingDoneBootstrap> createState() => _DingDoneBootstrapState();
}

class _DingDoneBootstrapState extends State<DingDoneBootstrap> {
  Widget? _app;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startApp());
  }

  Future<void> _ensureLocalizationReady() async {
    Object? lastError;
    for (var attempt = 0; attempt < 8; attempt++) {
      try {
        await EasyLocalization.ensureInitialized();
        return;
      } catch (error) {
        lastError = error;
        debugPrint('Localization init attempt $attempt failed: $error');
        await Future<void>.delayed(Duration(milliseconds: 150 * (attempt + 1)));
      }
    }

    debugPrint('Localization init gave up: $lastError');
  }

  Future<void> _startApp() async {
    if (!mounted) return;
    setState(() {
      _app = RestartWidget(
        child: EasyLocalization(
          supportedLocales: const [
            Locale('en'),
            Locale('ar'),
            Locale('el'),
            Locale('ru'),
          ],
          fallbackLocale: const Locale('en'),
          startLocale: const Locale('en'),
          path: 'assets/i18n',
          saveLocale: false,
          child: const MyApp(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return _app ?? const _StartupSplash();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String? userRole;
  String? _userId;
  bool _doLogin = false;

  StreamSubscription? _sub;
  final AppLinks _appLinks = AppLinks();
  final GlobalKey<NavigatorState> navigatorKey =
      NavigationService().navigationKey;
  final FacebookAppEvents facebookAppEvents = FacebookAppEvents();
  final AppUpdateService _appUpdateService = AppUpdateService();
  bool _isUpdateDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    checkUserIsLogged();
    WidgetsBinding.instance.addPostFrameCallback((_) => getLanguage());
    WidgetsBinding.instance.addPostFrameCallback((_) => initPlatformState());
    initialDeepLink();
    // Wait until MaterialApp / navigator are ready, then check store version.
    // Same path for debug and release.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future<void>.delayed(const Duration(seconds: 2), _checkForAppUpdate);
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> initialDeepLink() async {
    // Cold start
    final initial = await _appLinks.getInitialLink();
    if (initial != null) {
      handleIncomingLink(initial.toString());
    }
    // Warm / foreground links
    _sub = _appLinks.uriLinkStream.listen((Uri uri) {
      handleIncomingLink(uri.toString());
    });
  }

  void handleIncomingLink(String link) async {
    final role = await AppPreferences().get(key: userRoleKey, isModel: false);
    Uri uri = Uri.parse(link);

    try {
      if (uri.toString().contains('confirm_payment_method')) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => Consumer2<ProfileViewModel, PaymentViewModel>(
              builder: (context, profileViewModel, paymentViewModel, _) {
                return ConfirmPaymentMethod(
                  payment_method:
                      paymentViewModel.getPaymentBody['tap_payments_card'],
                  paymentViewModel: paymentViewModel,
                  profileViewModel: profileViewModel,
                  role: role,
                );
              },
            ),
          ),
        );
      } else if (uri.path.contains('reset-password')) {
        final token = uri.queryParameters['token'];
        if (token != null && token.isNotEmpty) {
          _openResetPassword(token);
        }
      } else if (uri.toString().contains('job_payment')) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (_) => const PendingJobPaymentsScreen(autoResume: true),
          ),
        );
      } else {
        navigatorKey.currentState?.push(
          _createRoute(BottomBar(userRole: role, currentTab: 0)),
        );
      }
    } catch (e) {
      debugPrint('Deep link error: $e');
    }
  }

  void _openResetPassword(String token, {int attempt = 0}) {
    final navigator = navigatorKey.currentState;
    if (navigator == null) {
      if (attempt > 20) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _openResetPassword(token, attempt: attempt + 1);
      });
      return;
    }
    navigator.push(
      MaterialPageRoute(
        builder: (_) => NewPasswordScreen(resetToken: token),
      ),
    );
  }

  void checkUserIsLogged() async {
    final role = await AppPreferences().get(key: userRoleKey, isModel: false);
    final userId = await AppPreferences().get(key: userIdKey, isModel: false);

    if (!mounted) return;
    setState(() {
      userRole = role;
      _userId = userId;
      _doLogin = role != null;
    });
  }

  Route _createRoute(dynamic page) {
    return PageRouteBuilder(
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(1, 0), end: Offset.zero)
              .animate(animation),
          child: child,
        );
      },
    );
  }

  // Future<void> initPlatformState() async {
  //   await Firebase.initializeApp();
  //   await dotenv.load(fileName: "assets/.env");
  //
  //   Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';
  //
  //   OneSignal.initialize(dotenv.env['ONESIGNAL_APP_ID'] ?? '');
  //   await OneSignal.Notifications.requestPermission(true);
  //
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
  //   }
  //
  //   await Permission.camera.request();
  // }
  Future<void> initPlatformState() async {
    await Firebase.initializeApp();
    await dotenv.load(fileName: "assets/.env");

    /// ---------------- ADJUST INITIALIZATION ----------------
    final adjustAppToken = dotenv.env['ADJUST_APP_TOKEN'] ?? '';

    final adjustConfig = AdjustConfig(
      adjustAppToken,
      kDebugMode ? AdjustEnvironment.sandbox : AdjustEnvironment.production,
    );

// Optional Logging (recommended while testing)
    adjustConfig.logLevel = AdjustLogLevel.verbose;

// Attribution callback
    adjustConfig.attributionCallback = (data) {
      debugPrint("Adjust attribution: ${data.trackerName}");
    };

    Adjust.initSdk(adjustConfig);

    /// ------------------------------------------------------

    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

    await OneSignalService.initialize();

    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }

    await Permission.camera.request();

    /// iOS Tracking Permission (you already imported ATT)
    if (Platform.isIOS) {
      await _requestTrackingPermission();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      Adjust.onResume();
      _checkForAppUpdate();
    } else if (state == AppLifecycleState.paused) {
      Adjust.onPause();
    }
  }

  Future<void> _checkForAppUpdate({int attempt = 0}) async {
    if (_isUpdateDialogVisible || !mounted || !_doLogin) return;

    final updateAvailable = await _appUpdateService.isStoreUpdateAvailable();
    debugPrint(
      'AppUpdate: available=$updateAvailable '
      'store=${_appUpdateService.lastStoreVersion} '
      'installed=${_appUpdateService.lastCurrentVersion} '
      'attempt=$attempt',
    );

    // Retry once if store version could not be read (common on slow release networks).
    if (!updateAvailable &&
        _appUpdateService.lastStoreVersion == null &&
        attempt < 2) {
      await Future<void>.delayed(const Duration(seconds: 2));
      if (mounted) await _checkForAppUpdate(attempt: attempt + 1);
      return;
    }

    if (!updateAvailable || !mounted) return;

    final storeUrl = _appUpdateService.storeUrl;
    if (storeUrl == null) {
      debugPrint('AppUpdate: store URL missing, skipping dialog');
      return;
    }

    final context = navigatorKey.currentContext;
    if (context == null || !context.mounted) {
      debugPrint('AppUpdate: navigator context not ready, retrying...');
      if (attempt < 3) {
        await Future<void>.delayed(const Duration(seconds: 1));
        if (mounted) await _checkForAppUpdate(attempt: attempt + 1);
      }
      return;
    }

    _isUpdateDialogVisible = true;
    showForceUpdateDialog(context, storeUrl: storeUrl);
  }

  Future<void> _requestTrackingPermission() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }

  void getLanguage() async {
    try {
      String? lang = await AppPreferences().get(key: language, isModel: false);
      lang ??= 'en';
      if (!mounted) return;
      await context.setLocale(Locale(lang));
      await AppPreferences().save(
          key: dblang,
          value: lang == 'ar'
              ? 'ar-SA'
              : lang == 'ru'
                  ? 'ru-RU'
                  : lang == 'el'
                      ? 'el-GR'
                      : 'en-US',
          isModel: false);
    } catch (error) {
      debugPrint('getLanguage failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnBoardingViewModel>(
            create: (BuildContext context) => OnBoardingViewModel()),
        ChangeNotifierProvider<LoginViewModel>(
            create: (BuildContext context) => LoginViewModel()),
        ChangeNotifierProvider<SignUpViewModel>(
            create: (BuildContext context) => SignUpViewModel()),
        ChangeNotifierProvider<CountryViewModel>(
            create: (BuildContext context) => CountryViewModel()),
        ChangeNotifierProvider<CategoriesViewModel>(
            create: (BuildContext context) => CategoriesViewModel()),
        ChangeNotifierProvider<ServicesViewModel>(
            create: (BuildContext context) => ServicesViewModel()),
        ChangeNotifierProvider<ProfileViewModel>(
            create: (BuildContext context) => ProfileViewModel()),
        ChangeNotifierProvider<JobsViewModel>(
            create: (BuildContext context) => JobsViewModel()),
        ChangeNotifierProvider<PaymentViewModel>(
            create: (BuildContext context) => PaymentViewModel(
                Provider.of<ProfileViewModel>(context, listen: false))),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: _doLogin
            ? BottomBar(userRole: userRole, currentTab: 0)
            : const OnBoardingScreen(),
      ),
    );
  }
}
