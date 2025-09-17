class CreateLottoRequest {
  final double price;
  final String number;
  final String startDate;
  final String endDate;
  final String status;

  CreateLottoRequest({
    required this.price,
    required this.number,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'number': number,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }
}
