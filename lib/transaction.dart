class Transaction {
  // final String? id;
  final String? name;
  final double? amount;
  final DateTime? date;

  Transaction({
    // this.id,
    required this.name,
    required this.amount,
    required this.date,
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

// int string bool double hoi to direct store thai jai pn ahiya alg datatype che DateTime no to ana mate aapde json ma convert karvu pade
// sharedpreference ma string ma data store karvana hoi atle aapde list ne string ma convert karvanu.string means json ma convert karvu pade.
// saveTasks() async {
//   final prefs = await SharedPreferences.getInstance();
//   final String transactionJson = jsonEncode(transaction);
//   await prefs.setString('transactions', transactionJson);
// }

// aa function ma jsonencode atle json ma convert kare che pn toJSon() function aapde transaction.dart ma na lakhyu hoi to ane khber na pade ke kevi rite json ma convert karvanu
// retrieveTasks() async {
//   final prefs = await SharedPreferences.getInstance();
//   final String? transactionJson = prefs.getString('transactions');
//   if (transactionJson != null) {
//     List<dynamic> transactionList = jsonDecode(transactionJson);
//     setState(() {
//       transaction =
//           transactionList.map((e) => Transaction.fromJson(e)).toList();
//     });
//   }
// }

// retrieve transaction ma aapde jsondecode use karyu atle json mathi normal list ma convert karvani process. pan aapde fromJSOn() na lakhiye to ane khber na pade ke kevi rite json mathi normal list ma convert karvanu.
