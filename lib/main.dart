import 'dart:async';
import 'dart:io';

import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/view/bottom_bar/bottom_bar.dart';
import 'package:dingdone/view/confirm_payment_method/confirm_payment_method.dart';
import 'package:dingdone/view/on_boarding/on_boarding.dart';
import 'package:dingdone/view/widgets/restart/restart_widget.dart';
import 'package:dingdone/view_model/categories_view_model/categories_view_model.dart';
import 'package:dingdone/view_model/jobs_view_model/jobs_view_model.dart';
import 'package:dingdone/view_model/login_view_model/login_view_model.dart';
import 'package:dingdone/view_model/on_boarding_view_model/on_boarding_view_model.dart';
import 'package:dingdone/view_model/payment_view_model/payment_view_model.dart';
import 'package:dingdone/view_model/profile_view_model/profile_view_model.dart';
import 'package:dingdone/view_model/services_view_model/services_view_model.dart';
import 'package:dingdone/view_model/signup_view_model/signup_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_sell_sdk_flutter/model/models.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:go_sell_sdk_flutter/go_sell_sdk_flutter.dart';
import 'package:uni_links2/uni_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  var delegate = await LocalizationDelegate.create(
      fallbackLocale: 'en', supportedLocales: ['en', 'ar', 'el', 'ru']);
  runApp(
    RestartWidget(
      child: LocalizedApp(
        delegate,
        MyApp(prefs: prefs),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  var prefs;

  MyApp({super.key, this.prefs});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? email;
  String? password;
  String? userIdK;
  String? userRole;
  String? _userId;
  bool _doLogin = false;
  late StreamSubscription _sub;
  late String _routePath;

  @override
  void initState() {
    super.initState();
    // getCredentials();
    checkUserIsLogged();
    getLanguage();
    WidgetsFlutterBinding.ensureInitialized();
    // Future.delayed(const Duration(seconds: 3), () => checkUserIsLogged());
    initPlatformState();
    // configurePayment();
    // setupSDKSession();
    initialDeepLink();
  }

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }

  Future<void> initialDeepLink() async {
    _sub = linkStream.listen((String? link) async {
      if (!mounted) return;
      final role = await AppPreferences().get(key: userRoleKey, isModel: false);

      Uri uri = Uri.parse(link!);

      _routePath = uri.path;

      debugPrint('my routeee $_routePath');
      if (_routePath.contains('confirm_payment_method')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Consumer2<ProfileViewModel, PaymentViewModel>(
                builder: (context, profileViewModel, paymentViewModel, _) {
              return ConfirmPaymentMethod(
                payment_method: paymentViewModel.getPaymentBody['tap_payments_card'],
                paymentViewModel: paymentViewModel,
                profileViewModel: profileViewModel,
                role: role,
              );
            }),
          ),
        );
      }
    }, onError: (err) {
      debugPrint('error in init deep link $err');
      // Handle errors here
    });
  }

  void checkUserIsLogged() async {
    // final prefs = await SharedPreferences.getInstance();
    // final role = prefs.getString(userRoleKey);
    final role = await AppPreferences().get(key: userRoleKey, isModel: false);
    // final userId = prefs.getString(userIdKey);
    final userId = await AppPreferences().get(key: userIdKey, isModel: false);

    // if ((prefs.getBool(SHARED_LOGGED) != null) &&
    //     prefs.getBool(SHARED_LOGGED)!) {
    setState(() {
      // _doLogin = true;
      userRole = role;
      _userId = userId;
      if (userRole != null) {
        _doLogin = true;
      }
    });
    // }
  }

  Future<void> initPlatformState() async {
    if (!mounted) return;
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    OneSignal.Debug.setAlertLevel(OSLogLevel.none);
    OneSignal.initialize("357d957a-ed36-4ab5-a29e-cfbe93536a64");
    OneSignal.Notifications.requestPermission(true);
    WidgetsFlutterBinding.ensureInitialized();
    const stripePublishableKey =
        "pk_test_51O0fFdB7xypJLNmfiUJe4QudE7LEN3LwadQP5PQJLLPXFDzX201eWVxZXxWxv7hYdidpLtoB2lblfcqtSkaKpKeG00yto1YAKe";
    Stripe.publishableKey = stripePublishableKey;
    await dotenv.load(fileName: "assets/.env");
    PermissionStatus cameraPermission = await Permission.camera.request();
    debugPrint('status $cameraPermission');
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
  }

  Locale localLang = const Locale('en');

  void getLanguage() async {
    String? lang = await AppPreferences().get(key: language, isModel: false);
    // debugPrint('language to usse22 $lang');
    if (lang == null) {
      lang = "en";
      await AppPreferences().save(key: language, value: "en", isModel: false);
      await AppPreferences().save(key: dblang, value: 'en-US', isModel: false);
    }

    setState(() {
      localLang = Locale(lang!);
    });
    if (lang == 'en') {
      await AppPreferences().save(key: dblang, value: 'en-US', isModel: false);
    }
    if (lang == 'ar') {
      await AppPreferences().save(key: dblang, value: 'ar-SA', isModel: false);
    }
    if (lang == 'ru') {
      await AppPreferences().save(key: dblang, value: 'ru-RU', isModel: false);
    }
    if (lang == 'el') {
      await AppPreferences().save(key: dblang, value: 'el-GR', isModel: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MultiProvider(
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
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localLang,
          debugShowCheckedModeBanner: false,
          home: _doLogin
              ? BottomBar(userRole: userRole)
              : const OnBoardingScreen(),
          // home: LoginScreen(),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyListView(),
//     );
//   }
// }

// class MyListView extends StatefulWidget {
//   @override
//   _MyListViewState createState() => _MyListViewState();
// }

// class _MyListViewState extends State<MyListView> {
//   int selectedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Selectable List (Single Selection)'),
//       ),
//       body: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: 10,
//         itemBuilder: (context, index) {
//           bool isSelected = index == selectedIndex;

//           return InkWell(
//             onTap: () {
//               setState(() {
//                 if (isSelected) {
//                   selectedIndex = -1; // Deselect the item
//                 } else {
//                   selectedIndex = index; // Select the item
//                 }
//               });
//             },
//             child: Container(
//               width: 150.0,
//               margin: EdgeInsets.only(right: 10.0),
//               color: isSelected ? Colors.blue : Colors.grey,
//               child: Center(
//                 child: Text('Item $index'),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
