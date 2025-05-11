import 'package:flutter/material.dart';
import 'package:piminnovictus/Models/Transaction%20.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const TransactionCard({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(55, 109, 109, 109),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(
          transaction.type == "sell" ? Icons.arrow_downward : Icons.arrow_upward,
          color: transaction.type == "sell" ? Colors.green : Colors.red,
        ),
        title: Row(
          children: [
            Text(
              "Power: ${transaction.power.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: transaction.type == "sell" ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                transaction.type.toUpperCase(),
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: transaction.type == "sell" ? Colors.green[800] : Colors.red[800],
                ),
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: ${transaction.price?.toStringAsFixed(2) ?? 'N/A'} GRE"),
            Text(
              "Date: ${transaction.date.day}/${transaction.date.month}/${transaction.date.year} ${transaction.date.hour}:${transaction.date.minute.toString().padLeft(2, '0')}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
 
  }
}
