import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/transaction.dart';
import '../services/database_helper.dart';
import '../widgets/budget_card.dart';
import '../widgets/new_transaction.dart';
import '../widgets/summary_cards.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/spending_chart.dart';
import '../widgets/monthly_report_card.dart';

class FinanceDashboard extends StatefulWidget {
  const FinanceDashboard({super.key});

  @override
  State<FinanceDashboard> createState() => _FinanceDashboardState();
}

class _FinanceDashboardState extends State<FinanceDashboard> {
  static const _budgetPrefsKey = 'monthly_budget';

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final txs = await DatabaseHelper.instance.getTransactions();
    final prefs = await SharedPreferences.getInstance();
    final savedBudget = prefs.getDouble(_budgetPrefsKey) ?? 0.0;

    setState(() {
      _userTransactions.clear();
      _userTransactions.addAll(txs);
      _monthlyBudget = savedBudget;
      _isLoading = false;
    });
  }

  Future<void> _saveBudget(double budget) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_budgetPrefsKey, budget);
  }

  void _setBudgetDialog() {
    final budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Set Monthly Budget'),
        content: TextField(
          controller: budgetController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'Budget (Rs.)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final enteredBudget =
              double.tryParse(budgetController.text);

              if (enteredBudget == null || enteredBudget <= 0) {
                return;
              }

              setState(() {
                _monthlyBudget = enteredBudget;
              });
              _saveBudget(enteredBudget);

              Navigator.of(ctx).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  final List<Transaction> _userTransactions = [];

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
      ) async {
    final newTx = Transaction(
      id: DateTime.now().toString(),
      title: txTitle,
      amount: txAmount,
      date: DateTime.now(),
      category: txCategory,
    );

    await DatabaseHelper.instance.insertTransaction(newTx);

    setState(() {
      _userTransactions.insert(0, newTx);
    });
  }

  Future<void> _clearAllTransactions() async {
    await DatabaseHelper.instance.clearTransactions();
    setState(() {
      _userTransactions.clear();
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SmartSpend AI',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xFF00796B),
          ),
        ),
        backgroundColor: const Color(0xFF00BFA5),
        surfaceTintColor: Colors.transparent,
        centerTitle: false,

        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            onPressed: _setBudgetDialog,
          ),
        ],
      ),

      // FULL SCROLLABLE PAGE
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

              MonthlyReportCard(
                budget: _monthlyBudget,
                spent: _totalSpending,
              ),

              const SizedBox(height: 20),

              AIInsightCard(
                spending: _totalSpending,
                budget: _monthlyBudget,
              ),

              const SizedBox(height: 15),

              SpendingChart(
                transactions: _userTransactions,
              ),

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
                    onPressed: _clearAllTransactions,
                    child: const Text(
                      'Clear All',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // shrinkWrap list (NO Expanded)
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
