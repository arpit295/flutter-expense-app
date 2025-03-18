import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:practice_expense_app/chart.dart';
import 'package:practice_expense_app/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<Transaction> transaction = [];

  final messageTextController = TextEditingController();
  final amountTextController = TextEditingController();

  String messageText = '';
  String amountText = '';
  DateTime? selectedDate;

  retrieveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? transactionJson = prefs.getString('transactions');
    if (transactionJson != null) {
      List<dynamic> transactionList = jsonDecode(transactionJson);
      setState(() {
        transaction =
            transactionList.map((e) => Transaction.fromJson(e)).toList();
      });
    }
  }

  // Save transactions to SharedPreferences
  saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String transactionJson = jsonEncode(transaction);
    await prefs.setString('transactions', transactionJson);
  }

  void presentDatePicker(StateSetter setModalState) {
    showDatePicker(
      context: context,
      firstDate: DateTime(2025),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setModalState(() {
        // Use setModalState here
        selectedDate = pickedDate;
      });
    });
  }

  List<Transaction> get recentTransaction {
    return transaction.where((transaction) {
      return transaction.date?.isAfter(
            DateTime.now().subtract(
              Duration(days: 7),
            ),
          ) ??
          false;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    retrieveTasks();
  }

  Widget buildBottomSheet(BuildContext context) {
    return StatefulBuilder(
      // Add StatefulBuilder here
      builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: messageTextController,
                onChanged: (value) {
                  messageText = value;
                },
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: amountTextController,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  amountText = value;
                },
                decoration: InputDecoration(labelText: 'Amount'),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Date : ${DateFormat.yMMMEd().format(selectedDate!)}',
                      style: TextStyle(
                          color: Colors.black, fontFamily: 'OpenSans'),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      presentDatePicker(setModalState);
                    },
                    child: Text(
                      'Choose Date',
                      style: TextStyle(
                          color: Colors.purple,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero)),
                onPressed: () {
                  setState(() {
                    if (messageText.isNotEmpty &&
                        amountText.isNotEmpty &&
                        selectedDate != null) {
                      final double? amount = double.tryParse(amountText);

                      if (amount != null && amount > 0) {
                        transaction.add(Transaction(
                            name: messageText,
                            amount: amount,
                            date: selectedDate));

                        messageTextController.clear();
                        amountTextController.clear();
                        messageText = '';
                        amountText = '';
                        selectedDate = null;

                        saveTasks();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please enter a valid amount!'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                      Navigator.pop(context);
                    }
                  });
                },
                child: Text(
                  'Add Transaction',
                  style:
                      TextStyle(color: Colors.white, fontFamily: 'QuickSand'),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 40,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        shape: CircleBorder(),
        onPressed: () {
          showModalBottomSheet(
              backgroundColor: Colors.white,
              context: context,
              builder: (context) => buildBottomSheet(context));
        },
        child: Icon(
          Icons.add,
          size: 27,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
              onPressed: () {
                showModalBottomSheet(
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (context) => buildBottomSheet(context));
              },
              icon: Icon(
                size: 27,
                Icons.add,
                color: Colors.white,
              ))
        ],
        title: Text(
          'Personal Expenses',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Chart(recentTransaction: recentTransaction),
            Expanded(
              child: transaction.isEmpty
                  ? Column(
                      children: [
                        Text(
                          'No transaction added yet !',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'OpenSans'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Flexible(
                          child: Image(
                            image: AssetImage(
                              'images/zzz-sleep-icon_74669-461.avif',
                            ),
                          ),
                        )
                      ],
                    )
                  : ListView.builder(
//                 ListView(
//                   children: transaction.map((tx) {
//                     return Card(
//                       color: Colors.white,
//                       elevation: 5,
//                       margin:
//                       EdgeInsets.symmetric(horizontal: 5, vertical: 8),
//                       child: ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.purple,
//                           foregroundColor: Colors.white,
//                           radius: 30,
//                           child: Container(
//                             padding: EdgeInsets.all(6),
//                             child: FittedBox(
//                               child: Text(
//                                 '₹${tx.amount?.toStringAsFixed(0)}',
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           tx.name!,
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'OpenSans'),
//                         ),
//                         subtitle: Text(
//                           DateFormat.yMMMd().format(tx.date!),
//                           style: TextStyle(
//                               color: Colors.grey,
//                               fontWeight: FontWeight.w600),
//                         ),
//                         trailing: TextButton(
//                           onPressed: () {
//                             setState(() {
//                               transaction.remove(tx);
//                               // Save the updated transactions
//                               saveTasks();
//                             });
//                           },
//                           child: Icon(
//                             size: 25,
//                             Icons.delete,
//                             color: Colors.red,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               )
//               ],
//             ),
//       ),
//     );
//   }
// }
                      itemCount: transaction.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 5,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              radius: 30,
                              child: Container(
                                padding: EdgeInsets.all(6),
                                child: FittedBox(
                                  child: Text(
                                    '₹${transaction[index].amount?.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              transaction[index].name!,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans'),
                            ),
                            subtitle: Text(
                              DateFormat.yMMMEd()
                                  .format(transaction[index].date!),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w600),
                            ),
                            trailing: TextButton(
                              onPressed: () {
                                setState(() {
                                  transaction.removeAt(index);
                                  saveTasks();
                                  // Save the updated transactions
                                });
                              },
                              child: Icon(
                                size: 25,
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
