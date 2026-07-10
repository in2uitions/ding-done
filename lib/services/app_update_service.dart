import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateService {
  static const String androidPackageId = 'com.in2uitions.dingdone';
  static const String iosBundleId = 'com.in2uitions.dingdone';

  String? _storeUrl;
  String? lastStoreVersion;
  String? lastCurrentVersion;

  String? get storeUrl => _storeUrl;

  Future<bool> isStoreUpdateAvailable() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      lastCurrentVersion = currentVersion;

      debugPrint(
        'AppUpdate: installed=$currentVersion '
        '(build ${packageInfo.buildNumber}, mode=${kDebugMode ? 'debug' : 'release'})',
      );

      if (Platform.isIOS) {
        return _checkIosUpdate(currentVersion);
      }

      if (Platform.isAndroid) {
        return _checkAndroidUpdate(currentVersion);
      }
    } catch (e, st) {
      debugPrint('App update check failed: $e\n$st');
    }

    return false;
  }

  Future<bool> _checkIosUpdate(String currentVersion) async {
    final response = await http.get(
      Uri.parse(
        'https://itunes.apple.com/lookup?bundleId=$iosBundleId',
      ),
    );

    if (response.statusCode != 200) {
      debugPrint('AppUpdate iOS: bad status ${response.statusCode}');
      return false;
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if ((data['resultCount'] as int? ?? 0) == 0) {
      debugPrint('AppUpdate iOS: app not found on App Store');
      return false;
    }

    final result = (data['results'] as List).first as Map<String, dynamic>;
    final storeVersion = result['version'] as String?;
    _storeUrl = result['trackViewUrl'] as String?;
    lastStoreVersion = storeVersion;

    if (storeVersion == null) return false;

    final needsUpdate = _isStoreVersionNewer(storeVersion, currentVersion);
    debugPrint(
      'AppUpdate iOS: store=$storeVersion current=$currentVersion needsUpdate=$needsUpdate',
    );
    return needsUpdate;
  }

  Future<bool> _checkAndroidUpdate(String currentVersion) async {
    _storeUrl =
        'https://play.google.com/store/apps/details?id=$androidPackageId';

    final response = await http
        .get(
          Uri.https(
            'play.google.com',
            '/store/apps/details',
            {'id': androidPackageId, 'hl': 'en', 'gl': 'us'},
          ),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 '
                '(KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36',
            'Accept-Language': 'en-US,en;q=0.9',
          },
        )
        .timeout(const Duration(seconds: 15));

    if (response.statusCode != 200) {
      debugPrint('AppUpdate Android: bad status ${response.statusCode}');
      return false;
    }

    final storeVersion = _parseAndroidStoreVersion(response.body);
    lastStoreVersion = storeVersion;

    if (storeVersion == null) {
      debugPrint('AppUpdate Android: could not parse store version from HTML');
      return false;
    }

    final needsUpdate = _isStoreVersionNewer(storeVersion, currentVersion);
    debugPrint(
      'AppUpdate Android: store=$storeVersion current=$currentVersion needsUpdate=$needsUpdate',
    );
    return needsUpdate;
  }

  String? _parseAndroidStoreVersion(String html) {
    // Prefer the version that appears near the package id in Play Store JSON blobs.
    final nearPackage = RegExp(
      '"$androidPackageId"[^\\]]{0,400}?\\[\\[\\["([\\d.]+?)"\\]\\]',
    ).firstMatch(html);
    if (nearPackage != null) {
      return nearPackage.group(1)?.trim();
    }

    final patterns = [
      RegExp(r'\[\[\["(\d+\.\d+\.\d+)"\]\]'),
      RegExp(r'\[\[\["([\d.]+?)"\]\]'),
      RegExp(r'"softwareVersion"\s*:\s*"([^"]+)"'),
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(html);
      final version = match?.group(1)?.trim();
      if (version != null && version.isNotEmpty && version != '0.0.0') {
        return version;
      }
    }

    return null;
  }

  bool _isStoreVersionNewer(String storeVersion, String currentVersion) {
    final storeParts = _versionParts(storeVersion);
    final currentParts = _versionParts(currentVersion);
    final length = storeParts.length > currentParts.length
        ? storeParts.length
        : currentParts.length;

    for (var i = 0; i < length; i++) {
      final storePart = i < storeParts.length ? storeParts[i] : 0;
      final currentPart = i < currentParts.length ? currentParts[i] : 0;

      if (storePart > currentPart) return true;
      if (storePart < currentPart) return false;
    }

    return false;
  }

  List<int> _versionParts(String version) {
    return version
        .split('.')
        .map((part) => int.tryParse(part.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0)
        .toList();
  }
}
