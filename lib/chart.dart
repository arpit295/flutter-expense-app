import 'package:practice_expense_app/chart_bar.dart';
import 'package:practice_expense_app/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransaction;
  Chart({required this.recentTransaction});

  List<Map<String, Object>> get groupedTransactionValue {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      var totalSum = 0.0;
      for (var index = 0; index < recentTransaction.length; index++) {
        if (recentTransaction[index].date?.day == weekDay.day &&
            recentTransaction[index].date?.month == weekDay.month &&
            recentTransaction[index].date?.year == weekDay.year) {
          totalSum += recentTransaction[index].amount!;
        }
      }
      return {
        'day': DateFormat.E().format(weekDay).substring(0, 3),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValue.fold(0.0, (sum, item) {
      return sum + (item['amount'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValue.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                label: data['day'].toString(),
                spendingAmount: data['amount'] as double,
                spendingPCTOfTotal: totalSpending == 0
                    ? 0
                    : (data['amount'] as double) /
                        totalSpending, // Percentage abhi default 0.0 rakh diya
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
