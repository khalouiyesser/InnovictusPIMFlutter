import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/Transaction%20.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      //color: transaction.type == "buy" ? Colors.green[100] : const Color.fromARGB(255, 109, 109, 109),
      color: const Color.fromARGB(255, 109, 109, 109),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          transaction.type == "buy" ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.type == "buy" ? Colors.green : Colors.red,
        ),
        title: Text(
          "Power: ${transaction.power.toStringAsFixed(2)}",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text("Amount: ${transaction.amount.toStringAsFixed(2)} GRE"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Price: ${transaction.price.toStringAsFixed(2)}"),
            Text(
              transaction.type.toUpperCase(),
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
