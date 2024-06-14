
import 'dart:convert';

CategoriesModelMain categoriesModelMainFromJson(String str) =>
    CategoriesModelMain.fromJson(jsonDecode(str));

String categoriesModelMainToJson(CategoriesModelMain data) => jsonEncode(data.toJson());

class CategoriesModelMain {
  CategoriesModelMain({
    this.categories,
  });

  List<CategoriesModel>? categories;

  factory CategoriesModelMain.fromJson(Map<String, dynamic> json) => CategoriesModelMain(
    categories: json["data"] == null
        ? null
        : List<CategoriesModel>.from(
        json["data"].map((x) => CategoriesModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "categories": categories == null
        ? null
        : List<dynamic>.from(categories!.map((x) => x.toJson())),
  };

  Map<String, dynamic> toCarouselJson() => {
    "categories_carousel": categories == null
        ? null
        : List<dynamic>.from(categories!.map((x) => x.toCarouselJson())),
  };
}

class CategoriesModel {
  CategoriesModel({
    this.id, this.title, this.image, this.status
  });

  int? id;
  String? title;
  String? image;
  String? status;

  factory CategoriesModel.fromJson(Map<String, dynamic> json) => CategoriesModel(
    id: json["id"],
    title: json["title"],
    image: json["image"],
    status: json["status"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "image": image,
    "status": status

  };

  Map<String, dynamic> toCarouselJson() => {
    "title": title,
  };
}
