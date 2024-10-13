// ignore_for_file: non_constant_identifier_names

class ProfileModel {
  // List<DropdownRoleModel>? roleList;

  ProfileModel({
    this.id,
    this.user,
    this.status,
    this.image,
    this.gender,
    this.occupation,
    this.payment_method,
    this.address,
    this.current_address,
    this.supplier_type,
    this.service_category,
    this.company_name,
    this.registration_number,
    this.contact_details,
    this.supplier_categories,
    this.supplier_services,
    this.state,
    this.stripe_customer_id,
    this.company,
  });

  int? id;
  Map<String, dynamic>? user;
  String? status;
  dynamic image;
  String? gender;
  String? occupation;
  String? payment_method;
  List<dynamic>? address;
  Map<String, dynamic>? current_address;
  dynamic supplier_type;
  Map<String, dynamic>? service_category;
  List<dynamic>? supplier_categories;
  List<dynamic>? supplier_services;
  String? company_name;
  String? registration_number;
  String? contact_details;
  String? state;
  String? stripe_customer_id;
  dynamic company;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        user: json["user"],
        supplier_services: json["supplier_services"],
        status: json["status"],
        image: json["image"],
        gender: json["gender"],
        occupation: json["occupation"],
        payment_method: json["payment_method"],
        address: json["address"],
        current_address: json["current_address"],
        supplier_type: json["supplier_type"],
        service_category: json["service_category"],
        company_name: json["company_name"],
        registration_number: json["registration_number"],
        contact_details: json["contact_details"],
        supplier_categories: json["supplier_categories"],
        state: json["state"],
        stripe_customer_id: json["stripe_customer_id"],
    company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "company": company,
        "user": user,
        "status": status,
        "image": image,
        "gender": gender,
        "occupation": occupation,
        "payment_method": payment_method,
        "address": address,
        "current_address": current_address,
        "supplier_type": supplier_type,
        "service_category": service_category,
        "company_name": company_name,
        "registration_number": registration_number,
        "contact_details": contact_details,
        "supplier_categories": supplier_categories,
        "supplier_services": supplier_services,
        "state": state,
        "stripe_customer_id": stripe_customer_id,
      };

  @override
  String toString() {
    return '{user: $user }';
  }
}
