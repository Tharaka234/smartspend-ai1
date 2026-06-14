import 'package:flutter/material.dart';

class MonthlyReportCard extends StatelessWidget {
  final double budget;
  final double spent;

  const MonthlyReportCard({
    super.key,
    required this.budget,
    required this.spent,
  });

  @override
  Widget build(BuildContext context) {
    final double remaining = budget - spent;

    final double savingsRate =
    budget > 0 ? (remaining / budget) * 100 : 0;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Monthly Report',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Budget: Rs. ${budget.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 8),

            Text(
              'Spent: Rs. ${spent.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 8),

            Text(
              'Remaining: Rs. ${remaining.toStringAsFixed(2)}',
            ),

            const SizedBox(height: 8),

            Text(
              'Savings Rate: ${savingsRate.toStringAsFixed(1)}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}