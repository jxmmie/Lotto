// To parse this JSON data, do
//
//     final myLottoRes = myLottoResFromJson(jsonString);

import 'dart:convert';

List<MyLottoRes> myLottoResFromJson(String str) =>
    List<MyLottoRes>.from(json.decode(str).map((x) => MyLottoRes.fromJson(x)));

String myLottoResToJson(List<MyLottoRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyLottoRes {
  int oid;
  int lid;
  String number;
  int price;
  String status;

  MyLottoRes({
    required this.oid,
    required this.lid,
    required this.number,
    required this.price,
    required this.status,
  });

  factory MyLottoRes.fromJson(Map<String, dynamic> json) => MyLottoRes(
    oid: json["oid"],
    lid: json["lid"],
    number: json["number"],
    price: (json["price"] as num).toInt(),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "oid": oid,
    "lid": lid,
    "number": number,
    "price": price,
    "status": status,
  };
}
