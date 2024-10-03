
import 'dart:convert';

PaymentsModelMain paymentsModelMainFromJson(String str) =>
    PaymentsModelMain.fromJson(jsonDecode(str));

String paymentsModelMainToJson(PaymentsModelMain data) => jsonEncode(data.toJson());

class PaymentsModelMain {
  PaymentsModelMain({
    this.payments,
  });

  List<PaymentsModel>? payments;

  factory PaymentsModelMain.fromJson(Map<String, dynamic> json) => PaymentsModelMain(
    payments: json["data"] == null
        ? null
        : List<PaymentsModel>.from(
        json["data"].map((x) => PaymentsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "payments": payments == null
        ? null
        : List<dynamic>.from(payments!.map((x) => x.toJson())),
  };

  Map<String, dynamic> toCarouselJson() => {
    "payments_carousel": payments == null
        ? null
        : List<dynamic>.from(payments!.map((x) => x.toCarouselJson())),
  };
}

class PaymentsModel {
  PaymentsModel({
    this.id,
    this.customer,
    this.payment_method_id,
    this.brand,
    this.country,
    this.expiry_month,
    this.expiry_year,
    this.funding,
    this.last_digits,
    this.nickname,
  });

  int? id;
  dynamic customer;
  String? payment_method_id;
  String? brand;
  String? country;
  String? expiry_month;
  String? expiry_year;
  String? funding;
  String? last_digits;
  String? nickname;

  factory PaymentsModel.fromJson(Map<String, dynamic> json) => PaymentsModel(
    id: json["id"],
    customer: json["customer"],
    payment_method_id: json["payment_method_id"],
    brand: json["brand"],
    country: json["country"],
    expiry_month: json["expiry_month"],
    expiry_year: json["expiry_year"],
    funding: json["funding"],
    last_digits: json["last_digits"],
    nickname: json["nickname"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "customer": customer,
    "payment_method_id": payment_method_id,
    "brand": brand,
    "country": country,
    "expiry_month": expiry_month,
    "expiry_year": expiry_year,
    "funding": funding,
    "last_digits": last_digits,
    "nickname": nickname,
  };

  Map<String, dynamic> toCarouselJson() => {
    "customer": customer,
    "payment_method_id": payment_method_id,
    "brand": brand,
    "country": country,
    "expiry_month": expiry_month,
    "expiry_year": expiry_year,
    "funding": funding,
    "last_digits": last_digits,
    "nickname": nickname,
  };
}
