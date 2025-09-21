class CheckRewardItem {
  final int oid;
  final int lid;
  final String rank;     // บางทีเป็น "N/A" ได้ ถ้าไม่มี
  final int prizeEach;   // ถ้า backend ส่งเป็น number ไม่มีจุด ใช้ int
  final int amount;
  final int prizeTotal;

  CheckRewardItem({
    required this.oid,
    required this.lid,
    required this.rank,
    required this.prizeEach,
    required this.amount,
    required this.prizeTotal,
  });

  factory CheckRewardItem.fromJson(Map<String, dynamic> json) {
    // ป้องกัน type double/int จาก backend
    int _toInt(dynamic v) => (v is int) ? v : (v is double) ? v.toInt() : int.parse(v.toString());

    return CheckRewardItem(
      oid: _toInt(json['oid']),
      lid: _toInt(json['lid']),
      rank: (json['rank'] ?? '').toString(),
      prizeEach: _toInt(json['prizeEach']),
      amount: _toInt(json['amount']),
      prizeTotal: _toInt(json['prizeTotal']),
    );
  }
}
