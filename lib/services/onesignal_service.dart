import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalService {
  static const String _appId = '357d957a-ed36-4ab5-a29e-cfbe93536a64';
  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    Object? lastError;
    for (var attempt = 0; attempt < 8; attempt++) {
      try {
        await OneSignal.initialize(_appId);
        await OneSignal.Notifications.requestPermission(true);
        _initialized = true;
        return;
      } on MissingPluginException catch (error) {
        lastError = error;
        debugPrint('OneSignal init attempt $attempt failed: $error');
        await Future<void>.delayed(Duration(milliseconds: 200 * (attempt + 1)));
      } catch (error) {
        lastError = error;
        debugPrint('OneSignal init failed: $error');
        return;
      }
    }

    debugPrint('OneSignal init gave up: $lastError');
  }

  static Future<void> identifyUser({
    String? userId,
    String? email,
    String? phone,
  }) async {
    try {
      if (!_initialized) {
        await initialize();
      }
      if (!_initialized) return;

      if (userId != null && userId.isNotEmpty) {
        await OneSignal.login(userId);
      }
      if (email != null && email.isNotEmpty) {
        await OneSignal.User.addEmail(email);
      }
      if (phone != null && phone.isNotEmpty) {
        await OneSignal.User.addSms(phone);
      }
    } catch (error) {
      debugPrint('OneSignal identify failed: $error');
    }
  }
}
