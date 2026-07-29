import 'package:dingdone/res/app_prefs.dart';
import 'package:dingdone/utils/country_helper.dart';
import 'package:flutter/foundation.dart';

class CountryViewModel with ChangeNotifier {
  CountryViewModel() {
    load();
  }

  String? _selectedCountry;
  bool _isLoaded = false;
  bool _locationPromptHandled = false;

  String? get selectedCountry => _selectedCountry;
  bool get isLoaded => _isLoaded;
  bool get locationPromptHandled => _locationPromptHandled;

  Future<String?> load() async {
    _selectedCountry =
        await AppPreferences().get(key: selectedCountryKey, isModel: false);
    _isLoaded = true;
    notifyListeners();
    return _selectedCountry;
  }

  Future<void> selectCountry(String country) async {
    final supportedCountry = SupportedCountry.fromValue(country);
    if (supportedCountry == null) return;

    _selectedCountry = supportedCountry.displayName;
    _isLoaded = true;
    await AppPreferences().save(
      key: selectedCountryKey,
      value: _selectedCountry,
      isModel: false,
    );
    notifyListeners();
  }

  void markLocationPromptHandled() {
    _locationPromptHandled = true;
  }

  bool matchesAddress(dynamic address) {
    return addressMatchesCountry(address, _selectedCountry);
  }

  List<Map<String, dynamic>> filterAddresses(dynamic addresses) {
    if (!_isLoaded || _selectedCountry == null || addresses is! List) {
      return const [];
    }
    return addresses
        .whereType<Map>()
        .map((address) => Map<String, dynamic>.from(address))
        .where(matchesAddress)
        .toList();
  }
}
