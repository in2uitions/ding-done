import 'dart:convert';

OnBoardingMain onBoardingMainFromJson(String str) => OnBoardingMain.fromJson(json.decode(str));

String onBoardingMainToJson(OnBoardingMain data) => json.encode(data.toJson());

class OnBoardingMain {
  OnBoardingMain({
    this.onBoarding,
  });

  List<OnBoarding>? onBoarding;

  factory OnBoardingMain.fromJson(Map<String, dynamic> json) => OnBoardingMain(
    onBoarding: json["data"] == null ? null : List<OnBoarding>.from(json["data"].map((x) => OnBoarding.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "onBoarding": onBoarding == null ? null : List<dynamic>.from(onBoarding!.map((x) => x.toJson())),
  };
}

class OnBoarding {
  OnBoarding({
    this.image,
    this.title,
    this.description,
  });

  String? image;
  String? title;
  String? description;

  factory OnBoarding.fromJson(Map<String, dynamic> json) => OnBoarding(
    image: json["image"],
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "image": image,
    "title": title,
    "description": description,
  };
}
