// To parse this JSON data, do
//
//     final getUserRewardsRes = getUserRewardsResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<GetUserRewardsRes> getUserRewardsResFromJson(String str) =>
    List<GetUserRewardsRes>.from(
      json.decode(str).map((x) => GetUserRewardsRes.fromJson(x)),
    );

String getUserRewardsResToJson(List<GetUserRewardsRes> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetUserRewardsRes {
  int oid;
  int lid;
  String number;
  int price;
  String status;

  GetUserRewardsRes({
    required this.oid,
    required this.lid,
    required this.number,
    required this.price,
    required this.status,
  });

  factory GetUserRewardsRes.fromJson(Map<String, dynamic> json) =>
      GetUserRewardsRes(
        oid: json["oid"],
        lid: json["lid"],
        number: json["number"],
        price: json["price"],
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
