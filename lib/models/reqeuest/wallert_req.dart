class UpdateWalletRequest {
  final String? bank;
  final String? accountId;
  final double? money;

  UpdateWalletRequest({
    this.bank,
    this.accountId,
    this.money,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (accountId != null && accountId!.trim().isNotEmpty) {
      // ถ้ามี bank ด้วย → รวมเข้ากับ account_id
      data['account_id'] = (bank != null && bank!.trim().isNotEmpty)
          ? '${bank!.trim()}:${accountId!.trim()}'
          : accountId!.trim();
    }
    if (money != null) {
      data['money'] = money;
    }
    return data;
  }
}
