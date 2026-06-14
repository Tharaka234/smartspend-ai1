import 'package:flutter/material.dart';

class SummaryCards extends StatelessWidget {
  final double spent;
  final double budget;
  final int transactions;

  const SummaryCards({
    super.key,
    required this.spent,
    required this.budget,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _card('Spent', 'Rs. ${spent.toStringAsFixed(0)}'),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _card(
            'Left',
            'Rs. ${(budget - spent).toStringAsFixed(0)}',
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _card(
            'Records',
            transactions.toString(),
          ),
        ),
      ],
    );
  }

  Widget _card(String title, String value) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 6),
            Text(title),
          ],
        ),
      ),
    );
  }
}