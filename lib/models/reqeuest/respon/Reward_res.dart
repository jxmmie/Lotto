// To parse this JSON data, do
//
//     final rewardrank = rewardrankFromJson(jsonString);

import 'dart:convert';

List<Rewardrank> rewardrankFromJson(String str) =>
    List<Rewardrank>.from(json.decode(str).map((x) => Rewardrank.fromJson(x)));

String rewardrankToJson(List<Rewardrank> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Rewardrank {
  int lid;
  String number;
  String rank;

  Rewardrank({required this.lid, required this.number, required this.rank});

  factory Rewardrank.fromJson(Map<String, dynamic> json) =>
      Rewardrank(lid: json["lid"], number: json["number"], rank: json["rank"]);

  Map<String, dynamic> toJson() => {"lid": lid, "number": number, "rank": rank};
}
