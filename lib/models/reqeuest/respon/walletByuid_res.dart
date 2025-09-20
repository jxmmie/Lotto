// To parse this JSON data, do
//
//     final walletByuidRes = walletByuidResFromJson(jsonString);

import 'dart:convert';

WalletByuidRes walletByuidResFromJson(String str) =>
    WalletByuidRes.fromJson(json.decode(str));

String walletByuidResToJson(WalletByuidRes data) => json.encode(data.toJson());

class WalletByuidRes {
  int wid;
  int uid;
  double money;
  String accountId;

  WalletByuidRes({
    required this.wid,
    required this.uid,
    required this.money,
    required this.accountId,
  });

  factory WalletByuidRes.fromJson(Map<String, dynamic> json) => WalletByuidRes(
    wid: json["wid"],
    uid: json["uid"],
    money: json["money"],
    accountId: json["account_id"],
  );

  Map<String, dynamic> toJson() => {
    "wid": wid,
    "uid": uid,
    "money": money,
    "account_id": accountId,
  };
}

class WalletUpdateResponse {
  final String message;
  final int wid;
  final int uid;
  final double money;
  final String? accountId;
  WalletUpdateResponse({
    required this.message,
    required this.wid,
    required this.uid,
    required this.money,
    this.accountId,
  });

  factory WalletUpdateResponse.fromJson(Map<String, dynamic> j) =>
      WalletUpdateResponse(
        message: j['message'] as String,
        wid: j['wid'] as int,
        uid: j['uid'] as int,
        money: (j['money'] as num).toDouble(),
        accountId: j['account_id'] as String?,
      );
}