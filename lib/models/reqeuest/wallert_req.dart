class CreateWalletRequest {
  final int uid;
  final String? accountId;
  CreateWalletRequest({required this.uid, this.accountId});
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'account_id': accountId,
      };
}

class WalletAmountRequest {
  final double amount;
  WalletAmountRequest(this.amount);
  Map<String, dynamic> toJson() => {'amount': amount};
}

class WalletUpdateRequest {
  final String? accountId;
  final double? money; // ถ้าไม่ส่งให้เป็น null
  WalletUpdateRequest({this.accountId, this.money});
  Map<String, dynamic> toJson() => {
        if (accountId != null) 'account_id': accountId,
        if (money != null) 'money': money,
      };
}