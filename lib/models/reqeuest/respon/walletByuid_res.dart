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

class UpdateWalletResponse {
  final bool success;
  final String? message;
  final double? money; // เงินล่าสุดหลังอัพเดต
  final String? accountId;

  UpdateWalletResponse({
    required this.success,
    this.message,
    this.money,
    this.accountId,
  });

  factory UpdateWalletResponse.fromJson(Map<String, dynamic> json) {
    return UpdateWalletResponse(
      success: json['success'] ?? false,
      message: json['message'],
      money: (json['money'] is num) ? (json['money'] as num).toDouble() : null,
      accountId: json['account_id'],
    );
  }
}
