import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/transaction.dart';

class SpendingChart extends StatelessWidget {
  final List<Transaction> transactions;

  const SpendingChart({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
    final Map<String, double> categoryTotals = {};

    for (var tx in transactions) {
      categoryTotals.update(
        tx.category,
            (value) => value + tx.amount,
        ifAbsent: () => tx.amount,
      );
    }

    return Card(
      child: SizedBox(
        height: 250,
        child: PieChart(
          PieChartData(
            sections: categoryTotals.entries.map((entry) {
              return PieChartSectionData(
                value: entry.value,
                title: entry.key,
                radius: 90,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}