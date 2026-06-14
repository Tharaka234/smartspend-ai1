import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SpendingChart extends StatelessWidget {
  const SpendingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 220,
        child: PieChart(
          PieChartData(
            sections: [
              PieChartSectionData(
                value: 64,
                title: 'Food',
              ),
              PieChartSectionData(
                value: 18,
                title: 'Transport',
              ),
              PieChartSectionData(
                value: 25,
                title: 'Fun',
              ),
            ],
          ),
        ),
      ),
    );
  }
}