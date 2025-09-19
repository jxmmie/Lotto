// To parse this JSON data, do
//
//     final userByidRes = userByidResFromJson(jsonString);

import 'dart:convert';

UserByidRes userByidResFromJson(String str) =>
    UserByidRes.fromJson(json.decode(str));

String userByidResToJson(UserByidRes data) => json.encode(data.toJson());

class UserByidRes {
  String message;
  Data data;

  UserByidRes({required this.message, required this.data});

  factory UserByidRes.fromJson(Map<String, dynamic> json) =>
      UserByidRes(message: json["message"], data: Data.fromJson(json["data"]));

  Map<String, dynamic> toJson() => {"message": message, "data": data.toJson()};
}

class Data {
  int uid;
  String email;
  String password;
  String fullname;
  DateTime birthday;
  String phone;
  String role;

  Data({
    required this.uid,
    required this.email,
    required this.password,
    required this.fullname,
    required this.birthday,
    required this.phone,
    required this.role,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    uid: json["uid"],
    email: json["email"],
    password: json["password"],
    fullname: json["fullname"],
    birthday: DateTime.parse(json["birthday"]),
    phone: json["phone"],
    role: json["role"],
  );

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "email": email,
    "password": password,
    "fullname": fullname,
    "birthday":
        "${birthday.year.toString().padLeft(4, '0')}-${birthday.month.toString().padLeft(2, '0')}-${birthday.day.toString().padLeft(2, '0')}",
    "phone": phone,
    "role": role,
  };
}
