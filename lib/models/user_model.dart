// ignore_for_file: non_constant_identifier_names
class UserModel {
  UserModel({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.phone,
    this.dob,
    this.preferred_language,
    // this.tags array,
    // this.avatar,
    // this.language,
    // this.theme,
    // this.status,
    // this.location,
    this.role,
    // this.description,
    // this.is_active,
  });

  String? id;
  String? first_name;
  String? last_name;
  String? email;
  String? phone;
  String? dob;
  // String? tags array;
  // String? avatar;
  // String? language;
  // String? theme;
  // String? status;
  // String? location;
  // //String? nationality;
  // //String? profession;
  // // String? fresh_grad;
  String? role;
  dynamic preferred_language;
  // String? description;
  // bool? is_active;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        first_name: json["first_name"],
        last_name: json["last_name"],
        email: json["email"],
        phone: json["phone_number"],
        dob: json["dob"],
        // tags array: json["tags array"],
        // avatar: json["avatar"],
        // language: json["language"],
        // theme: json["theme"],
        // status: json["status"],
        // location: json["location"],
        // //nationality: json["nationality"],
        // //profession: json["profession"],
        // //fresh_grad: json["fresh_grad"],
        role: json["role"],
        preferred_language: json["preferred_language"],
        // description: json["description"],
        // is_active: json["is_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "phone_number": phone,
        "dob": dob,
        "role": role,
        "preferred_language": preferred_language,
        // // "tags array" : tags array,
        // "avatar": avatar,
        // "language": language,
        // "theme": theme,
        // "status": status,
        // "description": description,
        // "is_active": is_active,
      };
  @override
  String toString() {
    return 'id: $id \n; first_name: $first_name; email:$email; phone_number:$phone; dob:$dob , role: $role';
  }
}
