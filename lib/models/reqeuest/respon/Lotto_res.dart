import 'dart:convert';

class LottoResponse {
  final List<Lottery> lotteries;

  LottoResponse({required this.lotteries});

  factory LottoResponse.fromJson(List<dynamic> json) {
    return LottoResponse(
      lotteries: json
          .map((lotteryJson) => Lottery.fromJson(lotteryJson))
          .toList(),
    );
  }
}

class Lottery {
  final int lid;
  final int uid;
  final double price;
  final String number;
  final String startDate;
  final String endDate;
  final String status;

  Lottery({
    required this.lid,
    required this.uid,
    required this.price,
    required this.number,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Lottery.fromJson(Map<String, dynamic> json) {
    return Lottery(
      lid: json['lid'] as int,
      uid: json['uid'] as int,
      price: double.parse(
        json['price'].toString(),
      ), // Handle potential type issues
      number: json['number'] as String,
      startDate: json['start_date'] as String,
      endDate: json['end_date'] as String,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lid': lid,
      'uid': uid,
      'price': price,
      'number': number,
      'start_date': startDate,
      'end_date': endDate,
      'status': status,
    };
  }
}
