import 'dart:convert';
import 'dart:ui' as ui;

import 'package:dingdone/res/app_prefs.dart';
import 'package:http/http.dart' as http;

class TranslationHelper {
  static String mapLocaleToLanguageCode(String? locale) {
    if (locale == null || locale.isEmpty) return 'en';

    final normalized = locale.toLowerCase();
    if (normalized.startsWith('ar')) return 'ar';
    if (normalized.startsWith('el')) return 'el';
    if (normalized.startsWith('ru')) return 'ru';
    return 'en';
  }

  /// Phone / device language (what the user expects as translation target).
  static Future<String> getTargetLanguageCode() async {
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final deviceLang = mapLocaleToLanguageCode(deviceLocale.toLanguageTag());

    if (deviceLang.isNotEmpty) return deviceLang;

    final appLang = await AppPreferences().get(key: language, isModel: false);
    return mapLocaleToLanguageCode(appLang?.toString());
  }

  /// Best-effort detection of the text language from its characters.
  static String detectSourceLanguageCode(String text) {
    final arabic = RegExp(r'[\u0600-\u06FF]');
    final cyrillic = RegExp(r'[\u0400-\u04FF]');
    final greek = RegExp(r'[\u0370-\u03FF]');

    if (arabic.hasMatch(text)) return 'ar';
    if (cyrillic.hasMatch(text)) return 'ru';
    if (greek.hasMatch(text)) return 'el';
    return 'en';
  }

  static Future<String> translate(String text, {String? targetLocale}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return text;

    final target = targetLocale != null
        ? mapLocaleToLanguageCode(targetLocale)
        : await getTargetLanguageCode();
    final source = detectSourceLanguageCode(trimmed);

    // Already in the user's phone language — no need to translate.
    if (source == target) return trimmed;

    final uri = Uri.parse(
      'https://translate.googleapis.com/translate_a/single'
      '?client=gtx&sl=$source&tl=$target&dt=t&q=${Uri.encodeComponent(trimmed)}',
    );

    final response = await http.get(uri);
    if (response.statusCode != 200) return text;

    final decoded = jsonDecode(response.body);
    if (decoded is List && decoded.isNotEmpty && decoded[0] is List) {
      final segments = decoded[0] as List;
      return segments.map((segment) => segment[0]?.toString() ?? '').join();
    }

    return text;
  }
}
