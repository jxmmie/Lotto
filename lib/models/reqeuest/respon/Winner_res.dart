// To parse this JSON data, do
//
//     final winnerRes = winnerResFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

WinnerRes winnerResFromJson(String str) => WinnerRes.fromJson(json.decode(str));

String winnerResToJson(WinnerRes data) => json.encode(data.toJson());

class WinnerRes {
  String message;
  List<Winner> winners;
  List<dynamic> losers;

  WinnerRes({
    required this.message,
    required this.winners,
    required this.losers,
  });

  factory WinnerRes.fromJson(Map<String, dynamic> json) => WinnerRes(
    message: json["message"],
    winners: List<Winner>.from(json["winners"].map((x) => Winner.fromJson(x))),
    losers: List<dynamic>.from(json["losers"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "winners": List<dynamic>.from(winners.map((x) => x.toJson())),
    "losers": List<dynamic>.from(losers.map((x) => x)),
  };
}

class Winner {
  int oid;
  int lid;
  String rank;
  int prizeEach;
  int amount;
  int prizeTotal;

  Winner({
    required this.oid,
    required this.lid,
    required this.rank,
    required this.prizeEach,
    required this.amount,
    required this.prizeTotal,
  });

  factory Winner.fromJson(Map<String, dynamic> json) => Winner(
    oid: json["oid"],
    lid: json["lid"],
    rank: json["rank"],
    prizeEach: json["prizeEach"],
    amount: json["amount"],
    prizeTotal: json["prizeTotal"],
  );

  Map<String, dynamic> toJson() => {
    "oid": oid,
    "lid": lid,
    "rank": rank,
    "prizeEach": prizeEach,
    "amount": amount,
    "prizeTotal": prizeTotal,
  };
}
