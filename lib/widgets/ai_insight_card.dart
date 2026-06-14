import 'package:flutter/material.dart';

class AIInsightCard extends StatelessWidget {
  final double spending;
  final double budget;

  const AIInsightCard({
    super.key,
    required this.spending,
    required this.budget,
  });

  @override
  Widget build(BuildContext context) {
    String message;

    if (spending >= budget) {
      message =
      "You have exceeded your monthly budget.";
    } else if (spending > budget * 0.8) {
      message =
      "You have used more than 80% of your budget.";
    } else {
      message =
      "Great! Your spending is under control.";
    }

    return Card(
      child: ListTile(
        leading: const Icon(
          Icons.auto_awesome,
          color: Colors.amber,
        ),
        title: const Text("AI Insight"),
        subtitle: Text(message),
      ),
    );
  }
}