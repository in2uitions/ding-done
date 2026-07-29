enum SupportedCountry {
  // Prefs/UI use display names; saved addresses use CMS countries.code.
  qatar('Qatar', 'QAT', {'qatar', 'qa', 'qat'}),
  cyprus('Cyprus', 'CYP', {'cyprus', 'cy', 'cyp'});

  const SupportedCountry(this.displayName, this.cmsCode, this.aliases);

  final String displayName;
  final String cmsCode;
  final Set<String> aliases;

  static SupportedCountry? fromValue(dynamic value) {
    if (value is Map) {
      for (final key in const ['name', 'title', 'code', 'iso_a2', 'iso_a3']) {
        final country = fromValue(value[key]);
        if (country != null) return country;
      }
      return null;
    }

    final normalized = value?.toString().trim().toLowerCase();
    if (normalized == null || normalized.isEmpty) return null;
    for (final country in SupportedCountry.values) {
      if (country.aliases.contains(normalized) ||
          country.displayName.toLowerCase() == normalized ||
          country.cmsCode.toLowerCase() == normalized) {
        return country;
      }
    }
    return null;
  }

  /// Resolves the CMS `countries.code` for a market from the API list, with
  /// [cmsCode] as fallback when the list is empty or missing that country.
  static String? cmsCodeFor(
    dynamic selectedCountry, {
    List<dynamic>? countries,
  }) {
    final selected = fromValue(selectedCountry);
    if (selected == null) return null;
    if (countries != null) {
      for (final country in countries) {
        if (country is Map && fromValue(country) == selected) {
          final code = country['code']?.toString();
          if (code != null && code.isNotEmpty) return code;
        }
      }
    }
    return selected.cmsCode;
  }

  static SupportedCountry? fromCoordinates(
    double latitude,
    double longitude,
  ) {
    // Country bounding boxes avoid relying on reverse-geocoding availability.
    if (latitude >= 24.4 &&
        latitude <= 26.3 &&
        longitude >= 50.7 &&
        longitude <= 51.7) {
      return SupportedCountry.qatar;
    }
    if (latitude >= 34.5 &&
        latitude <= 35.8 &&
        longitude >= 32.2 &&
        longitude <= 34.7) {
      return SupportedCountry.cyprus;
    }
    return null;
  }
}

bool countryValuesMatch(dynamic first, dynamic second) {
  final firstCountry = SupportedCountry.fromValue(first);
  return firstCountry != null &&
      firstCountry == SupportedCountry.fromValue(second);
}

bool addressMatchesCountry(dynamic address, dynamic country) {
  return address is Map && countryValuesMatch(address['country'], country);
}
