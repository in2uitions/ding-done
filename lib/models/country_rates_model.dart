import 'dart:convert';

CountryRatesModelMain countryRatesModelMainFromJson(String str) =>
    CountryRatesModelMain.fromJson(jsonDecode(str));

String countryRatesModelMainToJson(CountryRatesModelMain data) =>
    jsonEncode(data.toJson());

class CountryRatesModelMain {
  CountryRatesModelMain({
    this.countryRates,
  });

  List<CountryRatesModel>? countryRates;

  factory CountryRatesModelMain.fromJson(Map<String, dynamic> json) =>
      CountryRatesModelMain(
        countryRates: json["data"] == null
            ? null
            : List<CountryRatesModel>.from(
                json["data"].map((x) => CountryRatesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "countryRates": countryRates == null
            ? null
            : List<dynamic>.from(countryRates!.map((x) => x.toJson())),
      };

  Map<String, dynamic> toCarouselJson() => {
        "countryRates_carousel": countryRates == null
            ? null
            : List<dynamic>.from(countryRates!.map((x) => x.toCarouselJson())),
      };
}

class CountryRatesModel {
  CountryRatesModel(
      {this.id,
      this.unit_type,
      this.unit_rate,
      this.country,
      this.service,
      this.inspection_rate,
      this.consultation_rate});

  int? id;
  dynamic unit_type;
  dynamic unit_rate;
  dynamic country;
  dynamic service;
  dynamic inspection_rate;
  dynamic consultation_rate;

  factory CountryRatesModel.fromJson(Map<String, dynamic> json) =>
      CountryRatesModel(
        id: json["id"],
        unit_type: json["unit_type"],
        unit_rate: json["unit_rate"],
        country: json["country"],
        service: json["service"],
        inspection_rate: json["inspection_rate"],
        consultation_rate: json["consultation_rate"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "unit_type": unit_type,
        "unit_rate": unit_rate,
        "country": country,
        "service": service,
        "inspection_rate": inspection_rate,
        "consultation_rate": consultation_rate
      };

  Map<String, dynamic> toCarouselJson() => {
        "id": id,
      };
}
