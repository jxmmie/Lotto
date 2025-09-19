// To parse this JSON data, do
//
//     final myLottoRes = myLottoResFromJson(jsonString);

import 'dart:convert';

List<MyLottoRes> myLottoResFromJson(String str) =>
    List<MyLottoRes>.from(json.decode(str).map((x) => MyLottoRes.fromJson(x)));

String myLottoResToJson(List<MyLottoRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MyLottoRes {
  int buyid;
  int lid;
  String number;
  int price;
  String status;

  MyLottoRes({
    required this.buyid,
    required this.lid,
    required this.number,
    required this.price,
    required this.status,
  });

  factory MyLottoRes.fromJson(Map<String, dynamic> json) => MyLottoRes(
    buyid: json["buyid"] as int,
    lid: json["lid"] as int,
    number: json["number"] as String,
    price: (json["price"] as num).toInt(), // แปลง double -> int
    status: json["status"] as String,
  );

  Map<String, dynamic> toJson() => {
    "buyid": buyid,
    "lid": lid,
    "number": number,
    "price": price,
    "status": status,
  };
}
