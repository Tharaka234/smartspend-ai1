import 'package:flutter/material.dart';

class BudgetCard extends StatelessWidget {
  final double totalSpending;
  final double monthlyBudget;
  final bool isBudgetWarning;


  const BudgetCard({
    super.key,
    required this.totalSpending,
    required this.monthlyBudget,
    required this.isBudgetWarning,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = (totalSpending / monthlyBudget).clamp(0.0, 1.0);
    final remainingBudget = monthlyBudget - totalSpending;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isBudgetWarning
              ? [const Color(0xFFD32F2F), const Color(0xFFEF5350)]
              : [const Color(0xFF004D40), const Color(0xFF00796B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isBudgetWarning ? Colors.red : Colors.teal).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Monthly Balance Status',
                  style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isBudgetWarning ? 'Limit Warning' : 'Safe Zone',
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '\$${totalSpending.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Budget: \$${monthlyBudget.toStringAsFixed(0)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400),
                ),
                Text(
                  remainingBudget >= 0
                      ? 'Left: \$${remainingBudget.toStringAsFixed(2)}'
                      : 'Over: \$${(remainingBudget * -1).toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: ratio,
                backgroundColor: Colors.white.withOpacity(0.15),
                color: isBudgetWarning ? Colors.amber : const Color(0xFF00BFA5),
                minHeight: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}