import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../widgets/budget_card.dart';
import '../widgets/new_transaction.dart';
import '../widgets/summary_cards.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/spending_chart.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'Weekly Groceries',
      amount: 64.20,
      date: DateTime.now(),
      category: 'Food',
    ),
    Transaction(
      id: 't2',
      title: 'City Cab Ride',
      amount: 18.50,
      date: DateTime.now(),
      category: 'Transport',
    ),
    Transaction(
      id: 't3',
      title: 'Cinema Tickets',
      amount: 25.00,
      date: DateTime.now(),
      category: 'Entertainment',
    ),
  ];

  double _monthlyBudget = 0.0;

  double get _totalSpending =>
      _userTransactions.fold(0.0, (sum, item) => sum + item.amount);

  bool get _isBudgetWarning =>
      _totalSpending >= (_monthlyBudget * 0.80);

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant_rounded,
    'Transport': Icons.directions_car_rounded,
    'Entertainment': Icons.movie_creation_rounded,
    'Bills': Icons.receipt_long_rounded,
  };

  final Map<String, Color> _categoryColors = {
    'Food': Colors.orange,
    'Transport': Colors.blue,
    'Entertainment': Colors.purple,
    'Bills': Colors.red,
  };

  void _addNewTransaction(
      String txTitle,
      double txAmount,
      String txCategory,
      ) {
    setState(() {
      _userTransactions.insert(
        0,
        Transaction(
          id: DateTime.now().toString(),
          title: txTitle,
          amount: txAmount,
          date: DateTime.now(),
          category: txCategory,
        ),
      );
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NewTransaction(
        onAddTx: _addNewTransaction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartSpend AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF00796B), // Teal color
          ),
        ),
        backgroundColor: const Color(0xFF00BFA5),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
      ),

      // ✅ FIX: FULL SCROLLABLE PAGE
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),

              BudgetCard(
                totalSpending: _totalSpending,
                monthlyBudget: _monthlyBudget,
                isBudgetWarning: _isBudgetWarning,
              ),

              const SizedBox(height: 15),

              SummaryCards(
                spent: _totalSpending,
                budget: _monthlyBudget,
                transactions: _userTransactions.length,
              ),

              const SizedBox(height: 20),

              AIInsightCard(
                spending: _totalSpending,
                budget: _monthlyBudget,
              ),

              const SizedBox(height: 15),

              const SpendingChart(),

              const SizedBox(height: 20),

              // ===== RECENT HISTORY =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent History',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _userTransactions.clear();
                      });
                    },
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ✅ FIX: shrinkWrap list (NO Expanded)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _userTransactions.length,
                itemBuilder: (ctx, index) {
                  final tx = _userTransactions[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.02),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      leading: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (_categoryColors[tx.category] ?? Colors.teal)
                              .withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _categoryIcons[tx.category] ?? Icons.payment,
                          color: _categoryColors[tx.category] ?? Colors.teal,
                        ),
                      ),
                      title: Text(
                        tx.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF263238),
                        ),
                      ),
                      subtitle: Text(
                        '${tx.category} • ${tx.date.day}/${tx.date.month}/${tx.date.year}',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                        ),
                      ),
                      trailing: Text(
                        'Rs. ${tx.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Color(0xFFD32F2F),
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 80), // space for FAB
            ],
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startAddNewTransaction(context),
        icon: const Icon(Icons.add),
        label: const Text(
          'Add Expense',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
      ),
    );
  }
}