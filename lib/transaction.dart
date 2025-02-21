class Transaction {
  // final String? id;
  final String? name;
  final double? amount;
  final DateTime? date;

  Transaction({
    // this.id,
    this.name,
    this.amount,
    this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      // 'id': id,
      'name': name,
      'amount': amount,
      'date': date?.toString(),
    };
  }

  // Convert a map to a Transaction object
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      // id: json['id'],
      name: json['name'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
    );
  }
}
