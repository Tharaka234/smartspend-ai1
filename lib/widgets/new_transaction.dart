import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function(String, double, String) onAddTx;

  const NewTransaction({super.key, required this.onAddTx});

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedCategory = 'Food';

  final Map<String, IconData> _categoryIcons = {
    'Food': Icons.restaurant,
    'Transport': Icons.directions_car,
    'Entertainment': Icons.confirmation_number,
    'Bills': Icons.receipt_long,
  };

  void _submitData() {
    final enteredTitle = _titleController.text;
    final enteredAmount = double.tryParse(_amountController.text) ?? 0.0;

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;

    widget.onAddTx(enteredTitle, enteredAmount, _selectedCategory);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Track New Expense',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _titleController,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'What did you buy?',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.shopping_bag_outlined, color: Colors.teal),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _amountController,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              labelText: 'How much? (Rs.)',
              labelStyle: const TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.calculate, color: Colors.teal), // changed icon
            ),
            onSubmitted: (_) => _submitData(), // pressing "done" also saves
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedCategory,
            dropdownColor: Colors.black,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              labelText: 'Select Category',
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(
                _categoryIcons[_selectedCategory],
                color: Colors.teal,
              ),
            ),
            selectedItemBuilder: (BuildContext context) {
              return _categoryIcons.keys.map((String item) {
                return Text(
                  item,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                );
              }).toList();
            },
            items: _categoryIcons.keys.map((cat) {
              return DropdownMenuItem<String>(
                value: cat,
                child: Row(
                  children: [
                    Icon(
                      _categoryIcons[cat],
                      color: Colors.teal,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      cat,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) {
              setState(() {
                _selectedCategory = val!;
              });
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _submitData,
            icon: const Icon(Icons.save, color: Colors.white),
            label: const Text(
              'Save Expense',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.white,),

            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}
