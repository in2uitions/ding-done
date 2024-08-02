import 'dart:convert';

DropDownModelMain roleModelMainFromJson(String str) =>
    DropDownModelMain.fromJson(json.decode(str));

String roleModelMainToJson(DropDownModelMain data) =>
    json.encode(data.toJson());

class DropDownModelMain {
  DropDownModelMain({this.dropDownList});
  List<DropdownRoleModel>? dropDownList;

  factory DropDownModelMain.fromJson(Map<String, dynamic> json) =>
      DropDownModelMain(
          dropDownList: json['data'] == null
              ? null
              : List<DropdownRoleModel>.from(
                  json['data'].map((x) => DropdownRoleModel.fromJson(x))));

  Map<String, dynamic> toJson() => {
        "dropDownList": dropDownList == null
            ? null
            : List<dynamic>.from(dropDownList!.map((x) => x.toJson()))
      };
}

class DropdownRoleModel {
  DropdownRoleModel({this.id, this.name,this.status, this.icon,this.title,this.image,this.category,this.description,this.translations,this.classs});
  String? id;
  String? name;
  String? icon;
  String? title;
  dynamic image;
  dynamic status;
  Map<String,dynamic>? category;
  String? description;
  dynamic translations;
  dynamic classs;

  factory DropdownRoleModel.fromJson(Map<String, dynamic> json) =>
      DropdownRoleModel(
          id: json['id'].toString(),
          name: json['name'],
        status: json['status'],
          icon: json['icon'],
          title: json['title'],
          image: json['image'],
        category: json['category'],
        description: json['description'],
        translations: json['translations'],
        classs: json['class'],
      );

  Map<String, dynamic> toJson() => {"id": id, "name": name, "icon": icon,"title":title,
    "image":image,
    "category":category,
    "status":status,
    "description":description,
    "translations":translations,
    "classs":classs,
  };

  @override
  String toString() {
    return 'icon : $icon \n name: $name \n id: $id\n title: $title\n translations: $translations\n classs: $classs';
  }
}
