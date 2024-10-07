
import 'dart:convert';

JobsModelMain jobsModelMainFromJson(String str) =>
    JobsModelMain.fromJson(jsonDecode(str));

String jobsModelMainToJson(JobsModelMain data) => jsonEncode(data.toJson());

class JobsModelMain {
  JobsModelMain({
    this.jobs,
  });

  List<JobsModel>? jobs;

  factory JobsModelMain.fromJson(Map<String, dynamic> json) => JobsModelMain(
    jobs: json["data"] == null
        ? null
        : List<JobsModel>.from(
        json["data"].map((x) => JobsModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "jobs": jobs == null
        ? null
        : List<dynamic>.from(jobs!.map((x) => x.toJson())),
  };

  Map<String, dynamic> toCarouselJson() => {
    "jobs_carousel": jobs == null
        ? null
        : List<dynamic>.from(jobs!.map((x) => x.toCarouselJson())),
  };
}

class JobsModel {
  JobsModel({
    this.id,
    this.status,
    this.address,
    this.longitude,
    this.latitude,
    this.start_date,
    this.severity_level,
    this.job_description,
    this.uploaded_media,
    this.payment_method,
    this.payment_card,
    this.customer,
    this.supplier,
    this.service,
    this.category_name,
    this.service_name,
    this.supplier_first_name,
    this.supplier_last_name,
    this.job_address,
    this.job_type,
    this.country_rates,
    this.actual_start_date,
    this.actual_end_date,
    this.rating_stars,
    this.rating_comment,
    this.completed_units,
    this.extra_fees,
    this.extra_fees_reason,
    this.number_of_units,
    this.currency,
    this.total_amount,
    this.is_paid,
    this.finish_date,
    this.supplier_to_job_distance,
    this.supplier_to_job_time,
    this.translations,
    this.ratind_stars,
  });

  int? id;
  dynamic status;
  String? address;
  double? longitude;
  double? latitude;
  String? start_date;
  String? severity_level;
  String? job_description;
  dynamic job_type;
  String? category_name;
  String? service_name;
  dynamic uploaded_media;
  dynamic payment_method;
  dynamic payment_card;
  String? supplier_first_name;
  String? supplier_last_name;
  String? actual_start_date;
  String? actual_end_date;
  dynamic job_address;
  Map<String, dynamic>? customer;
  dynamic supplier;
  dynamic service;
  Map<String, dynamic>? country_rates;
  dynamic rating_stars;
  String? rating_comment;
  dynamic completed_units;
  dynamic extra_fees;
  dynamic extra_fees_reason;
  dynamic number_of_units;
  dynamic currency;
  dynamic total_amount;
  dynamic is_paid;
  dynamic finish_date;
  dynamic supplier_to_job_distance;
  dynamic supplier_to_job_time;
  dynamic translations;
  dynamic ratind_stars;

  factory JobsModel.fromJson(Map<String, dynamic> json) => JobsModel(
    id: json["id"],
    status: json["status"],
    address: json["address"],
    longitude: json["longitude"],
    latitude: json["latitude"],
    start_date: json["start_date"],
    severity_level: json["severity_level"],
    job_description: json["job_description"],
    uploaded_media: json["uploaded_media"],
    payment_method: json["payment_method"],
    payment_card: json["payment_card"],
    customer: json["customer"],
    supplier: json["supplier"],
    service: json["service"],
    category_name: json["category_name"],
    service_name: json["service_name"],
    supplier_first_name: json["supplier_first_name"],
    supplier_last_name: json["supplier_last_name"],
    job_address: json["job_address"],
    job_type: json["job_type"],
    country_rates: json["country_rates"],
    actual_start_date: json["actual_start_date"],
    actual_end_date: json["actual_end_date"],
    rating_stars: json["rating_stars"],
    rating_comment: json["rating_comment"],
    completed_units: json["completed_units"],
    extra_fees: json["extra_fees"],
    extra_fees_reason: json["extra_fees_reason"],
    number_of_units: json["number_of_units"],
    currency: json["currency"],
    total_amount: json["total_amount"],
    is_paid: json["is_paid"],
    finish_date: json["finish_date"],
    supplier_to_job_distance: json["supplier_to_job_distance"],
    supplier_to_job_time: json["supplier_to_job_time"],
    translations: json["translations"],
    ratind_stars: json["ratind_stars"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "status": status,
    "address": address,
    "longitude": longitude,
    "latitude": latitude,
    "start_date": start_date,
    "severity_level": severity_level,
    "job_description": job_description,
    "uploaded_media": uploaded_media,
    "payment_method": payment_method,
    "payment_card": payment_card,
    "customer": customer,
    "supplier": supplier,
    "service": service,
    "category_name": category_name,
    "service_name": service_name,
    "supplier_first_name": supplier_first_name,
    "supplier_last_name": supplier_last_name,
    "job_address": job_address,
    "job_type": job_type,
    "country_rates": country_rates,
    "actual_start_date": actual_start_date,
    "actual_end_date": actual_end_date,
    "rating_stars": rating_stars,
    "rating_comment": rating_comment,
    "completed_units": completed_units,
    "extra_fees": extra_fees,
    "extra_fees_reason": extra_fees_reason,
    "number_of_units": number_of_units,
    "currency": currency,
    "total_amount": total_amount,
    "is_paid": is_paid,
    "finish_date": finish_date,
    "supplier_to_job_distance": supplier_to_job_distance,
    "supplier_to_job_time": supplier_to_job_time,
    "translations": translations,
    "ratind_stars": ratind_stars,
  };

  Map<String, dynamic> toCarouselJson() => {
    "address": address,
    "job_description": job_description,
    "customer": customer,
    "supplier": supplier,
    "category_name": category_name,
    "translations": translations,
    "ratind_stars": ratind_stars,
  };
}
