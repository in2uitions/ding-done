import 'dart:convert';

ServicesModelMain servicesModelMainFromJson(String str) =>
    ServicesModelMain.fromJson(jsonDecode(str));

String servicesModelMainToJson(ServicesModelMain data) =>
    jsonEncode(data.toJson());

class ServicesModelMain {
  ServicesModelMain({
    this.services,
  });

  List<ServicesModel>? services;

  factory ServicesModelMain.fromJson(Map<String, dynamic> json) =>
      ServicesModelMain(
        services: json["data"] == null
            ? null
            : List<ServicesModel>.from(
                json["data"].map((x) => ServicesModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? null
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };

  Map<String, dynamic> toCarouselJson() => {
        "services_carousel": services == null
            ? null
            : List<dynamic>.from(services!.map((x) => x.toCarouselJson())),
      };
}

class ServicesModel {
  ServicesModel(
      {this.id,
      this.title,
      this.category,
      this.status,
      this.description,
      this.image,
      this.category_image,
      this.category_title,
      this.country_rates,
      this.translations});

  int? id;
  String? title;
  // int? category;
  String? description;
  dynamic image;
  String? status;
  String? category_image;
  String? category_title;
  dynamic country_rates;
  dynamic category;
  dynamic translations;

  factory ServicesModel.fromJson(Map<String, dynamic> json) => ServicesModel(
        id: json["id"],
        title: json["title"],
        category: json["category"],
        country_rates: json["country_rates"],
        description: json["description"],
        image: json["image"],
        status: json["status"],
        // category: json["category"],
        category_image: json["category_image"],
        category_title: json["category_title"],
        translations: json["translations"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "category": category,
        "description": description,
        "image": image,
        "status": status,
        "category_image": category_image,
        "category_title": category_title,
        "country_rates": country_rates,
        "translations": translations
      };

  Map<String, dynamic> toCarouselJson() => {
        "title": title,
      };
}
