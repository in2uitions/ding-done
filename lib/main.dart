import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/res/constants.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/job_details_supplier/job_details_supplier.dart';
import 'package:dingdone/view/on_boarding/on_boarding.dart';
import 'package:dingdone/view/update_job_request_customer/update_job_request_customer.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
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
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:uni_links2/uni_links.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

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
        child: MyApp(prefs: prefs),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final SharedPreferences prefs;
  const MyApp({super.key, required this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  String? userRole;
  String? _userId;
  bool _doLogin = false;

  late StreamSubscription _sub;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final FacebookAppEvents facebookAppEvents = FacebookAppEvents();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    checkUserIsLogged();
    getLanguage();
    initPlatformState();
    initialDeepLink();
  }

  @override
  void dispose() {
    _sub.cancel();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  Future<void> initialDeepLink() async {
    _sub = linkStream.listen((String? link) {
      if (link != null) {
        handleIncomingLink(link);
      }
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
      } else {
        navigatorKey.currentState?.push(
          _createRoute(BottomBar(userRole: role, currentTab: 0)),
        );
      }
    } catch (e) {
      debugPrint('Deep link error: $e');
    }
  }

  void checkUserIsLogged() async {
    final role = await AppPreferences().get(key: userRoleKey, isModel: false);
    final userId = await AppPreferences().get(key: userIdKey, isModel: false);

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
          position:
          Tween(begin: const Offset(1, 0), end: Offset.zero).animate(animation),
          child: child,
        );
      },
    );
  }

  // Future<void> initPlatformState() async {
  //   await Firebase.initializeApp();
  //   await dotenv.load(fileName: "assets/.env");
  //
  //   Stripe.publishableKey =
  //   "pk_test_51O0fFdB7xypJLNmfiUJe4QudE7LEN3LwadQP5PQJLLPXFDzX201eWVxZXxWxv7hYdidpLtoB2lblfcqtSkaKpKeG00yto1YAKe";
  //
  //   OneSignal.initialize("357d957a-ed36-4ab5-a29e-cfbe93536a64");
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
    const String adjustAppToken = "uncurdcnlq0w";

    final adjustConfig = AdjustConfig(
      adjustAppToken,
      kDebugMode
          ? AdjustEnvironment.sandbox
          : AdjustEnvironment.production,
    );

// Optional Logging (recommended while testing)
    adjustConfig.logLevel = AdjustLogLevel.verbose;

// Attribution callback
    adjustConfig.attributionCallback = (data) {
      debugPrint("Adjust attribution: ${data.trackerName}");
    };

    Adjust.initSdk(adjustConfig);
    /// ------------------------------------------------------

    Stripe.publishableKey =
    "pk_test_51O0fFdB7xypJLNmfiUJe4QudE7LEN3LwadQP5PQJLLPXFDzX201eWVxZXxWxv7hYdidpLtoB2lblfcqtSkaKpKeG00yto1YAKe";

    OneSignal.initialize("357d957a-ed36-4ab5-a29e-cfbe93536a64");
    await OneSignal.Notifications.requestPermission(true);

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
    } else if (state == AppLifecycleState.paused) {
      Adjust.onPause();
    }
  }

  Future<void> _requestTrackingPermission() async {
    final status =
    await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }
  void getLanguage() async {
    String? lang = await AppPreferences().get(key: language, isModel: false);
    lang ??= 'en';

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
