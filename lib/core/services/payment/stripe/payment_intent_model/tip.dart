class Tip {
  final List<int>? amount;

  Tip({this.amount});

  factory Tip.fromJson(Map<String, dynamic> json) {
    return Tip(
      amount: json['amount'] != null ? List<int>.from(json['amount']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
    };
  }
}
